# Working Memory Feature Binding: RSA Analysis
## Encoding Period (Stimulus 1)

### Cell 1: Import Libraries and Setup

```python
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from scipy.spatial.distance import pdist, squareform
from scipy.stats import spearmanr, zscore
from sklearn.svm import SVC
from sklearn.preprocessing import StandardScaler
from sklearn.pipeline import Pipeline
from sklearn.model_selection import StratifiedKFold, cross_val_score
from sklearn.metrics import confusion_matrix
import warnings
warnings.filterwarnings('ignore')

# Set plotting style
plt.style.use('seaborn-v0_8-darkgrid')
sns.set_palette("husl")
```

### Cell 2: Load and Prepare Data

```python
# Load your data (adjust path as needed)
# Assuming you have a dataframe with columns:
# - unit_id: neuron identifier
# - trial_id: trial identifier  
# - fr_stim1: firing rate during stimulus 1 encoding
# - first_cat_simple: category of first stimulus (e.g., 'car', 'food', 'people', 'animal')
# - first_num_simple: number in first stimulus (1 or 5)

# For now, using placeholder - replace with your actual data loading
# data = pd.read_csv('your_data.csv')

# Create condition labels
data['condition'] = data['first_cat_simple'] + '_' + data['first_num_simple'].astype(str)

# Get unique conditions
conditions = sorted(data['condition'].unique())
print(f"Conditions found: {conditions}")
print(f"Number of units: {data['unit_id'].nunique()}")
print(f"Number of trials: {data['trial_id'].nunique()}")
```

### Cell 3: Extract Neural Population Patterns

```python
def get_population_vectors(data, conditions):
    """
    Extract population firing rate vectors for each condition
    Returns a matrix where rows are conditions and columns are neurons
    """
    population_patterns = []
    
    for condition in conditions:
        # Get trials for this condition
        condition_trials = data[data['condition'] == condition]
        
        # Calculate mean firing rate per neuron
        mean_fr = condition_trials.groupby('unit_id')['fr_stim1'].mean()
        
        # Ensure consistent neuron order
        all_units = sorted(data['unit_id'].unique())
        condition_vector = [mean_fr.get(unit, 0) for unit in all_units]
        
        population_patterns.append(condition_vector)
    
    return np.array(population_patterns)

# Get population patterns
population_matrix = get_population_vectors(data, conditions)
print(f"Population matrix shape: {population_matrix.shape}")
print(f"(conditions × neurons): {len(conditions)} × {data['unit_id'].nunique()}")
```

### Cell 4: Compute Neural RDM

```python
def compute_neural_rdm(population_matrix, metric='correlation'):
    """
    Compute representational dissimilarity matrix from neural patterns
    
    Args:
        population_matrix: conditions × neurons array
        metric: 'correlation' or 'euclidean'
    
    Returns:
        RDM: conditions × conditions dissimilarity matrix
    """
    if metric == 'correlation':
        # Compute correlation distance (1 - correlation)
        rdm = 1 - np.corrcoef(population_matrix)
        np.fill_diagonal(rdm, 0)  # Ensure diagonal is exactly 0
    else:
        # Compute pairwise distances
        rdm = squareform(pdist(population_matrix, metric=metric))
    
    return rdm

# Compute neural RDM
neural_rdm = compute_neural_rdm(population_matrix, metric='correlation')

# Visualize
plt.figure(figsize=(8, 7))
sns.heatmap(neural_rdm, 
            xticklabels=conditions,
            yticklabels=conditions,
            cmap='viridis',
            square=True,
            cbar_kws={'label': 'Neural Dissimilarity'})
plt.title('Neural Representational Dissimilarity Matrix')
plt.tight_layout()
plt.show()
```

### Cell 5: Create Model RDMs

```python
def create_model_rdms(conditions):
    """
    Create theoretical RDMs for different coding schemes
    """
    n_conditions = len(conditions)
    
    # Parse conditions
    parsed = []
    for cond in conditions:
        parts = cond.split('_')
        category = parts[0]
        number = int(parts[1])
        parsed.append((category, number))
    
    # Model 1: Pure Category Coding
    category_rdm = np.zeros((n_conditions, n_conditions))
    for i in range(n_conditions):
        for j in range(n_conditions):
            if parsed[i][0] != parsed[j][0]:
                category_rdm[i, j] = 1
    
    # Model 2: Pure Number Coding  
    number_rdm = np.zeros((n_conditions, n_conditions))
    for i in range(n_conditions):
        for j in range(n_conditions):
            if parsed[i][1] != parsed[j][1]:
                number_rdm[i, j] = 1
    
    # Model 3: Conjunctive Coding
    conjunctive_rdm = np.zeros((n_conditions, n_conditions))
    for i in range(n_conditions):
        for j in range(n_conditions):
            if i != j:  # Different only if completely different
                conjunctive_rdm[i, j] = 1
    
    # Model 4: Additive Coding
    additive_rdm = (category_rdm + number_rdm) / 2
    
    return {
        'Category Only': category_rdm,
        'Number Only': number_rdm,
        'Conjunctive': conjunctive_rdm,
        'Additive': additive_rdm
    }

# Create model RDMs
model_rdms = create_model_rdms(conditions)

# Visualize all models
fig, axes = plt.subplots(2, 2, figsize=(12, 10))
axes = axes.ravel()

for idx, (model_name, model_rdm) in enumerate(model_rdms.items()):
    ax = axes[idx]
    sns.heatmap(model_rdm,
                xticklabels=conditions,
                yticklabels=conditions,
                cmap='viridis',
                square=True,
                cbar_kws={'label': 'Dissimilarity'},
                ax=ax)
    ax.set_title(f'{model_name} Model')

plt.tight_layout()
plt.show()
```

### Cell 6: Compare Neural RDM with Model RDMs

```python
def compare_rdms(neural_rdm, model_rdms):
    """
    Correlate neural RDM with each model RDM
    """
    # Get upper triangular indices (excluding diagonal)
    triu_indices = np.triu_indices_from(neural_rdm, k=1)
    
    # Vectorize neural RDM
    neural_vector = neural_rdm[triu_indices]
    
    results = {}
    for model_name, model_rdm in model_rdms.items():
        # Vectorize model RDM
        model_vector = model_rdm[triu_indices]
        
        # Compute Spearman correlation
        r, p = spearmanr(neural_vector, model_vector)
        
        results[model_name] = {
            'correlation': r,
            'p_value': p
        }
    
    return results

# Run comparison
rsa_results = compare_rdms(neural_rdm, model_rdms)

# Display results
results_df = pd.DataFrame(rsa_results).T
results_df = results_df.sort_values('correlation', ascending=False)

print("RSA Results (correlation with neural RDM):")
print("-" * 50)
for model, row in results_df.iterrows():
    print(f"{model:15} r = {row['correlation']:.3f}, p = {row['p_value']:.4f}")

# Visualize
plt.figure(figsize=(8, 6))
bars = plt.bar(results_df.index, results_df['correlation'], 
                color=['green' if p < 0.05 else 'gray' 
                       for p in results_df['p_value']])
plt.axhline(y=0, color='black', linestyle='-', linewidth=0.5)
plt.ylabel('Correlation with Neural RDM')
plt.title('Model Comparison Results')
plt.xticks(rotation=45)

# Add significance stars
for i, (model, row) in enumerate(results_df.iterrows()):
    if row['p_value'] < 0.001:
        plt.text(i, row['correlation'] + 0.02, '***', ha='center')
    elif row['p_value'] < 0.01:
        plt.text(i, row['correlation'] + 0.02, '**', ha='center')
    elif row['p_value'] < 0.05:
        plt.text(i, row['correlation'] + 0.02, '*', ha='center')

plt.tight_layout()
plt.show()
```

### Cell 7: Cross-Decoding Analysis

```python
def prepare_decoding_data(data):
    """
    Prepare data for decoding analysis
    Returns feature matrix X and labels
    """
    # Create trial × neuron matrix
    trial_neuron_matrix = data.pivot_table(
        values='fr_stim1',
        index='trial_id',
        columns='unit_id',
        aggfunc='mean'
    ).fillna(0)
    
    # Get labels for each trial
    trial_labels = data.groupby('trial_id').first()[
        ['first_cat_simple', 'first_num_simple']
    ]
    
    # Align with matrix
    trial_labels = trial_labels.loc[trial_neuron_matrix.index]
    
    return trial_neuron_matrix.values, trial_labels

# Prepare data
X, labels = prepare_decoding_data(data)

def cross_decode_categories(X, labels):
    """
    Test if category decoder generalizes across numbers
    """
    categories = labels['first_cat_simple'].values
    numbers = labels['first_num_simple'].values
    
    # Train on number=1, test on number=5
    train_mask = numbers == 1
    test_mask = numbers == 5
    
    # Ensure we have enough samples
    if train_mask.sum() < 20 or test_mask.sum() < 20:
        print("Warning: Not enough trials for reliable cross-decoding")
        return None
    
    # Train decoder
    clf = Pipeline([
        ('scaler', StandardScaler()),
        ('svc', SVC(kernel='linear', C=1.0))
    ])
    
    # Fit on number=1 trials
    clf.fit(X[train_mask], categories[train_mask])
    
    # Test on number=5 trials
    cross_accuracy = clf.score(X[test_mask], categories[test_mask])
    
    # For comparison: within-number decoding
    within_scores = cross_val_score(
        clf, X[test_mask], categories[test_mask], 
        cv=5, scoring='accuracy'
    )
    within_accuracy = within_scores.mean()
    
    return {
        'cross_number_accuracy': cross_accuracy,
        'within_number_accuracy': within_accuracy,
        'generalization_index': cross_accuracy / within_accuracy if within_accuracy > 0 else 0
    }

# Run cross-decoding
cross_results = cross_decode_categories(X, labels)

if cross_results:
    print("\nCross-Decoding Results (Category):")
    print("-" * 50)
    print(f"Train on num=1, test on num=5: {cross_results['cross_number_accuracy']:.3f}")
    print(f"Train and test on num=5:       {cross_results['within_number_accuracy']:.3f}")
    print(f"Generalization index:          {cross_results['generalization_index']:.3f}")
    print("\nInterpretation:")
    if cross_results['generalization_index'] > 0.8:
        print("→ Strong evidence for ABSTRACT category coding")
    elif cross_results['generalization_index'] < 0.6:
        print("→ Strong evidence for CONJUNCTIVE coding")
    else:
        print("→ Mixed or partial generalization")
```

### Cell 8: Summary Visualization

```python
def create_summary_figure(neural_rdm, model_rdms, rsa_results, cross_results):
    """
    Create a comprehensive summary figure
    """
    fig = plt.figure(figsize=(16, 10))
    
    # Neural RDM
    ax1 = plt.subplot(2, 3, 1)
    sns.heatmap(neural_rdm, cmap='viridis', square=True,
                xticklabels=conditions, yticklabels=conditions,
                cbar_kws={'label': 'Dissimilarity'})
    ax1.set_title('Neural RDM', fontsize=14, fontweight='bold')
    
    # Best fitting model
    best_model = max(rsa_results, key=lambda x: rsa_results[x]['correlation'])
    ax2 = plt.subplot(2, 3, 2)
    sns.heatmap(model_rdms[best_model], cmap='viridis', square=True,
                xticklabels=conditions, yticklabels=conditions,
                cbar_kws={'label': 'Dissimilarity'})
    ax2.set_title(f'Best Model: {best_model}', fontsize=14, fontweight='bold')
    
    # Model correlations
    ax3 = plt.subplot(2, 3, 3)
    results_df = pd.DataFrame(rsa_results).T.sort_values('correlation', ascending=False)
    bars = ax3.bar(range(len(results_df)), results_df['correlation'],
                    color=['green' if p < 0.05 else 'gray' 
                           for p in results_df['p_value']])
    ax3.set_xticks(range(len(results_df)))
    ax3.set_xticklabels(results_df.index, rotation=45, ha='right')
    ax3.set_ylabel('Correlation with Neural RDM')
    ax3.set_title('Model Fits', fontsize=14, fontweight='bold')
    ax3.axhline(y=0, color='black', linewidth=0.5)
    
    # Cross-decoding results
    if cross_results:
        ax4 = plt.subplot(2, 3, 4)
        accuracies = [cross_results['cross_number_accuracy'], 
                      cross_results['within_number_accuracy']]
        labels_acc = ['Cross-number\n(train 1, test 5)', 'Within-number\n(train/test 5)']
        bars = ax4.bar(labels_acc, accuracies, color=['coral', 'skyblue'])
        ax4.axhline(y=0.5, color='black', linestyle='--', alpha=0.5, label='Chance')
        ax4.set_ylabel('Decoding Accuracy')
        ax4.set_title('Category Decoding', fontsize=14, fontweight='bold')
        ax4.set_ylim(0, 1)
        
        # Add accuracy values on bars
        for bar, acc in zip(bars, accuracies):
            ax4.text(bar.get_x() + bar.get_width()/2, bar.get_height() + 0.01,
                    f'{acc:.2f}', ha='center', va='bottom')
    
    # Interpretation text
    ax5 = plt.subplot(2, 3, 5)
    ax5.axis('off')
    
    # Build interpretation
    interpretation = "INTERPRETATION:\n\n"
    
    # RSA interpretation
    if rsa_results['Category Only']['correlation'] > 0.6:
        interpretation += "• Strong category representation\n"
    if rsa_results['Number Only']['correlation'] > 0.6:
        interpretation += "• Strong number representation\n"
    if rsa_results['Conjunctive']['correlation'] > 0.6:
        interpretation += "• Evidence for bound representations\n"
    elif rsa_results['Additive']['correlation'] > 0.6:
        interpretation += "• Features coded independently\n"
    
    # Cross-decoding interpretation
    if cross_results and cross_results['generalization_index'] > 0.8:
        interpretation += "\n• Categories generalize across numbers\n"
        interpretation += "  → Abstract category coding"
    elif cross_results and cross_results['generalization_index'] < 0.6:
        interpretation += "\n• Categories do NOT generalize\n"
        interpretation += "  → Conjunctive coding"
    
    ax5.text(0.1, 0.9, interpretation, transform=ax5.transAxes,
             fontsize=12, verticalalignment='top',
             bbox=dict(boxstyle='round', facecolor='wheat', alpha=0.5))
    
    plt.tight_layout()
    return fig

# Create summary
if cross_results:
    fig = create_summary_figure(neural_rdm, model_rdms, rsa_results, cross_results)
    plt.show()
```

### Cell 9: Statistical Tests and Noise Ceiling

```python
def bootstrap_rdm_correlation(neural_data, model_rdm, n_bootstrap=1000):
    """
    Bootstrap confidence intervals for RDM correlations
    """
    n_conditions = len(conditions)
    correlations = []
    
    for _ in range(n_bootstrap):
        # Resample trials with replacement
        resampled_indices = np.random.choice(
            len(data), size=len(data), replace=True
        )
        resampled_data = data.iloc[resampled_indices]
        
        # Compute RDM for resampled data
        pop_matrix = get_population_vectors(resampled_data, conditions)
        resampled_rdm = compute_neural_rdm(pop_matrix)
        
        # Correlate with model
        triu_idx = np.triu_indices_from(resampled_rdm, k=1)
        r, _ = spearmanr(resampled_rdm[triu_idx], model_rdm[triu_idx])
        correlations.append(r)
    
    # Compute confidence intervals
    ci_lower = np.percentile(correlations, 2.5)
    ci_upper = np.percentile(correlations, 97.5)
    
    return ci_lower, ci_upper

# Example: Bootstrap best model
best_model = max(rsa_results, key=lambda x: rsa_results[x]['correlation'])
ci_lower, ci_upper = bootstrap_rdm_correlation(data, model_rdms[best_model])

print(f"\nBootstrap CI for {best_model} model:")
print(f"95% CI: [{ci_lower:.3f}, {ci_upper:.3f}]")
```

## Next Steps and Extensions

1. **Temporal Dynamics**: Analyze how representations evolve over time during encoding
2. **Individual Differences**: Check if some participants use abstract vs conjunctive strategies
3. **Load Effects**: Compare low load (current analysis) vs high load conditions
4. **Regional Differences**: If you have electrode locations, compare brain regions
5. **Error Trials**: Analyze how representation quality predicts subsequent memory performance

This analysis framework will reveal whether working memory uses abstract (efficient) or conjunctive (accurate) coding during initial encoding!