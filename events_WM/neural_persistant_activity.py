#!/usr/bin/env python
# -*- coding: utf-8 -*-

# %%
"""
# WM conjunction coding
# persistant activity
"""

import sys
print(sys.executable)

# %%
# pip install numpy pandas matplotlib seaborn scipy mat73
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np
from scipy.io import loadmat
from scipy.stats import ttest_1samp
import glob
import os
# import mat73

# %%
"""
# Load data

## Loading MATLAB objects
"""

# Find all WMB_P*_v7.mat files in the current directory
mat_files = glob.glob('./WMB_P*_v7.mat')
print(f"Found {len(mat_files)} .mat files: {[os.path.basename(f) for f in mat_files]}")

# Initialize lists to store data from each file
cell_mats = []
total_mats = []

# Load each file and append its data
for mat_file in mat_files:
    print(f"\nLoading {mat_file}...")
    mat_data = loadmat(mat_file)
    cell_mats.append(mat_data['cellStatsAll'])
    total_mats.append(mat_data['totStats'])

# Print shapes of loaded data for debugging
print("\nShapes of loaded data:")
for i, (cell, total) in enumerate(zip(cell_mats, total_mats)):
    print(f"File {i}: cell_mat shape: {cell.shape}, total_mat shape: {total.shape}")
# %%
# Combine the data
# For cell_mat, we need to handle the different dimensions
# First, convert each cell_mat to a list of records
all_cell_records = []
for cell_mat in cell_mats:
    # Convert to list of records
    cell_list = cell_mat[0]  # now shape is (n,)
    records = []
    for cell in cell_list:
        record = {key: cell[key] for key in cell.dtype.names}
        records.append(record)
    all_cell_records.extend(records)

# Convert combined records to DataFrame
df = pd.DataFrame(all_cell_records)

# For total_mat, we can concatenate directly since they have the same structure
total_mat = np.concatenate(total_mats, axis=0)

print(f"\nCombined data shape - total_mat: {total_mat.shape}")
print(f"\nCombined data shape - df: {df.shape}")

# %%
"""
## basic database stats
"""

from collections import Counter

def count_area_codes(area_column):
    """
    Translates numeric area codes to text labels and counts their occurrences.

    Args:
        area_column (array-like): A list or array of area code numbers.
        addMicroPrefix (bool): If True, prepend 'micro-' to each area label.

    Returns:
        dict: A dictionary mapping area label to its count.
    """
    mapping = {
        1: 'RH', 2: 'LH', 3: 'RA', 4: 'LA', 5: 'RAC', 6: 'LAC',
        7: 'RSMA', 8: 'LSMA', 9: 'RPT', 10: 'LPT', 11: 'ROFC', 12: 'LOFC',
        50: 'RFFA', 51: 'REC', 52: 'RCM', 53: 'LCM', 54: 'RPUL', 55: 'LPUL',
        56: 'N/A', 57: 'RPRV', 58: 'LPRV'
    }
    
    labels = []
    for code in area_column:
        label = mapping.get(code, 'Unknown')
        labels.append(label)
    
    return dict(Counter(labels))

# %%
# neuron number in each area
area_codes = total_mat[:, 3]

counts = count_area_codes(area_codes)
print("Area counts (no prefix):")
for area, count in counts.items():
    print(f"{area}: {count}")

# %%
"""
# Format cell data

### Brain area
"""

collapsed_area_map = {
    1: 'H', 2: 'H',
    3: 'A', 4: 'A',
    5: 'AC', 6: 'AC',
    7: 'SMA', 8: 'SMA',
    9: 'PT', 10: 'PT',
    11: 'OFC', 12: 'OFC',
    50: 'FFA', 51: 'EC',
    52: 'CM', 53: 'CM',
    54: 'PUL', 55: 'PUL',
    56: 'N/A', 57: 'PRV', 58: 'PRV'
}

# %%
# Convert brain area codes in the DataFrame
df['brainAreaOfCell'] = df['brainAreaOfCell'].apply(
    lambda x: collapsed_area_map.get(int(x[0, 0]), 'Unknown') if isinstance(x, np.ndarray) else collapsed_area_map.get(x, 'Unknown')
)

# %%
"""
### Filter out units with low firing rate
"""

# Filter out units with low firing rate
fr = df['timestamps'].apply(lambda x: len(x) / (x[-1] - x[0]) * 1e6)
df_sample_new = df[fr > 0.1].reset_index(drop=True)

# unit id
df_sample_new = df_sample_new.reset_index(drop=True)
df_sample_new["unit_id"] = df_sample_new.index

# %%
"""
# Detailed inspection of the Trials column in first row
"""
print("\nDetailed inspection of first row's Trials:")
first_row = df_sample_new.iloc[0]
trials_data = first_row['Trials']

print("\n1. Basic information:")
print(f"Type: {type(trials_data)}")
print(f"Shape: {trials_data.shape if hasattr(trials_data, 'shape') else 'No shape'}")
print(f"Is array: {isinstance(trials_data, np.ndarray)}")

print("\n2. Structure information:")
if isinstance(trials_data, np.ndarray):
    print(f"Array dtype: {trials_data.dtype}")
    if trials_data.dtype.names:
        print(f"Field names: {trials_data.dtype.names}")
        print("\n3. First element structure:")
        first_element = trials_data[0]
        print(f"First element type: {type(first_element)}")
        print(f"First element shape: {first_element.shape if hasattr(first_element, 'shape') else 'No shape'}")
        if hasattr(first_element, 'dtype') and first_element.dtype.names:
            print(f"First element fields: {first_element.dtype.names}")
            # Print first few values of each field
            print("\n4. First element field values:")
            for field in first_element.dtype.names:
                value = first_element[field]
                print(f"{field}: {value} (type: {type(value)})")

# %%
"""
# Extract trial info
"""

def extract_trial_info(trials_struct, unit_id):
    """
    Extract trial information from the trials structure and create a DataFrame.
    
    Args:
        trials_struct: The trials structure from the .mat file
        unit_id: The unit identifier
    
    Returns:
        DataFrame containing trial information
    """
    # Flatten to a 1D array if needed
    if isinstance(trials_struct, np.ndarray) and trials_struct.ndim > 1:
        trials_list = trials_struct[0]  # now shape is (n,)
    else:
        trials_list = trials_struct

    # Extract each field into a dictionary
    records = []
    for trial in trials_list:
        record = {key: trial[key] for key in trial.dtype.names}
        records.append(record)

    # Convert list of dicts to DataFrame
    df_trial = pd.DataFrame(records)
    
    # Add the unit_id
    df_trial["unit_id"] = unit_id
    
    # Add trial number (0-based index)
    df_trial["trial_nr"] = df_trial.index
    
    return df_trial

# %%
trial_info_list = []
for idx, row in df_sample_new.iterrows():
    # Use the unit identifier from this row
    unit_id = row["unit_id"]  
    # Extract the trial DataFrame, including the unit identifier.
    trial_info_list.append(extract_trial_info(row["Trials"], unit_id))

# Concatenate the list of trial info DataFrames into one.
trial_info = pd.concat(trial_info_list, ignore_index=True)

# %%
"""
# Single unit analyses
"""

# % ttl values
# c.marker.expstart        = 89;
# c.marker.expend          = 90;
# c.marker.fixOnset        = 10;
# c.marker.pic1            = 1;
# c.marker.delay1          = 2;
# c.marker.pic2            = 3;
# c.marker.delay2          = 4;
# c.marker.probeOnset      = 5;
# c.marker.response        = 6;
# c.marker.break           = 91;

# what names are in the df
df_sample_new.columns

# %%
"""
## Baseline

### Event ts extraction
"""

# Event ts extraction
result_temp = []
for i, row in df_sample_new.iterrows():
    events = row['events'].squeeze()       # Ensure it's 1D array
    idxs1 = row['idxEnc1'].squeeze() - 1   # Ensure indices are 1D array; start with 0!!!
    idxs2 = row['idxEnc1'].squeeze() - 1
    # Index into events using the adjusted indices:
    extracted1 = events[idxs1]   # shape (n_trials, 3)
    extracted2 = events[idxs2]   # shape (n_trials, 3)

    combined = np.column_stack((extracted1[:, 0], extracted2[:, 0]))
    result_temp.append(combined)

# Save as numpy array of arrays (object dtype)
result_array_temp = np.array(result_temp, dtype=object)

# Extract the first element from each 3-element array
epoch_ts = result_array_temp

# %%
"""
### Compute baseline FR
"""

row = df_sample_new.iloc[0]

# Count spikes during epochs defined in using epoch_ts
df_sample_new["fr_baseline"] = df_sample_new.apply(
    lambda row: [
        np.searchsorted(np.ravel(row["timestamps"]), epoch_off + 0 * 1e6, side="right") 
        - np.searchsorted(np.ravel(row["timestamps"]), epoch_on - 1 * 1e6, side="left")
        for epoch_on, epoch_off in np.array(epoch_ts[row.name])
    ],
    axis=1
)
# Generate trial numbers for each row
df_sample_new["trial_nr"] = df_sample_new["fr_baseline"].apply(lambda x: np.arange(len(x)))

# %%
"""
## Epoch of interest

### Epoch ts extraction
"""

# Event ts extraction
result_temp = []
for i, row in df_sample_new.iterrows():
    events = row['events'].squeeze()       # Ensure it's 1D array
    idxs1 = row['idxEnc1'].squeeze() - 1   # Ensure indices are 1D array; start with 0!!!
    idxs2 = row['idxEnc1'].squeeze() - 1
    # Index into events using the adjusted indices:
    extracted1 = events[idxs1]   # shape (n_trials, 3)
    extracted2 = events[idxs2]   # shape (n_trials, 3)

    combined = np.column_stack((extracted1[:, 0], extracted2[:, 0]))
    result_temp.append(combined)

# Save as numpy array of arrays (object dtype)
result_array_temp = np.array(result_temp, dtype=object)

# Extract the first element from each 3-element array
epoch_ts = result_array_temp

# %%
"""
#### If use different alignment
"""

# Event ts extraction
result_temp = []
for i, row in df_sample_new.iterrows():
    events = row['events'].squeeze()       # Ensure it's 1D array
    idxs1 = row['idxEnc2'].squeeze() - 1   # Ensure indices are 1D array; start with 0!!!
    idxs2 = row['idxEnc2'].squeeze() - 1
    # Index into events using the adjusted indices:
    extracted1 = events[idxs1]   # shape (n_trials, 3)
    extracted2 = events[idxs2]   # shape (n_trials, 3)

    combined = np.column_stack((extracted1[:, 0], extracted2[:, 0]))
    result_temp.append(combined)

# Save as numpy array of arrays (object dtype)
result_array_temp = np.array(result_temp, dtype=object)

# Extract the first element from each 3-element array
epoch_ts_align = result_array_temp

# %%
"""
### Compute epoch FR
"""

row = df_sample_new.iloc[0]

# Count spikes during epochs defined in using epoch_ts
df_sample_new["fr_epoch"] = df_sample_new.apply(
    lambda row: [
        np.searchsorted(np.ravel(row["timestamps"]), epoch_off + 1 * 1e6, side="right") 
        - np.searchsorted(np.ravel(row["timestamps"]), epoch_on - 0 * 1e6, side="left")
        for epoch_on, epoch_off in np.array(epoch_ts[row.name])
    ],
    axis=1
)

# %%
"""
## Save data
"""

# Convert lists to rows
df_sample_new = df_sample_new.explode(["fr_epoch", "trial_nr", "fr_baseline"])
# delete df_sample_new["trials"]
df_sample_new = df_sample_new.drop(columns=["Trials"])

df_sample_new.head()

# %%
"""
## Join df
"""

df_sample_new = df_sample_new.reset_index(drop=True)
trial_info = trial_info.reset_index(drop=True)

data = pd.merge(
    df_sample_new,
    trial_info,
    on=["unit_id", "trial_nr"],
    how="left",
).infer_objects()

cols_to_keep = [
    "unit_id", "timestamps", "brainAreaOfCell", "fr_epoch","fr_baseline", "trial_nr",
    "first_cat", "second_cat", "first_num", "second_num",
    "first_pic", "second_pic", "probe_cat", "probe_pic",
    "probe_validity", "probe_num", "correct_answer",
    "rt", "acc", "key", "cat_comparison"
]

data_filtered = data[cols_to_keep]

# %%
"""
## Tuning Analysis
"""

from tqdm import tqdm
import statsmodels.formula.api as smf
import statsmodels.api as sm

# %%
"""
### Find best cat and num
"""

# Convert to simpler, hashable values.
data_filtered["first_cat_simple"] = data_filtered["first_cat"].apply(
    lambda x: str(np.squeeze(x)) if isinstance(x, (list, np.ndarray)) else str(x)
)
data_filtered["second_cat_simple"] = data_filtered["second_cat"].apply(
    lambda x: str(np.squeeze(x)) if isinstance(x, (list, np.ndarray)) else str(x)
)
data_filtered["first_num_simple"] = data_filtered["first_num"].apply(
    lambda x: str(np.squeeze(x)) if isinstance(x, (list, np.ndarray)) else str(x)
)
data_filtered["second_num_simple"] = data_filtered["second_num"].apply(
    lambda x: str(np.squeeze(x)) if isinstance(x, (list, np.ndarray)) else str(x)
)

# %%
# 1) Compute mean fr_epoch for each (unit, first_cat)
cat_means = (
    data_filtered
    .groupby(["unit_id", "first_cat_simple"], as_index=False)["fr_epoch"]
    .mean()
    .rename(columns={"fr_epoch": "mean_fr"})
)

# Pick the category with the highest mean_fr for each unit
best_cat = (
    cat_means
    .loc[cat_means.groupby("unit_id")["mean_fr"].idxmax(), ["unit_id", "first_cat_simple"]]
    .rename(columns={"first_cat_simple": "best_cat"})
)

# %%
# 2) Compute mean fr_epoch for each (unit, first_num)
num_means = (
    data_filtered
    .groupby(["unit_id", "first_num_simple"], as_index=False)["fr_epoch"]
    .mean()
    .rename(columns={"fr_epoch": "mean_fr"})
)

# Pick the number with the highest mean_fr for each unit
best_num = (
    num_means
    .loc[num_means.groupby("unit_id")["mean_fr"].idxmax(), ["unit_id", "first_num_simple"]]
    .rename(columns={"first_num_simple": "best_num"})
)

# %%
# 3) Merge these labels back onto trial‐level DataFrame
data_filtered = (
    data_filtered
    .merge(best_cat, on="unit_id")
    .merge(best_num, on="unit_id")
)

data_filtered.columns

# %%
"""
### Find responsive units
"""

resp = []
for unit_id, unit_df in tqdm(data_filtered.groupby("unit_id"), desc="Tuning analysis per unit"):
    # subtract baseline
    unit_df = unit_df.copy()
    unit_df["fr_epoch"] = unit_df["fr_epoch"] - unit_df["fr_baseline"]
    # 1) extract just the "best category" trials
    best_cat = unit_df["best_cat"].iloc[0]
    fr_cat = unit_df.loc[unit_df["first_cat_simple"] == best_cat, "fr_epoch"]
    
    # run the one‐sample t‐test vs. zero
    t1, p_resp = ttest_1samp(fr_cat, 0)
    sig_cat = (p_resp < 0.05) and (fr_cat.mean() != 0)

    resp.append({
        "unit_id": unit_id,
        "pvalue": p_resp,
  })

# %%
resp_df = pd.DataFrame(resp)
resp_df = resp_df.reset_index()

# format dataframe
resp_df["predictor"] = "responsiveness"
area_map = data_filtered.drop_duplicates("unit_id").set_index("unit_id")["brainAreaOfCell"]
resp_df["brainAreaOfCell"] = resp_df["unit_id"].map(area_map)

# 5) Reorder columns to match tuning_df
cols = ["predictor", "pvalue", "unit_id", "brainAreaOfCell"]
# (add any other columns tuning_df has, like test‐statistic, etc.)
resp_df = resp_df[cols]

# Convert from wide to long format for plotting
df_stats = resp_df.melt(id_vars=["unit_id", "brainAreaOfCell", "predictor"], value_vars=["pvalue"])
df_stats["is_significant"] = df_stats["value"] < 0.05

df_stats

# %%
# Plot significant counts
fg = sns.catplot(
    data=df_stats[df_stats["predictor"] != "Intercept"],
    x="brainAreaOfCell",
    # order=["AMY", "HPC", "dACC", "preSMA", "vmPFC", "VTC"],
    hue="is_significant",
    col="predictor",
    kind="count",
    palette=["tab:red", "tab:green"],
)
plt.show()

# %%
"""
### Return responsive neuron idx
"""

resp_units = df_stats.loc[
    df_stats["is_significant"],
    "unit_id"
].unique().tolist()

print("Significant units:", resp_units)

# %%
"""
### Plot responsive neurons - all trials
"""

# pip install git+https://github.com/ioqfwfq/rlab_neural_analysis.git@jz
from neural_analysis.visualize import plot_spikes_with_PSTH
from neural_analysis.spikes import get_spikes

# %%
# Define the unit IDs of interest
unit_ids = resp_units

for unit_id in unit_ids:
  # Select the data for this specific unit.
  df_unit = data_filtered[data_filtered["unit_id"] == unit_id].reset_index(drop=True)
  unit_best_cat = df_unit["best_cat"].iloc[0]
    
  # Get the real brain area from the unit's data.
  area = df_unit["brainAreaOfCell"].iloc[0]
  
  cond = "second_num_simple"    # or whichever condition you plan to use in your plotting
  cmap = "Set2"
  
  # Filter data_filtered rows for the given unit
  df_unit = data_filtered[data_filtered["unit_id"] == unit_id].reset_index(drop=True)
  # Now extract the corresponding labels and stats from this subset
  group_labels = df_unit[cond].apply(lambda x: np.squeeze(x).item() if isinstance(x, (list, np.ndarray)) else x)
  # print(group_labels)
  stats = df_unit["first_cat_simple"]

  # Also get the alignments for this unit
  alignments = np.asarray(epoch_ts[unit_id][:, 0], dtype=np.float64) / 1e6  # if using nanosecond times

  # Get full spike train for the unit
  spikes = np.asarray(df_unit["timestamps"].iloc[0]).flatten().astype(np.float64) / 1e6
  spikes = np.sort(spikes)

  # Plot
  axes = plot_spikes_with_PSTH(
      spikes,
      alignments,
      window = (-1, 8),
      group_labels=group_labels,
      stats=stats,
      plot_stats=False,
      sig_test=True,
      cmap=cmap,
  )

  # add baseline
  unit_baseline = np.mean(df_unit["fr_baseline"]) 
  xmin, xmax = axes[1].get_xlim()
  axes[1].hlines(
      y=unit_baseline,
      xmin=xmin,
      xmax=xmax,
      colors="gray",
      linestyles="--",
      label=f"baseline = {unit_baseline:.1f}"
  )

  # add events
  vlines = [1, 2, 3, 5.5]
  for vline in vlines:
      axes[0].axvline(
        x=vline,
        color="black",
        linestyle="--",
        linewidth=0.5,
        alpha=1
      )
      axes[1].axvline(
          x=vline,
          color="black",
          linestyle="--",
          linewidth=0.5,
          alpha=1
      )

  # relabel and legend
  axes[1].set_xlabel("Time from stim onset [s]")
  axes[0].set_title(
      f"{area} Unit {unit_id} [{cond} responsive] — best_cat = {unit_best_cat}"
  )
  # plt.show()
  plt.savefig(f"plot_out/{area}_{unit_id}_3.png", dpi=300, bbox_inches="tight")
  plt.close()

# %%
"""
### Plot responsive neurons - best category trials
"""

# Define the unit IDs of interest
unit_ids = resp_units

for unit_id in unit_ids:
  # Select the data for this specific unit.
  df_unit = data_filtered[data_filtered["unit_id"] == unit_id].reset_index(drop=True)
  unit_best_cat = df_unit["best_cat"].iloc[0]
  # select trials for this unit
  unit_epoch_ts = np.asarray(epoch_ts_align[unit_id][:, 0], dtype=np.float64) / 1e6  # if using nanosecond times
  alignments = unit_epoch_ts[df_unit["first_cat_simple"] != unit_best_cat]
  
  df_unit = df_unit[df_unit["first_cat_simple"] != unit_best_cat].reset_index(drop=True)
  # Get the real brain area from the unit's data.
  area = df_unit["brainAreaOfCell"].iloc[0]
  
  cond = "second_cat_simple"
  cmap = "Set1"
  
  # Now extract the corresponding labels and stats from this subset
  group_labels = df_unit[cond].apply(lambda x: np.squeeze(x).item() if isinstance(x, (list, np.ndarray)) else x)
  # print(group_labels)
  stats = df_unit["rt"]

  # Get full spike train for the unit
  spikes = np.asarray(df_unit["timestamps"].iloc[0]).flatten().astype(np.float64) / 1e6
  spikes = np.sort(spikes)

  # Plot
  axes = plot_spikes_with_PSTH(
      spikes,
      alignments,
      window = (-3, 6),
      group_labels=group_labels,
      stats=stats,
      plot_stats=False,
      sig_test=True,
      cmap=cmap,
  )

  # Remove legend from bottom plot
  axes[1].get_legend().remove()

  # add baseline
  unit_baseline = np.mean(df_unit["fr_baseline"]) 
  xmin, xmax = axes[1].get_xlim()
  axes[1].hlines(
      y=unit_baseline,
      xmin=xmin,
      xmax=xmax,
      colors="gray",
      linestyles="--",
      label=f"baseline = {unit_baseline:.1f}"
  )

  # add events
  vlines = [-2, -1, 1, 3.5]
  for vline in vlines:
      axes[0].axvline(
        x=vline,
        color="black",
        linestyle="--",
        linewidth=0.5,
        alpha=1
      )
      axes[1].axvline(
          x=vline,
          color="black",
          linestyle="--",
          linewidth=0.5,
          alpha=1
      )

  # relabel and legend
  axes[1].set_xlabel("Time from stim onset [s]")
  axes[0].set_title(
      f"{area} Unit {unit_id} [{cond} grouped] — best_cat = {unit_best_cat}"
  )
  # plt.show()
  plt.savefig(f"plot_out/{area}_{unit_id}_6.png", dpi=300, bbox_inches="tight")
  plt.close()

# %%
"""
### Plot responsive neurons - best number trials
"""

# Define the unit IDs of interest
unit_ids = resp_units

for unit_id in unit_ids:
  # Select the data for this specific unit.
  df_unit = data_filtered[data_filtered["unit_id"] == unit_id].reset_index(drop=True)
  unit_best_num = df_unit["best_num"].iloc[0]
  # select trials for this unit
  unit_epoch_ts = np.asarray(epoch_ts[unit_id][:, 0], dtype=np.float64) / 1e6  # if using nanosecond times
  alignments = unit_epoch_ts[df_unit["first_num_simple"] == unit_best_num]
  
  df_unit = df_unit[df_unit["first_num_simple"] == unit_best_num].reset_index(drop=True)
  # Get the real brain area from the unit's data.
  area = df_unit["brainAreaOfCell"].iloc[0]
  
  cond = "second_num_simple"    # or whichever condition you plan to use in your plotting
  cmap = "Set2"
  
  # Now extract the corresponding labels and stats from this subset
  group_labels = df_unit[cond].apply(lambda x: np.squeeze(x).item() if isinstance(x, (list, np.ndarray)) else x)
  # print(group_labels)
  stats = df_unit["first_num_simple"]

  # Get full spike train for the unit
  spikes = np.asarray(df_unit["timestamps"].iloc[0]).flatten().astype(np.float64) / 1e6
  spikes = np.sort(spikes)

  # Plot
  axes = plot_spikes_with_PSTH(
      spikes,
      alignments,
      window = (-1, 8),
      group_labels=group_labels,
      stats=stats,
      plot_stats=False,
      sig_test=True,
      cmap=cmap,
  )

  # Remove legend from bottom plot
  axes[1].get_legend().remove()

  # add baseline
  unit_baseline = np.mean(df_unit["fr_baseline"]) 
  xmin, xmax = axes[1].get_xlim()
  axes[1].hlines(
      y=unit_baseline,
      xmin=xmin,
      xmax=xmax,
      colors="gray",
      linestyles="--",
      label=f"baseline = {unit_baseline:.1f}"
  )

  # add events
  vlines = [1, 2, 3, 5.5]
  for vline in vlines:
      axes[0].axvline(
        x=vline,
        color="black",
        linestyle="--",
        linewidth=0.5,
        alpha=1
      )
      axes[1].axvline(
          x=vline,
          color="black",
          linestyle="--",
          linewidth=0.5,
          alpha=1
      )

  # relabel and legend
  axes[1].set_xlabel("Time from stim onset [s]")
  axes[0].set_title(
      f"{area} Unit {unit_id} [{cond} responsive] — best_num = {unit_best_num}"
  )
  # plt.show()
  plt.savefig(f"plot_out/{area}_{unit_id}_4.png", dpi=300, bbox_inches="tight")
  plt.close()

# %%
"""
### OR find tuned units using GLM
"""

# Choose to use Poisson GLM or OLS/ANOVA (set use_poisson = True or False)
use_poisson = False
records = []
responsive = []

for unit_id, unit_df in tqdm(data_filtered.groupby("unit_id"), desc="Tuning analysis per unit"):
    # subtract baseline
    unit_df = unit_df.copy()
    unit_df["fr_epoch"] = unit_df["fr_epoch"] - unit_df["fr_baseline"]

    # skip only if truly no change at all
    if unit_df["fr_epoch"].std() == 0 and unit_df["fr_epoch"].mean() == 0:
        continue

    # now do your tuning test as before
    if use_poisson:
        model = smf.glm(
            formula="fr_epoch ~ C(first_cat_simple) + C(first_num_simple)",
            data=unit_df,
            family=sm.families.Poisson(),
        )
        results = model.fit().wald_test_terms(scalar=True).table
    else:
        model = smf.ols(
            formula="fr_epoch ~ C(first_cat_simple) + C(first_num_simple)",
            data=unit_df,
        )
        results = sm.stats.anova_lm(model.fit(), typ=2)[:-1]
        results = results.rename(columns={"PR(>F)": "pvalue"})

    results["unit_id"] = unit_id
    if "brainAreaOfCell" in unit_df.columns:
        results["brainAreaOfCell"] = [unit_df["brainAreaOfCell"].iloc[0]] * len(results)
    records.append(results)

# %%
# Combine into DataFrames
tuning_df = pd.concat(records).reset_index(names="predictor")

# %%
"""
# Pupulation
"""

from sklearn.datasets import load_iris
from sklearn.svm import LinearSVC
from sklearn.preprocessing import StandardScaler
from sklearn.pipeline import Pipeline
from sklearn.model_selection import cross_val_score
from sklearn.decomposition import PCA
from sklearn.manifold import MDS

# %%
# select data
# sub_df = data_filtered.query("unit_id in @sig_units").reset_index(drop=True)
sub_df = data_filtered

# randomly select 20 trials of each condition from each unit
# note the the resultant df is sorted
sub_df = sub_df.groupby(["unit_id", "first_num_simple", "first_cat_simple"]).sample(10)

# collect into design matrix + labels
X = np.column_stack(sub_df.groupby("unit_id")["fr_epoch"].agg(list))
y = sub_df["first_num_simple"].iloc[:len(X)].to_numpy(str)

# %%
# fit SVM with cross-validation
# Don't expect good performance since this is single-session
pipe = Pipeline([("scaler", StandardScaler()), ("clf", LinearSVC())])
scores = cross_val_score(pipe, X, y, cv=5)
print(f"CV Accuracy: {np.mean(scores):.2f} ± {np.std(scores):.2f}")

# %%
from sklearn.preprocessing import LabelEncoder

# Encode string labels into numeric
y_encoded = LabelEncoder().fit_transform(y)

# Dimensionality reduction
pca = Pipeline([("scaler", StandardScaler()), ("pca", PCA(n_components=3))])
mds = Pipeline([("scaler", StandardScaler()), ("mds", MDS(n_components=3))])
X_pca = pca.fit_transform(X)
X_mds = mds.fit_transform(X)

# %%
# Visualize low-D representation
# Note: matplotlib's 3D plotting is basic and "fake."
#       Use other packages recommended above as needed.
plt.figure(figsize=(16, 8))
ax1 = plt.subplot(1, 2, 1)
ax2 = plt.subplot(1, 2, 2, projection="3d")
ax1.scatter(X_pca[:, 1], X_pca[:, 2], c=y_encoded)
scatter = ax2.scatter(X_mds[:, 0], X_mds[:, 1], X_mds[:, 2], c=y_encoded)
legend1 = ax2.legend(*scatter.legend_elements()) # infer legend from scatter
ax2.add_artist(legend1)
ax1.set_title("PCA")
ax2.set_title("MDS")
plt.show()
