%
% Standalone_textGUI_prod1.m
%
% production code, sort epilepsy data on server

%% slack reminder
scriptName = mfilename;
if isempty(scriptName)
    scriptName = 'task';
end
hostname = getenv('COMPUTERNAME');
startTimestamp = datetime('now','Format','MM/dd/uuuu HH:mm:ss');

url = 'https://hooks.slack.com/services/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';

% Slack message
startMessage = sprintf('🚀 MATLAB script *%s* started on *%s* at %s', ...
    scriptName, hostname, startTimestamp);

% Send to Slack
payload = struct('text', startMessage);
options = weboptions('MediaType','application/json');
try
    webwrite(url, payload, options);
catch ME
    % warning('Slack start message failed: %s', ME.message);
end
%% start
clear variables
startTime = tic;
setpath_CSMC_win_jz
%% sort
paths=[];

paths.basePath=['\\smb.researchcampus.csmc.edu\rutishauserulab-data\dataRawEpilepsy\P108CS\20250425_WM_binding\']; %add getuserdir in brackets if files are in C: ex. [getuserdir'\Documents\Practice OSort\P39CS_080515'];
paths.pathOut=[paths.basePath '/sort/'];
paths.pathRaw=[paths.basePath '/raw/'];
paths.pathFigs=[paths.basePath '/figs/']; %When creating figs after  practice merges, use /figs_merged/ directory instead of just /figs/ so nothing gets overwritten

paths.timestampspath=paths.basePath;             % if a timestampsInclude.txt file is found in this directory, only the range(s) of timestamps specified will be processed.

paths.patientID='P108CS'; % label in plots

filesToProcess = [129:136];  %which channels to detect/sort
noiseChannels  = [  ];
perm = randperm(numel(filesToProcess)); % randomize the file for parfor
filesToProcess = filesToProcess(perm);
% which channels to ignore

groundChannels=[ ]; %which channels are ground (they are ignored)

doGroundNormalization = 1;
normalizeOnly = [129:136]; %which channels to use for normalization (common average subtraction)

if exist('groundChannels') && ~doGroundNormalization
    filesToProcess=setdiff(filesToProcess, groundChannels);
end

% Determining which sort alignments to use (1:3 is default)
% 1: Mixed (5)
% 2: Max (5.001)
% 3: Min (5.002)
alignRange = 2; % Which alignments to run

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

    extractionThreshold=5;

    %will add 0.01 or 0.02 automatically if all are max/min

    %% global settings
    paramsIn=[];

    paramsIn.rawFilePrefix='CSC';        % some systems use CSC instead of A
    paramsIn.processedFilePrefix='A';

    paramsIn.rawFileVersion = 6; %1 is analog cheetah, 2 is digital cheetah (NCS), 3 is txt file, 6 is Atlas. See defineFileFormat.m
    paramsIn.samplingFreq = 30000; %only used if rawFileVersion==3

    %which tasks to execute
    paramsIn.tillBlocks = 999;  %how many blocks to process (each ~20s). 0=no limit.
    paramsIn.doDetection = 1;
    paramsIn.doSorting = 1;
    paramsIn.doFigures = 1;
    paramsIn.noProjectionTest = 1;
    paramsIn.doRawGraphs = 1;
    paramsIn.doGroundNormalization=doGroundNormalization;

    paramsIn.displayFigures = 0 ;  %1 yes (keep open), 0 no (export and close immediately); for production use, use 0

    paramsIn.minNrSpikes=50; %min nr spikes assigned to a cluster for it to be valid

    %params
    paramsIn.blockNrRawFig=[ 10 50 80 150 ];
    paramsIn.labelBlockNrs = 1; %label blocks on the x-axis of the 'Spike rate & amplitude' graph
    paramsIn.labelBlockNrsText = 0; %add text (e.g. 'B10') to the block labels
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

    thres = [repmat(extractionThreshold, 1, length(filesToProcess))];

    %% execute
    [normalizationChannels,paramsIn,filesToProcess] = StandaloneGUI_prepare(noiseChannels,doGroundNormalization,paramsIn,filesToProcess,filesAlignMax, filesAlignMin, normalizeOnly, groundChannels);
    StandaloneGUI_JZ(paths, filesToProcess, thres, normalizationChannels, paramsIn);

end

%% slack reminder
elapsedTime = toc(startTime);  % in seconds
hostname = getenv('COMPUTERNAME');  % Windows environment variable
scriptName = mfilename;
timestamp = datetime('now','Format','MM/dd/uuuu HH:mm:ss');
message = sprintf('✅ MATLAB script *%s* finished on *%s* at %s (%.2f min elapsed)', ...
    scriptName, hostname, timestamp, elapsedTime/60);

url = 'https://hooks.slack.com/services/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';
payload = struct('text', message);
options = weboptions('MediaType','application/json');
try
    webwrite(url, payload, options);
catch ME
    % warning('Slack message failed: %s', ME.message);
end

