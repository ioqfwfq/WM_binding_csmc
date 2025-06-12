# Working Memory Binding Project

This repository contains the code and analysis for a Working Memory Binding research project, combining neural analysis and psychophysics components. The project investigates working memory binding mechanisms through both behavioral and neural recordings.

## Project Structure

The repository is organized into two main components:

### 1. Analysis (`events_WM/`)
Contains code and data for behavioral and neural analysis, including:
- MATLAB scripts for neural data processing and analysis
- Jupyter notebooks for visualization and advanced analysis
- Neural recording data and results
- Various analysis modules:
  - Abstract coding analysis
  - Category congruence analysis
  - Mixed selectivity analysis
  - Neural delay and distractor analysis
  - Response analysis

### 2. Psychophysics (`psychophysics_WM/`)
Contains experimental code and behavioral data:
- MATLAB scripts for running experiments
- Stimulus generation and presentation code
- Behavioral data collection and analysis
- Online experiment components
- Legacy code and data

## Setup and Requirements

### Prerequisites
- MATLAB (for analysis and experiment code)
- Python (for analysis notebooks)
- TortoiseSVN
- Git

### Environment Setup
1. Clone the repository:
   ```bash
   git clone [repository-url]
   ```

2. Set up MATLAB paths:
   - Run `setpath_CSMC_win_jz.m` in MATLAB to configure paths

3. Python environment:
   - Create a virtual environment in `events_WM/.venv`
   - Install required packages (see requirements.txt)

## Version Control

This project uses a hybrid version control approach:

### Git (Primary)
- Main repository for tracking all components
- Use standard Git commands for version control:
  ```bash
  git add .
  git commit -m "Your message"
  git push
  ```

### SVN (Secondary)
- Used for team collaboration in specific components
- Synchronized with Git using `sync_git_to_svn.ps1`

## Data Organization

### Neural Data
- Raw data files: `*.mat` files in `events_WM/`
- Processed results in various subdirectories
- Analysis outputs in `plot_out/` and other specific directories

### Behavioral Data
- Raw data: CSV files in `psychophysics_WM/data/`
- Stimulus conditions: `stim_conditions.csv`
- Practice conditions: `conditions_practice.csv`

## Running Experiments

1. Configure parameters in `set_parameters.m`
2. Run practice session: `WM_binding_running_practice.m`
3. Run main experiment: `WM_binding_running.m`

## Analysis

### Neural Analysis
- Main analysis scripts in `events_WM/`
- Jupyter notebooks for interactive analysis
- MATLAB scripts for batch processing

### Behavioral Analysis
- Data processing scripts in `psychophysics_WM/`
- Analysis tools for behavioral metrics

## Contributing

This is a research project. Please:
1. Discuss modifications with the authors
2. Follow the version control workflow
3. Document any changes in commit messages
4. Update this README when adding new features

## Citation

[To be added]

## License

[To be added] 