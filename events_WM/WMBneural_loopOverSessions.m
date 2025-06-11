% For all sessions, run cell selection
% totStats and cellStatsAll contain results over all processed sessions
%
% INPUTS
% allSessionsToUse        Patients.
% sessions                task sessions.
% basepath                Path to sorted data for all patients.
% analysisMode            Mode (#) that determines the type of analysis
%                         that will be performed.
% paramsinPreset          External parameters that may have been pre-defined in
%                         WMbinding_neural_main.
%
% OUTPUTS
% totStats & cellStatsAll   Collection of results / total stats from all
%                           cells and sessions.
% JZhu 202506
%
function [totStats, cellStatsAll] = WMBneural_loopOverSessions(allSessionsToUse,sessions, basepath, analysisMode, paramsInPreset )
totStats=[];
cellStatsAll=[];
if isempty(allSessionsToUse)
    allSessionsToUse = 1:size(sessions.sessionID,1);
end
for j=1:length(allSessionsToUse)
    sessionIdx = allSessionsToUse(j);

    session = sessions(sessionIdx,:); %current session to be analyzes

    % import external parameters
    paramsIn              = paramsInPreset;
    paramsIn.onlyChannels = copyFieldIfExists( paramsInPreset, 'onlyChannels', 1:256 );
    paramsIn.onlyCells    = copyFieldIfExists( paramsInPreset, 'onlyCells', [] );
    paramsIn.plotAlways   = copyFieldIfExists( paramsInPreset, 'plotAlways', 0 );
    paramsIn.onlyAreas    = copyFieldIfExists( paramsInPreset, 'onlyAreas', [] );
    paramsIn.doPlot       = copyFieldIfExists( paramsInPreset, 'doPlot', 1 );
    paramsIn.analysisMode = analysisMode;
    paramsIn.sessionIdx   = sessionIdx;

    % prepare data for this session
    [paramsForRun, basedirData_forSession, ~, brainArea] = prepareData(basepath, session, paramsIn);

    % run analysis for all cells in this session
    switch(analysisMode) % see @____ in input for the runForAllCellsInSession function for specific analysis function
        case 1 % ALL Cells
            allData = runForAllCellsInSession(basedirData_forSession, brainArea, session.sessionID, @WMB_singleCellAnalysis_mainDB, paramsForRun);
        case 2 % All cells, plot raster ***need work!!!! JZ
            allData = runForAllCellsInSession(basedirData_forSession, brainArea, session.sessionID, @WMB_singleCellAnalysis_plotRasters, paramsForRun);
        otherwise
            error('not defined');
    end

    %% aggregate results across sessions for later analysis
    if isfield(allData,'allStats')
        totStats = [totStats; [ones(size(allData.allStats,1),1)*sessionIdx, allData.allStats]];
    end
    if isfield(allData,'cellStats')
        for ii=1:length(allData.cellStats)
            allData.cellStats(ii).sessionIdx=sessionIdx;
        end
        cellStatsAll = [cellStatsAll allData.cellStats];
    end
end
end

%%%%%%%%%%%%%%%%%%%%%%
function [params, basedirData, basedirEvents, brainArea] = prepareData(basepath, sessionIn, paramsIn)
% Prepare meta data needed for analysis of a session
%
% paramsIn: additional parameters, are passed on as-is to the callback function
%
% urut/aug16 -- simplified from preparePopDataRecog.m
% Ssullivan/may17 -- modified for sternberg analysis
% JZhu 202504 -- modified for WMbinding task
%% load behavioral data of session
% load stimuli and behavioral responses
[AllInfo] = loadBehavData(sessionIn, basepath);
%% determine the trial period timestamps
events = AllInfo.events;
% ms before stim onset
stimBaselineEnc= 500; % for all encodings
stimBaselineMaint = 1000;  %before maintenance onset
stimBaselineProbe = 1000; %before probe onset
stimBaselineButtonPress = 1000; % before button press

% ms after stim onset
stimOnTimeEnc  = 1500;
stimOnTimeMaint = 3500;
stimOnTimeProbe = 1000;
stimOnTimeButtonPress = 1000;


idxStimOn_Enc1 = AllInfo.idxEnc1;
idxStimOn_Enc2 = AllInfo.idxEnc2;
idxDelayOn_Enc1 = AllInfo.idxDel1;
idxDelayOn_Enc2 = AllInfo.idxDel2;
idxProbe = AllInfo.idxProbeOn;
idxResp = AllInfo.idxResp;

% periods = determinePeriods( inds, events, beforeOffset, afterOffset )
periods_Enc1 = determinePeriods(idxStimOn_Enc1, events, stimBaselineEnc, stimOnTimeEnc);
periods_Enc2 = determinePeriods(idxStimOn_Enc2, events, stimBaselineEnc, stimOnTimeEnc);
periods_Del1 = determinePeriods(idxDelayOn_Enc1, events, stimBaselineEnc, stimOnTimeEnc);
periods_Del2 = determinePeriods(idxDelayOn_Enc2, events, stimBaselineEnc, stimOnTimeEnc);
periods_Probe = determinePeriods(idxProbe, events, stimBaselineProbe, stimOnTimeProbe);
periods_Resp = determinePeriods(idxResp, events, stimBaselineButtonPress, stimOnTimeButtonPress);


%% package into params for passing to analysis function
params=[];

params = copyStructFields(AllInfo,params);
params.nrProcessed=0;

% periods for structure array
params.periods_Enc1 = periods_Enc1;
params.periods_Enc2 = periods_Enc2;
params.periods_Del1 = periods_Del1;
params.periods_Del2 = periods_Del2;
params.periods_Probe = periods_Probe;
params.periods_Resp = periods_Resp;

%prestim and poststim time for structure array
params.prestimEnc= stimBaselineEnc; % for all encodings
params.prestimMaint = stimBaselineMaint;  %before maintenance onset
params.prestimProbe= stimBaselineProbe; %before probe onset
params.prestimButtonPress = stimBaselineButtonPress; % before button press

params.poststimEnc= stimOnTimeEnc; % for all encodings
params.poststimMaint = stimOnTimeMaint;  %before maintenance onset
params.poststimProbe= stimOnTimeProbe; %before probe onset
params.poststimButtonPress = stimOnTimeButtonPress; % before button press

%import additional parameters
if exist('paramsIn')
    params = copyStructFields( paramsIn, params );
end


%% load data files
%== paths
pathSpikeData = '/sorted/'; % contains *_cells mat-files
pathEventData = '/events/'; % contains eventsRaw and brainArea files
basedirData   = fullfile(basepath,pathSpikeData,sessionIn.sessionID);
basedirEvents = fullfile(basepath,pathEventData,sessionIn.sessionID);

% load brain area mapping (channel -> brain area)
fNameBrainArea = fullfile(basedirEvents,'brainArea.mat');
if isfile(fNameBrainArea)
    load(fNameBrainArea);
else
    warning( ['brain area file does not exist: ' fNameBrainArea] );
    brainArea=[];
end
end

%%%%%%%%%%%%%%%%%%%
function [allInfo] = loadBehavData(sessionIn, basepath)
% Extracting and Organizing Sternberg (SB) experiment behavioral data
% INPUTS
% sessionIn
% basepath
%
% OUTPUTS
% AllInfo                 Structure with expt info for ALL trials
% Section 0: set Marker IDs load expt behavior markers
% Section 1: Process events file.
% Section 2: Read log file for this session/patient.
% Section 3: Organizing the behavioral data for all and for correct trials.

%% Section 0 set Marker IDs %load expt behavior markers
%TTLs that are sent (and logged) are:
% expstart: 89
% expend: 90
% fixOnset: 10
% pic1: 1
% delay1: 2
% pic2: 3
% delay2: 4
% probeOnset: 5
% response: 6
% break: 91

expstart = 89;
expend = 90;
fixOnset = 10;
pic1 = 1;
delay1 = 2;
pic2 = 3;
delay2 = 4;
probeOnset = 5;
response = 6;
expbreak = 91;

%== define filenames
eventsFile = fullfile(basepath, 'events', sessionIn.sessionID, 'eventsRaw.mat');
behfile = fullfile(basepath,sessionIn.sessionID,'behfile.csv');

%% Section 1: process events file
if isfile(eventsFile)
    eventsFile_toUse = eventsFile;
    logfile_toUse = behfile;
else
    warning(['Events file does not exist,skip loading: ' eventsFile]);
end
if isfile(eventsFile_toUse)
    fprintf('Loading: %s\n', eventsFile_toUse)
    temp = load(eventsFile_toUse); tempFields = fieldnames(temp);
    if length(tempFields)>1
        error('Too many variables in .mat file.')
    else
        events = temp.(tempFields{1}); % Loading for arbitrary events variable name.
        fprintf('Loaded: %s\n', eventsFile_toUse)
    end

    % Cutting events file according to start/stop TTL markers.
    expstart = find(events(:,2)==expstart);
    expend = find(events(:,2)==expend);
    events = events(expstart:expend,:);
    if isempty(expstart) && ~isempty(expend)
        events = events(1:expend,:);
        warning('No start times found in events file')
    elseif isempty(expend) && ~isempty(expstart)
        events = events(expstart:end,:);
        warning('No stop times found in events file')
    elseif isempty(expstart) && isempty(expend)
        events = events;
        warning('No start/sop times found in events file')
    end
    % index of events
    idxEnc1 = find(events(:,2)==pic1); % encoding #1
    idxEnc2 = find(events(:,2)==pic2); % encoding #2
    idxDel1 = find(events(:,2)==delay1); % delay #1
    idxDel2 = find(events(:,2) == delay2); % delay #2
    idxProbeOn = find(events(:,2)== probeOnset); % probe on
    idxResp = find(events(:,2)== response); % response

    %reaction time of the response to probe
    probeOnTime = events(idxProbeOn,1); % probe presentation timestamps
    respTime = events(idxResp,1); % button press timestamps
    RTs = (respTime-probeOnTime)/1000;  %reaction times in ms for each trial

else
    warning(['Events file does not exist,skip loading: ' eventsFile]);
    events=[];
    idxEnc1 = [];
    idxEnc2 = [];
    idxDel1 = [];
    idxDel2 = [];
    idxProbeOn = [];
    idxResp = [];
    RTs = [];
end

%% Section 2: read data from logfile of this experiment & session
fprintf('loading: %s\n', logfile_toUse);
trialTable = readtable(logfile_toUse);
fprintf('loaded: %s\n', logfile_toUse);
nTrials = size(trialTable,1); % num of trials

if length(idxEnc1) ~= nTrials ||  length(idxResp) ~=  nTrials || length(respTime) ~= length(probeOnTime)
    warning('Events file may be damaged');
end

% compiling info for all trials
allInfo = [];
allInfo.events = events;
allInfo.nTrials = nTrials;
allInfo.Trials = trialTable;
allInfo.idxEnc1 = idxEnc1;
allInfo.idxEnc2 = idxEnc2;
allInfo.idxDel1 = idxDel1;
allInfo.idxDel2 = idxDel2;
allInfo.idxProbeOn = idxProbeOn;
allInfo.idxResp = idxResp;
end

%%%%%%%%%
function periods = determinePeriods(idx, events, beforeOffset, afterOffset)
% determines the timestamp for all trials specified with idx from the event file
%
% idx is onset of stimulus
%
% before/after Offset is in ms. it determines the length of the trial,
% relative to the timepoint specified by idx
%
% urut/jan07
% JZhu 202504
for i=1:length(idx)
    periods(i,1:3) = [ i events(idx(i),1)-beforeOffset*1000 events(idx(i),1)+afterOffset*1000];
end
end
