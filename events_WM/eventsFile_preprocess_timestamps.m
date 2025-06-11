
% preprocess events to get a timestamps file for sorting

basepath='\\smb.researchcampus.csmc.edu\rutishauserulab-data\dataRawEpilepsy\P108CS\20250425_WM_binding\';
filenameIn='eventsRaw.mat';

load([basepath filenameIn]);

expIDs=[]; % if empty all that exist are used

[timestamps,expIDsUsed] = createTimestampsFile(expIDs, events);
expIDsUsed


dlmwrite( [basepath 'timestampsInclude.txt'], timestamps, 'delimiter',' ', 'precision',25);


