# WM Binding Project

This workspace combines the analysis and psychophysics components of the WM Binding project.

## Project Structure

- `analysis/`: Neural analysis code and data
  - Located at: `D:\neuro1\code\events\WM_binding_pilot`
  - Contains: MATLAB scripts, analysis code, and neural data

- `psychophysics/`: Psychophysics code and data
  - Located at: `D:\neuro1\code\psychophysics\WM_binding_pilot`
  - Contains: Experiment code, behavioral data, and analysis scripts

## Version Control

This project uses a hybrid version control approach:

1. **SVN**: Each component (analysis and psychophysics) is managed by SVN for team collaboration
2. **Git**: This workspace uses Git to track both components together and sync across machines

### SVN Operations

Use the `sync_svn.ps1` script to perform SVN operations:

```powershell
# Check status
.\sync_svn.ps1 -Component all -Action status

# Update from SVN
.\sync_svn.ps1 -Component all -Action update

# Commit changes
.\sync_svn.ps1 -Component analysis -Action commit -Message "Your message"
```

### Git Operations

```powershell
# After making changes
git add .
git commit -m "Your message"
git push

# On other machines
git pull
```

## Git Hooks

The workspace includes Git hooks that prompt for SVN operations:

- `pre-commit`: Prompts to sync with SVN before committing
- `post-commit`: Prompts to sync with SVN after committing
- `post-push`: Prompts to sync with SVN after pushing
- `post-merge`: Prompts to check SVN status after pulling

## Requirements

- MATLAB (for analysis)
- Python (for psychophysics)
- TortoiseSVN
- Git

## Contributing

This is a research project. Please discuss any modifications with the authors.

## Citation

[To be added] 