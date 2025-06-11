%
% Standalone_textGUI
%
% production code, sort epilepsy data on server

%%
clear all;
setpath_CSMC_win_jz;
%% which files to sort
paths=[];
paths.patientID='P106CS'; % label in plots
paths.basePath=['\\smb.researchcampus.csmc.edu\rutishauserulab-data\dataRawEpilepsy\P106CS\20250207_WMbinding_JZ']; %add getuserdir in brackets if files are in C: ex. [getuserdir'\Documents\Practice OSort\P39CS_080515'];

filesToProcess = [129:240];  %which channels to detect/sort
paths.pathOut=[paths.basePath '/sort/'];
paths.pathRaw=[paths.basePath '/raw/'];
paths.pathFigs=[paths.basePath '/figs/']; %When creating figs after practice merges, use /figs_merged/ directory instead of just /figs/ so nothing gets overwritten

paths.timestampspath=paths.basePath;             % if a timestampsInclude.txt file is found in this directory, only the range(s) of timestamps specified will be processed. 
noiseChannels  = [  ]; 

% which channels to ignore

groundChannels=[ ]; %which channels are ground (they are ignored)

doGroundNormalization = 0;
normalizeOnly = [  ]; %which channels to use for normalization (common average subtraction)

if exist('groundChannels') && ~doGroundNormalization
  filesToProcess=setdiff(filesToProcess, groundChannels);
end

% Determining which sort alignments to use (1:3 is default)
% 1: Mixed (5)
% 2: Max (5.001)
% 3: Min (5.002)
alignRange = 1:3; % Which alignments to run

for j = alignRange 
    
    alignStr = 'Null'; %#ok<NASGU>
    switch j % Determining alignment method
        case 1
            filesAlignMax=[];
            filesAlignMin=[];
            alignStr = 'Mixed';
        case 2
            filesAlignMax=[filesToProcess];
            filesAlignMin=[];
            alignStr = 'Max';
        case 3
            filesAlignMax=[];
            filesAlignMin=[filesToProcess]; %#ok<*NBRAK>
            alignStr = 'Min';
        otherwise 
            error('Error: Sort alignment not specified')
    end
    fprintf('Running %s Alignment for %s\n',alignStr, paths.patientID)
                
    extractionThreshold=5;%%.0002;

    %will add 0.001 or 0.002 automatically if all are max/min
    if doGroundNormalization == 1 % Separate identifiers for ground normalization
        extractionThreshold = extractionThreshold + 0.003;
    end 
    %% global settings
    paramsIn=[];

    paramsIn.rawFilePrefix='CSC';        % some systems use CSC instead of A
    paramsIn.processedFilePrefix='A';

    paramsIn.rawFileVersion = 6; %1 is analog cheetah, 2 is digital cheetah (NCS), 3 is txt file, 6 is Atlas. See defineFileFormat.m
    paramsIn.samplingFreq = 30000; %only used if rawFileVersion==3

    %which tasks to execute
    paramsIn.tillBlocks = 999;  %how many blocks to process (each ~20s). 0=no limit.
    paramsIn.doDetection =1;
    paramsIn.doSorting = 1;
    paramsIn.doFigures = 1;
    paramsIn.noProjectionTest = 1;
    paramsIn.doRawGraphs = 1;
    paramsIn.doshortRawGraphs = 1; %zoomed-in raw graphs
    paramsIn.doGroundNormalization=doGroundNormalization;

    paramsIn.displayFigures = 0 ;  %1 yes (keep open), 0 no (export and close immediately); for production use, use 0 

    paramsIn.minNrSpikes=50; %min nr spikes assigned to a cluster for it to be valid

    %params
    paramsIn.blockNrRawFig=[ 10 15 20 25 ];
    paramsIn.outputFormat='png';
    paramsIn.thresholdMethod=1; %1=approx, 2=exact
    paramsIn.prewhiten=0; %0=no, 1=yes,whiten raw signal (dont)
    paramsIn.defaultAlignMethod=3;  %only used if peak finding method is "findPeak". 1=max, 2=min, 3=mixed
    paramsIn.peakAlignMethod=1; %1 find Peak, 2 none, 3 peak of power, 4 MTEO peak

    %for wavelet detection method
    %paramsIn.detectionMethod=5; %1 power, 2 T pos, 3 T min, 4 T abs, 5 wavelet
    %dp.scalesRange = [0.2 1.0]; %in ms
    %dp.waveletName='bior1.5'; 
    %paramsIn.detectionParams=dp;
    %extractionThreshold=0.1; %for wavelet method

    %for power detection method
    paramsIn.detectionMethod=1; %1 power, 2 T pos, 3 T min, 3 T abs, 4 wavelet
    dp.kernelSize=18; 
    paramsIn.detectionParams=dp;
    %extractionThreshold = 5.5;  % extraction threshold

    %automatically adjust threshold to indicate min/max
    if isequal(filesToProcess,filesAlignMax) & isempty(filesAlignMin)
        extractionThreshold=extractionThreshold+0.001;
    end
    if isequal(filesToProcess,filesAlignMin) & length(filesAlignMax)==0
        extractionThreshold=extractionThreshold+0.002;
    end

    thres         = [repmat(extractionThreshold, 1, length(filesToProcess))];

    %% execute
    [normalizationChannels,paramsIn,filesToProcess] = StandaloneGUI_prepare(noiseChannels,doGroundNormalization,paramsIn,filesToProcess,filesAlignMax, filesAlignMin, normalizeOnly, groundChannels);
    StandaloneGUI(paths, filesToProcess, thres, normalizationChannels, paramsIn);
end