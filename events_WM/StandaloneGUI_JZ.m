function StandaloneGUI_JZ(pathsOrig, filesToProcess, thres, normalizationChannels, paramsIn)
% DYNAMIC PARALLEL GUI using parfeval to evenly distribute uneven workloads

N = numel(filesToProcess);
p = gcp();  % obtain or start parallel pool

% Preallocate an array of futures
futures(N,1) = parallel.FevalFuture;

% Launch one task per file
for idx = 1:N
    futures(idx) = parfeval(p, @processOneFile, 0, idx, filesToProcess(idx), ...
        pathsOrig, thres, normalizationChannels, paramsIn);
end

% Monitor and report progress as tasks complete
for i = 1:N
    completedIdx = fetchNext(futures);
    fprintf('✓ Completed file %d (%d of %d)\n', filesToProcess(completedIdx), i, N);
end
end


function processOneFile(currentThresInd, fileID, pathsOrig, thres, normalizationChannels, paramsIn)
% Core per-file processing, extracted from original parfor loop

% Unpack inputs
% set prefix of raw data files and result files
rawFilePrefix = copyFieldIfExists( paramsIn, 'rawFilePrefix', 'A' );
processedFilePrefix = copyFieldIfExists( paramsIn, 'processedFilePrefix', 'A' );
paths = pathsOrig;
pathOutOrig=pathsOrig.pathOut;
i = fileID;
stri = num2str(i);
if ~isfield(paramsIn,'JDformat')
    JDformat=0;
    paramsIn.JDformat=0;
else
    JDformat=paramsIn.JDformat;
end

handles=[];
handles.correctionFactorThreshold=0;  %minimal threshold, >0 makes threshold bigger
handles.paramExtractionThreshold=thres(currentThresInd);

handles = copyStructFields( paramsIn, handles, {'minNrSpikes','blockNrRawFig','doGroundNormalization','rawFileVersion','detectionMethod','detectionParams','peakAlignMethod','displayFigures',...
    'runningAverageLength','blocksize','JDformat','labelBlockNrs', 'labelBlockNrsText'});

%handles.blockNrRawFig = paramsIn.blockNrRawFig;
%handles.doGroundNormalization = paramsIn.doGroundNormalization;
%handles.rawFileVersion=paramsIn.rawFileVersion;
%handles.detectionMethod=paramsIn.detectionMethod;
%handles.detectionParams=paramsIn.detectionParams;
%handles.peakAlignMethod=paramsIn.peakAlignMethod;

%define file format dependent properties
[samplingFreq, limit, rawFilePostfix] = defineFileFormat(paramsIn.rawFileVersion, paramsIn.samplingFreq);

handles.samplingFreq = samplingFreq; %sampling freq of raw data
handles.limit = limit; %dynamic range

handles.pathRaw = paths.pathRaw;

%define include range
handles.includeFilename=[paths.timestampspath 'timestampsInclude.txt'];
includeRange=[];
if exist(handles.includeFilename,'file')==2
    includeRange = dlmread(handles.includeFilename);

    ['include range is set from ' handles.includeFilename]
    handles.includeRange=includeRange; % kaminskij information for ploting spike rate

else
    warning(['include range is not set! file not found: ' handles.includeFilename]);
    handles.includeRange=[]; % kaminskij information for ploting spike rate
end

%find the channels used for normalization of this electrode
if paramsIn.doGroundNormalization
    if size(normalizationChannels,1)==1
        handles.normalizationChannels = normalizationChannels;
    else
        elGroupSize = copyFieldIfExists( paramsIn, 'elGroupSize', 8 );

        electrodeInd = mapChannelToElectrode( i, elGroupSize );

        normalizeThisChannel = 0;
        if ~isempty( electrodeInd )
            % check if at least one normalization channel is given for this electrode
            if ~isempty(find(normalizationChannels(2,:)==electrodeInd))
                normalizeThisChannel=1;
            end
        end

        if normalizeThisChannel
            handles.normalizationChannels = setdiff( normalizationChannels(1, find( normalizationChannels(2,:) == electrodeInd ) ), paramsIn.groundChannels);
        else
            disp(['normalization channel not defined for this channel, dont normalize - ' stri]);
            handles.normalizationChannels = [];
            handles.doGroundNormalization=0;
        end
    end
else
    handles.normalizationChannels = [];
end

% paths.pathOut = [ pathOutOrig '/' num2str(handles.paramExtractionThreshold) '/'];

if iscell(handles.paramExtractionThreshold)
    paths.pathOut = [ pathOutOrig '/' handles.paramExtractionThreshold{1} '/'];
else
    paths.pathOut = [ pathOutOrig '/' num2str(handles.paramExtractionThreshold) '/'];
end

if exist(paths.pathOut,'dir')==0
    ['creating directory ' paths.pathOut]
    mkdir(paths.pathOut);
end

handles.rawFilename=[paths.pathRaw rawFilePrefix stri rawFilePostfix];
if paramsIn.doDetection

    if exist(handles.rawFilename,'file')==0
        ['file does not exist, skip ' handles.rawFilename]
        return;
    end

    handles.rawFilePrefix = rawFilePrefix;
    handles.rawFilePostfix = rawFilePostfix;

    % starttimeDetection=clock;
    handles = StandaloneInit( handles , paramsIn.tillBlocks, paramsIn.prewhiten, paramsIn.alignMethod(currentThresInd),includeRange , paramsIn.JDformat);
    % timeDetection = abs(etime(starttimeDetection,clock))

    %timeDetectionStats(size(timeDetectionStats,1)+1,:) = [ i timeDetection handles.blocksProcessedForInit];

    handles.filenamePrefix = [paths.pathOut processedFilePrefix stri];
    storeSortResultFiles( [], handles, 2 , 2 );%2==no figures, 2=noGUI
end

if paramsIn.doSorting || paramsIn.doFigures || ~paramsIn.noProjectionTest
    handles.basepath=paths.pathOut;
    handles.prefix=processedFilePrefix;
    handles.from=stri;
    [handles,fileExists] = loadSortResultFiles([],handles, 2);
    handles.filenamePrefix=[paths.pathOut handles.prefix stri];
    if fileExists==0
        ['File does not exist: ' handles.filenamePrefix];
        return;
    end
    % Sorting
    if paramsIn.doSorting && ~isempty(handles.newSpikesNegative)
        % starttimeSorting=datetime('now');
        [handles] = sortMain([], handles, 2, paramsIn.thresholdMethod  ); %2=no GUI
        % timeSorting = abs(datetime('now')-starttimeSorting);
        storeSortResultFiles([],handles,2,2);%2==no figures
    end

    % Build label for figures
    try
        handles.label=[ paths.patientID ' ' handles.prefix handles.from ' Th:' num2str(thres(currentThresInd))];
    catch
        handles.label=[ paths.patientID ' ' handles.prefix handles.from ' Th:' thres{currentThresInd}];
    end
    handles.label = strrep(handles.label,'_',' ');
    disp(['producing figure for ' handles.label]);

    %clusters and PCA figures
    if paramsIn.doFigures
        try
            outputPathFigs=[paths.pathFigs num2str(thres(currentThresInd)) '/'];
        catch
            outputPathFigs=[paths.pathFigs '/'];
        end
        produceFigures(handles, outputPathFigs, paramsIn.outputFormat, paramsIn.thresholdMethod);
        produceOverviewFigure(handles, outputPathFigs, paramsIn.outputFormat, paramsIn.thresholdMethod)
    end

    %projection test
    if ~paramsIn.noProjectionTest
        % produceProjectionFigures(handles,[paths.pathFigs num2str(thres(currentThresInd)) '/'], paramsIn.outputFormat, paramsIn.thresholdMethod);
        try
            produceProjectionFigures(handles,[paths.pathFigs num2str(thres(currentThresInd)) '/'], paramsIn.outputFormat, paramsIn.thresholdMethod);
        catch
            produceProjectionFigures(handles,[paths.pathFigs '/'], paramsIn.outputFormat, paramsIn.thresholdMethod);
        end
    end
end

% make raw plots at the end, so that sorting result is included in raw plots as colored spikes (cluster identity)
if paramsIn.doRawGraphs && exist(handles.rawFilename,'file')>0
    handles.prefix = processedFilePrefix;
    handles.rawFilePrefix = rawFilePrefix;
    handles.rawFilePostfix = rawFilePostfix;
    handles.from=stri;
    handles.basepath=paths.pathOut;

    [handles,fileExists] = loadSortResultFiles([],handles, 2);
    produceRawTraceFig(handles, [paths.pathFigs num2str(thres(currentThresInd)) '/'], paramsIn.outputFormat);
end

% plot zoomed-in raw traces to examine waveforms
if isfield(paramsIn, 'doshortRawGraphs') && exist(handles.rawFilename,'file')>0
    if paramsIn.doshortRawGraphs~=0
        handles.prefix = processedFilePrefix;
        handles.rawFilePrefix = rawFilePrefix;
        handles.rawFilePostfix = rawFilePostfix;
        handles.from=stri;
        handles.basepath=paths.pathOut;
        [handles,fileExists] = loadSortResultFiles([],handles, 2);
        produceRawTraceFigSHORT(handles, [paths.pathFigs num2str(thres(currentThresInd)) '/'], paramsIn.outputFormat, paramsIn.doshortRawGraphs);
    end
end

% plot cross correlations between units
if isfield(paramsIn, 'produceXcorrFigures')
    if paramsIn.produceXcorrFigures~=0
        XcorrlengthinMS=40;
        binsize=1;
        produceXcorrFigures(handles,[paths.pathFigs num2str(thres(currentThresInd)) '/'], paramsIn.outputFormat, paramsIn.thresholdMethod,XcorrlengthinMS,binsize);

    end
end
end
