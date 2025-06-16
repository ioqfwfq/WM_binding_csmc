# Time-Resolved Neural Selectivity Analysis
# Quantifying % of neurons selective for different aspects as function of time

# %%
"""
===================================================================================
STEP 1: ENVIRONMENT SETUP AND IMPORTS
===================================================================================
"""

# Core data manipulation and analysis
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from scipy import stats
from scipy.io import loadmat
import warnings
warnings.filterwarnings('ignore')

# Statistical analysis
import statsmodels.formula.api as smf
import statsmodels.api as sm
from statsmodels.stats.multicomp import multipletests

# Progress tracking
from tqdm import tqdm

# Set plotting style
plt.style.use('default')
sns.set_palette("husl")
plt.rcParams['figure.figsize'] = (12, 8)
plt.rcParams['font.size'] = 12

print("✓ All packages imported successfully")
print("✓ Environment setup complete")

# %%
"""
===================================================================================
STEP 2: LOAD EXISTING DATA
===================================================================================
Based on your existing neural_basic_selectivity.ipynb analysis
"""

# Load your processed data (adapt path as needed)
# You should have 'data_filtered' DataFrame from your previous analysis
print("Loading processed neural data...")

# If you need to reload from scratch, uncomment and adapt:
# data_filtered = pd.read_pickle('path_to_your_processed_data.pkl')
# Or reload from MATLAB files using your existing loading code

# For now, let's assume data_filtered is available
# Verify data structure
print(f"Data shape: {data_filtered.shape if 'data_filtered' in locals() else 'data_filtered not found'}")
print("Expected columns: unit_id, timestamps, brainAreaOfCell, trial_nr, first_cat_simple, etc.")

# %%
"""
===================================================================================
STEP 3: DEFINE TIME ANALYSIS PARAMETERS
===================================================================================
"""

class TimeAnalysisConfig:
    """Configuration parameters for time-resolved analysis"""
    
    # Time window parameters (all in milliseconds)
    WINDOW_WIDTH = 100      # Width of each analysis window
    STEP_SIZE = 25         # Step between windows (creates 4x overlap)
    
    # Analysis period relative to stimulus onset
    TIME_START = -500      # Pre-stimulus baseline
    TIME_END = 2500        # Post-stimulus through response
    
    # Statistical parameters
    P_THRESHOLD = 0.05     # Significance threshold for selectivity
    MIN_TRIALS = 10        # Minimum trials per condition per neuron
    MIN_FIRING_RATE = 0.5  # Minimum average firing rate (Hz)
    
    # Event timings (in ms, relative to first stimulus)
    EVENTS = {
        'first_stimulus': 0,
        'delay1': 1000,
        'second_stimulus': 2000, 
        'delay2': 3000,
        'probe': 4000,
        'response': 5000
    }

config = TimeAnalysisConfig()

# Generate time windows
time_windows = []
window_centers = []

for t_start in range(config.TIME_START, config.TIME_END - config.WINDOW_WIDTH, config.STEP_SIZE):
    t_end = t_start + config.WINDOW_WIDTH
    time_windows.append((t_start, t_end))
    window_centers.append(t_start + config.WINDOW_WIDTH // 2)

print(f"✓ Created {len(time_windows)} time windows")
print(f"✓ Window width: {config.WINDOW_WIDTH}ms, Step: {config.STEP_SIZE}ms")
print(f"✓ Analysis period: {config.TIME_START}ms to {config.TIME_END}ms")
print(f"✓ First few window centers: {window_centers[:5]}ms")

# %%
"""
===================================================================================
STEP 4: EXTRACT TRIAL-ALIGNED SPIKE TIMES
===================================================================================
"""

def extract_trial_aligned_spikes(data_filtered, unit_id, alignment_event='first_stimulus'):
    """
    Extract spike times aligned to a specific task event for one neuron.
    
    Parameters:
    -----------
    data_filtered : DataFrame
        Neural data with timestamps and trial info
    unit_id : int
        Unit identifier
    alignment_event : str
        Event to align to ('first_stimulus', 'second_stimulus', etc.)
        
    Returns:
    --------
    dict : Trial-aligned spike times and condition info
    """
    
    # Get data for this unit
    unit_data = data_filtered[data_filtered['unit_id'] == unit_id].copy()
    
    if len(unit_data) == 0:
        return {}
    
    # Get spike timestamps (convert to seconds)
    spike_times = np.asarray(unit_data["timestamps"].iloc[0]).flatten() / 1e6
    
    # Get trial events and alignment indices
    events = unit_data['events'].iloc[0].squeeze()
    
    # Choose alignment based on event type
    if alignment_event == 'first_stimulus':
        align_indices = unit_data['idxEnc1'].iloc[0].squeeze() - 1
    elif alignment_event == 'second_stimulus':
        align_indices = unit_data['idxEnc2'].iloc[0].squeeze() - 1
    elif alignment_event == 'probe':
        align_indices = unit_data['idxProbeOn'].iloc[0].squeeze() - 1
    else:
        align_indices = unit_data['idxEnc1'].iloc[0].squeeze() - 1  # Default to first stimulus
    
    trial_data = {}
    
    # Extract spikes for each trial
    for trial_idx, event_idx in enumerate(align_indices):
        try:
            # Get alignment time for this trial
            align_time = events[event_idx, 0] / 1e6  # Convert to seconds
            
            # Extract spikes in analysis window around alignment
            window_start = align_time + config.TIME_START / 1000  # Convert ms to s
            window_end = align_time + config.TIME_END / 1000
            
            trial_spikes = spike_times[(spike_times >= window_start) & (spike_times <= window_end)]
            trial_spikes_aligned = (trial_spikes - align_time) * 1000  # Convert to ms relative to event
            
            # Get trial conditions
            trial_data[trial_idx] = {
                'spikes': trial_spikes_aligned,
                'first_cat': unit_data.iloc[trial_idx]['first_cat_simple'],
                'second_cat': unit_data.iloc[trial_idx]['second_cat_simple'],
                'first_num': unit_data.iloc[trial_idx]['first_num_simple'],
                'second_num': unit_data.iloc[trial_idx]['second_num_simple'],
                'probe_validity': unit_data.iloc[trial_idx].get('probe_validity', 'unknown')
            }
            
        except (IndexError, KeyError):
            # Skip trials with missing data
            continue
            
    return trial_data

# Test the function
print("✓ Trial alignment function defined")
print("Testing with first unit...")

if 'data_filtered' in locals():
    test_unit = data_filtered['unit_id'].iloc[0]
    test_spikes = extract_trial_aligned_spikes(data_filtered, test_unit)
    print(f"✓ Extracted {len(test_spikes)} trials for unit {test_unit}")
    if len(test_spikes) > 0:
        first_trial = list(test_spikes.values())[0]
        print(f"✓ First trial has {len(first_trial['spikes'])} spikes")
        print(f"✓ Conditions: cat={first_trial['first_cat']}, num={first_trial['first_num']}")

# %%
"""
===================================================================================
STEP 5: COMPUTE SLIDING WINDOW FIRING RATES
===================================================================================
"""

def compute_sliding_window_firing_rates(trial_aligned_spikes, time_windows):
    """
    Compute firing rates in sliding time windows for all trials.
    
    Parameters:
    -----------
    trial_aligned_spikes : dict
        Output from extract_trial_aligned_spikes()
    time_windows : list
        List of (start_time, end_time) tuples in milliseconds
        
    Returns:
    --------
    DataFrame : Firing rates and conditions for each trial and time window
    """
    
    results = []
    
    for trial_idx, trial_data in trial_aligned_spikes.items():
        spikes = trial_data['spikes']
        
        for window_idx, (t_start, t_end) in enumerate(time_windows):
            # Count spikes in this window
            spike_count = np.sum((spikes >= t_start) & (spikes < t_end))
            
            # Convert to firing rate (Hz)
            window_duration = (t_end - t_start) / 1000  # Convert ms to seconds
            firing_rate = spike_count / window_duration
            
            # Store results
            results.append({
                'trial_idx': trial_idx,
                'window_idx': window_idx,
                'window_start': t_start,
                'window_end': t_end,
                'window_center': (t_start + t_end) / 2,
                'firing_rate': firing_rate,
                'spike_count': spike_count,
                'first_cat': trial_data['first_cat'],
                'second_cat': trial_data['second_cat'],
                'first_num': trial_data['first_num'],
                'second_num': trial_data['second_num'],
                'probe_validity': trial_data['probe_validity']
            })
    
    return pd.DataFrame(results)

# Test the function
print("✓ Sliding window firing rate function defined")

if 'test_spikes' in locals() and len(test_spikes) > 0:
    test_rates = compute_sliding_window_firing_rates(test_spikes, time_windows[:10])  # Test first 10 windows
    print(f"✓ Computed firing rates: {test_rates.shape}")
    print(f"✓ Average firing rate: {test_rates['firing_rate'].mean():.2f} Hz")
    print("✓ Sample data:")
    print(test_rates[['window_center', 'firing_rate', 'first_cat', 'first_num']].head())

# %%
"""
===================================================================================
STEP 6: TEST SELECTIVITY AT SINGLE TIME POINT
===================================================================================
"""

def test_selectivity_at_timepoint(firing_rate_data, window_center):
    """
    Test neural selectivity for all neurons at a specific time point.
    
    Parameters:
    -----------
    firing_rate_data : DataFrame
        Firing rates for all units and trials at this timepoint
    window_center : float
        Time point being analyzed (ms)
        
    Returns:
    --------
    DataFrame : Selectivity test results for each neuron
    """
    
    results = []
    
    # Group by unit
    for unit_id, unit_data in firing_rate_data.groupby('unit_id'):
        
        # Check minimum requirements
        if len(unit_data) < config.MIN_TRIALS:
            continue
            
        if unit_data['firing_rate'].mean() < config.MIN_FIRING_RATE:
            continue
            
        # Skip if no variance
        if unit_data['firing_rate'].std() == 0:
            continue
        
        try:
            # Test category selectivity for first stimulus
            categories = unit_data['first_cat'].unique()
            if len(categories) > 1:
                cat1_pval = stats.f_oneway(*[unit_data[unit_data['first_cat'] == cat]['firing_rate'] 
                                           for cat in categories]).pvalue
            else:
                cat1_pval = 1.0
            
            # Test category selectivity for second stimulus  
            categories = unit_data['second_cat'].unique()
            if len(categories) > 1:
                cat2_pval = stats.f_oneway(*[unit_data[unit_data['second_cat'] == cat]['firing_rate'] 
                                           for cat in categories]).pvalue
            else:
                cat2_pval = 1.0
            
            # Test numerosity selectivity for first stimulus
            numbers = unit_data['first_num'].unique()
            if len(numbers) > 1:
                num1_pval = stats.f_oneway(*[unit_data[unit_data['first_num'] == num]['firing_rate'] 
                                           for num in numbers]).pvalue
            else:
                num1_pval = 1.0
                
            # Test numerosity selectivity for second stimulus
            numbers = unit_data['second_num'].unique()
            if len(numbers) > 1:
                num2_pval = stats.f_oneway(*[unit_data[unit_data['second_num'] == num]['firing_rate'] 
                                           for num in numbers]).pvalue
            else:
                num2_pval = 1.0
            
            # Store results
            results.append({
                'unit_id': unit_id,
                'window_center': window_center,
                'n_trials': len(unit_data),
                'mean_firing_rate': unit_data['firing_rate'].mean(),
                'cat1_pval': cat1_pval,
                'cat2_pval': cat2_pval, 
                'num1_pval': num1_pval,
                'num2_pval': num2_pval,
                'cat1_selective': cat1_pval < config.P_THRESHOLD,
                'cat2_selective': cat2_pval < config.P_THRESHOLD,
                'num1_selective': num1_pval < config.P_THRESHOLD,
                'num2_selective': num2_pval < config.P_THRESHOLD
            })
            
        except Exception as e:
            # Handle any statistical errors
            continue
    
    return pd.DataFrame(results)

print("✓ Single timepoint selectivity function defined")

# %%
"""
===================================================================================
STEP 7: MAIN ANALYSIS PIPELINE
===================================================================================
"""

def analyze_time_resolved_selectivity(data_filtered, alignment_event='first_stimulus'):
    """
    Main function to run complete time-resolved selectivity analysis.
    
    Parameters:
    -----------
    data_filtered : DataFrame
        Processed neural data
    alignment_event : str
        Event to align analysis to
        
    Returns:
    --------
    tuple : (population_timecourse, all_selectivity_results)
    """
    
    print(f"Starting time-resolved selectivity analysis...")
    print(f"Alignment event: {alignment_event}")
    print(f"Analyzing {len(data_filtered['unit_id'].unique())} units...")
    
    # Get all unique units
    all_units = data_filtered['unit_id'].unique()
    all_selectivity_results = []
    
    # Process each time window
    for window_idx, window_center in enumerate(tqdm(window_centers, desc="Processing time windows")):
        
        # Collect firing rates for all units at this timepoint
        timepoint_data = []
        
        for unit_id in all_units:
            # Extract trial-aligned spikes for this unit
            trial_spikes = extract_trial_aligned_spikes(data_filtered, unit_id, alignment_event)
            
            if len(trial_spikes) == 0:
                continue
                
            # Compute firing rates in current window
            unit_rates = compute_sliding_window_firing_rates(trial_spikes, [time_windows[window_idx]])
            
            if len(unit_rates) > 0:
                unit_rates['unit_id'] = unit_id
                timepoint_data.append(unit_rates)
        
        if len(timepoint_data) == 0:
            continue
            
        # Combine all units for this timepoint
        timepoint_df = pd.concat(timepoint_data, ignore_index=True)
        
        # Test selectivity at this timepoint
        selectivity_results = test_selectivity_at_timepoint(timepoint_df, window_center)
        all_selectivity_results.append(selectivity_results)
    
    # Combine results across time
    if len(all_selectivity_results) > 0:
        full_results = pd.concat(all_selectivity_results, ignore_index=True)
        
        # Calculate population percentages
        population_timecourse = full_results.groupby('window_center').agg({
            'cat1_selective': 'mean',
            'cat2_selective': 'mean', 
            'num1_selective': 'mean',
            'num2_selective': 'mean',
            'unit_id': 'count'
        }).reset_index()
        
        population_timecourse.columns = ['time_ms', 'pct_cat1_selective', 'pct_cat2_selective', 
                                       'pct_num1_selective', 'pct_num2_selective', 'n_units']
        
        # Convert to percentages
        for col in ['pct_cat1_selective', 'pct_cat2_selective', 'pct_num1_selective', 'pct_num2_selective']:
            population_timecourse[col] *= 100
        
        print(f"✓ Analysis complete!")
        print(f"✓ {len(population_timecourse)} timepoints analyzed")
        print(f"✓ Average {population_timecourse['n_units'].mean():.1f} units per timepoint")
        
        return population_timecourse, full_results
    
    else:
        print("✗ No results generated - check data format")
        return None, None

print("✓ Main analysis pipeline defined")
print("\n" + "="*60)
print("SETUP COMPLETE! Ready to run analysis.")
print("="*60)

# %%
"""
===================================================================================
NEXT STEPS TO RUN THE ANALYSIS
===================================================================================

1. Make sure your 'data_filtered' DataFrame is loaded
2. Run the analysis:
   
   population_timecourse, full_results = analyze_time_resolved_selectivity(data_filtered)
   
3. Visualize results (code for plotting will be in next section)

Uncomment the line below when ready to run:
"""

# population_timecourse, full_results = analyze_time_resolved_selectivity(data_filtered)