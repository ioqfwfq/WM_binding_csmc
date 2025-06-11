%
% This cell is a callback function for runForAllCellsInSession.m
%
function params = WMB_singleCellAnalysis_mainDB(timestampsOfCell, figNr, brainAreaOfCell, plabel, params, varargin )

params.nrProcessed = params.nrProcessed+1;

%% Organizing Results 
if ~isfield(params,'allStats')
    params.allStats=[];
end
params.allStats(size(params.allStats,1)+1,:) = [params.channel  params.cellNr brainAreaOfCell params.origClusterID params.nTrials];

% prepare data to return
cellStats=[];
cellStats = copyStructFields(params, cellStats);
if isfield(params,'cellStats')
    fieldsToRemove = {'onlyChannels','plotAlways','onlyAreas','doPlot','pannelNr','onlyCells','allStats','cellStats'};
else
    fieldsToRemove = {'onlyChannels','plotAlways','onlyAreas','doPlot','pannelNr','allStats','onlyCells'};
end
cellStats = rmfield(cellStats, fieldsToRemove);

cellStats.timestamps = timestampsOfCell;

%store spike counts for later analysis
runInd=params.pannelNr;
params.cellStats(runInd) = cellStats;




