basepath='D:/neuro1/code/';

path(path,basepath);
%processing of raw continous data
path(path,[basepath 'continuous']);
path(path,[basepath 'continuous/neuralynx']);
path(path,[basepath 'continuous/txt']);
path(path,[basepath 'continuous/binLeadpoint']);
path(path,[basepath 'osortGUI']);
path(path,[basepath 'osortTextUI']);

path(path,[basepath 'figures/']);
%learning algorithms
% path(path,[basepath 'learning/']);
% path(path,[basepath 'learning/RLSC']);
% path(path,[basepath 'learning/SVM']);
% path(path,[basepath 'learning/regression']);
%spike sorting
path(path,[basepath 'sortingNew/']);
path(path,[basepath 'sortingNew/noiseRemoval']);
path(path,[basepath 'sortingNew/projectionTest']);
path(path,[basepath 'sortingNew/model']);
path(path,[basepath 'sortingNew/model/detection']);
path(path,[basepath 'sortingNew/evaluation']);
path(path,[basepath 'patients']);
%analysis of experiments
path(path,[basepath 'events']);
path(path,[basepath 'events/WM_binding_pilot']);
% path(path,[basepath 'events/novelty/population']);
% path(path,[basepath 'events/novelty/populationPool']);
% path(path,[basepath 'events/novelty/recall']);
% path(path,[basepath 'events/taskswitch']);
% path(path,[basepath 'events/novelty/ROC']);
% path(path,[basepath 'events/stroop']);
% path(path,[basepath 'events/reward']);
% path(path,[basepath 'events/reward/behavior']);
% path(path,[basepath 'events/newolddelay']);
% path(path,[basepath 'events/newolddelay/lfp']);
% path(path,[basepath 'events/newolddelay/DM']);
% path(path,[basepath 'events/newolddelay/retrieval']);
% path(path,[basepath 'events/newolddelay/retrieval/behavior']);

% path(path,[basepath 'events/newolddelay/utah']);
% path(path,[basepath 'events/newolddelay/utah/utahStimfiles']);
% path(path,[basepath 'events/newolddelay/utah/preprocessing']);

% path(path,[basepath 'events/newolddelay/retrieval/LFP']);
% path(path,[basepath 'events/newolddelay/array']);
% path(path,[basepath 'events/newolddelay/array/toolsJuri/']);

% path(path,[basepath 'events/Decision_task/']);
% path(path,[basepath 'events/Decision_task/paperFigures']);


% path(path,[basepath 'events/newolddelay/utah']);

% path(path,[basepath 'events/newolddelay/retrieval/matthieu']);

% path(path,[basepath 'FaceDetection/']);

% path(path,[basepath 'events/newoldsrc']);
% path(path,[basepath 'events/delayperiods']);
% path(path,[basepath 'events/bubbles']);
% path(path,[basepath 'events/bubbles/CIs']);
% path(path,[basepath 'events/bubbles/simulate']);
% path(path,[basepath 'events/gaze']);
% path(path,[basepath 'events/faceRecog']);
% path(path,[basepath 'events/button']);

%statistical helpers
path(path,[basepath 'statistics']);
path(path,[basepath 'statistics/anova']);
%general util functions
path(path,[basepath 'helpers']);
%the experiments itself
path(path,[basepath 'psychophysics']);
path(path,[basepath 'psychophysics/helpers']);

%plotting helpers
path(path,[basepath 'plotting']);

%lfp
path(path,[basepath 'ieeg']);
path(path,[basepath 'ieeg/coherence']);
path(path,[basepath 'ieeg/coherence/simulations']);
path(path,[basepath 'ieeg/ITC']);
path(path,[basepath 'ieeg/ripples']);
path(path,[basepath 'ieeg/eeglabInterface']);
path(path,[basepath 'ieeg/csd']);
path(path,[basepath 'ieeg/dbs']);

path(path,[basepath 'ieeg/jm_sfc']);

%analysis of mEPSC
%path(path,[basepath 'minis']);
%
path(path,[basepath 'analysisBehavior']);
path(path,[basepath 'video']);
%path(path,[basepath 'turtle']);
%path(path,[basepath 'turtle/invivo']);
%path(path,[basepath 'turtle/plotting']);

path(path,[basepath 'theory/graph']);

path(path,[basepath 'realtime/']);
path(path,[basepath 'realtime/analysis']);
path(path,[basepath 'realtime/core']);
path(path,[basepath 'realtime/GUI']);

%stuff other people wrotef
%addpath(genpath([basepath '3rdParty/chronux_1_15/spikesort']));
addpath(genpath([basepath '3rdParty/chronux/spectral_analysis']));
path(path,[basepath '3rdParty/']);
path(path,[basepath '3rdParty/gabbiani']);
path(path,[basepath '3rdParty/cwtDetection']); %wavelet based spike detection.
path(path,[basepath '3rdParty/circStat']);
% path(path,[basepath '3rdParty/Wave_clus']);
% path(path,[basepath '3rdParty/Wave_clus/Parameters_files']);
% path(path,[basepath '3rdParty/Wave_clus/Batch_files']);
% path(path,[basepath '3rdParty/Wave_clus/Force_files']);
% path(path,[basepath '3rdParty/Wave_clus/SPC']);
path(path,[basepath '3rdParty/m2html/']);
path(path,[basepath '3rdParty/farrow/']);

path(path,[basepath '3rdParty/son/']);
path(path,[basepath '3rdParty/Stat4Ci/']);

path(path,[basepath '3rdParty/eeglab13_6_5b/']);

path(path,[basepath '3rdParty/neuralynxUnixAll/binaries/']);
path(path,[basepath '3rdParty/neuralynxUnixAll/']);

path(path,[basepath '3rdParty/neuralynxNetcom201/']);


path(path,[basepath '3rdParty/neuralynxWindows/']);
% path(path,[basepath '3rdParty/neuralynxNetcom/Matlab_M-files/']);

path(path,[basepath '3rdParty/export_fig/']);
path(path,[basepath '3rdParty/hartiganDip/']);

path(path,[basepath '3rdParty/matlab_bgl/']);

path(path,[basepath '3rdParty/edfmex/']);

path(path,[basepath '3rdParty/ndt.1.0.2/']);

path(path,[basepath '3rdParty/io32/']);

path(path,[basepath '3rdParty/MClust-3.5/ClusterQuality']);



path(path,[basepath 'eyetrack/']);

path(path,[basepath 'learning/NDT']);