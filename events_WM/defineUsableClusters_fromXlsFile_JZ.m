%
% takes sorting result from excel file and defines usable clusters automatically
%
%
% requires three columns in the excel file: channelNr, threshold, clustersToUse
% channelNr and threshold have to be type numeric
% clustersToUse has to be type text. it is a list of clusters to use, with merges indicated by '+'
% Examples: 128,130,150     (use 3 clusters)
%           128+130,150     (use 2 clusters, merge 128+130)
%
%
% 
%urut/april14

%% ==== define all parameters to process a new session
clear; clc;

subjectList = {... % label in plots & used for loop
    'P108CS'...
    };


% - Sorting Parameters
fs = filesep;
basepath='\\smb.researchcampus.csmc.edu\rutishauserulab-data\dataRawEpilepsy\'; %\\csclvault\RutishauserULab\dataRawEpilepsy\
sortDir='sort\';
figsDir='figs\';
finalDir='final\';
Area = 'A'; % A for AIP, B for BA5

% - Patient Parameters
patientID = [subjectList{1} fs]; % should be the same as the folder
taskStr='20250420_WM_binding\'; %NO (i.e., 'NO\var1\')

% - Excel Parameters
xlsFile=[basepath fs patientID taskStr 'P108CS_WMbinding_cells.xlsx']; %path to XLS file 
% xlsFile=[basepath 'P106CS_WMbinding_cells.xlsx']; %path to XLS file 
sheet = 'Sheet1';  % which worksheet has this session
range=[11:106]; % which rows in this worksheet contain all channels to be used (11:106 = Cedars) 
columnChannel=3;
columnThresh=5; 
columnClusterNumbers=6;

% NOTE: code below will reference the  following paths
% basepath\patientID\sortDir --> current location of cells and sorted_new mat-files for all clusters
% basepath\patientID\figsDir --> current location of png files for all clusters
% basepath\patientID\sortDir\final --> where mat files for selected clusters ONLY will be stored
% basepath\patientID\figsDir\final --> where png files for selected clusters ONLY will be stored

%**************************************************************************
% =========== Cedars-Sinai Brain Mapping =================================
% 'mapping' Format: [start1 end1 mapNo1; ... ... ... ; startN endN mapNoN]
% 1=RH, 2=LH, 3=RA, 4=LA, 5=RAC, 6=LAC, 7=RSMA, 8=LSMA, 9=RPT, 10=LPT, 
% 11=ROFC, 12=LOFC, 13=RCM, 14=LCM 50 = RFFA , 51 = REC,
% 52 = RCM, 53 = LCM, 54 = RPUL, 55 = LPUL 
% file number not ch number

% mapping = [...
%     1 8 6; ... % LAC
%     9 16 8; ... % LSMA
%     17 24 4; ... % LA
%     25 32 2; ... % LH
%     33 40 5; ... % RAC
%     41 48 7; ... % RSMA
%     49 56 3; ... % RA
%     57 64 1; ... % RH
%     193 200 12; ... % LOF
%     201 208 10; ... % LPT
%     209 216 11; ... % ROF
%     217 224 9 ... % RPT
%     ]; % P107CS


% Prior Mappings
mapping = [...
    129 136 6; ... % LAC
    137 144 8; ... % LSMA
    145 152 4; ... % LA
    153 160 2; ... % LH
    161 168 5; ... % RAC
    169 176 7; ... % RSMA
    177 184 3; ... % RA
    185 192 1; ... % RH
    193 200 12; ... % LOF
    201 208 10; ... % LPT
    225 232 11; ... % ROF
    233 240 9 ... % RPT
    ]; % P106CS

%Epilepsy (Cedars-Sinai) 
pathIn=basepath;
pathOut=basepath;

%utah
%pathIn=['V:\dataRawEpilepsy\'];
%pathOut=['V:\dataRawEpilepsy\'];

%Epilepsy (TWH)
%pathIn=['V:\dataRawConsortium\NO\'];
%pathOut=['V:\dataRawConsortium\NO\'];

%% ===
[num,txt,raw] = xlsread(xlsFile, sheet, '','basic');  % range selection does not work in basic mode (unix)

masterTable=[]; %List of all final clusters: Channel Th Cluster

masterMerges=[]; %list all merges: Channel Th MergeTarget MergeSource

for k=range
    disp(k)
    channelNr = (raw{k,columnChannel});
    thresh = raw{k,columnThresh};
    clusters = raw{k,columnClusterNumbers};

    if isnumeric(clusters)
        clusters=num2str(clusters);
    end
    
    if ~isempty(thresh) && ~isnan(thresh)
        
        %define clusters
        cls = strsplit(clusters, ',');
        clsToUse=[];
        for jj=1:length(cls)
            
            %see if this is a merge operation
            indsPlus = strfind(cls{jj},'+');
            if ~isempty(indsPlus)
                %assume merge was done already, only use first entry (main cl)
                clToUse=str2num( cls{jj}(1:indsPlus-1) );
                
                mergeSources = cls{jj}(indsPlus+1:end);
                
                mergeSources_list = strsplit(mergeSources,'+');
                
                for i=1:length(mergeSources_list)
                    masterMerges = [ masterMerges; [channelNr thresh clToUse str2num(mergeSources_list{i}) ]];
                end
            else
                clToUse = str2num(cls{jj});
            end
            if clToUse>0
                clsToUse = [clsToUse clToUse];
                
                
                masterTable = [masterTable; [ channelNr thresh clToUse ]];
            end
        end
        
        disp([num2str(k) ' Using: Ch=' num2str(channelNr) ' Th=' num2str(thresh) ' ClsOrig:' clusters]);
        disp(['ClsParsed:' num2str(clsToUse)]);
    end
end

%% execute merges
for j=1:size(masterMerges,1)
    overwriteParams = [ masterMerges(j,:) ];
    mergeClusters( [basepath patientID taskStr], sortDir, figsDir, finalDir, overwriteParams );
end
%% Regen Figures ( Deletes the old channel's figures & runs OSort figure generation on the merged channels)
% Note: Only regens the cluster figures, PC, and projection tests. This
% does not regen the raw plot at the moment. 

% Get list of channels to regen
regenChannels = unique(masterMerges(:,1)); chanLen = length(regenChannels);
regenChannelsThresh = cell(chanLen,1);
for i = 1:chanLen; regenChannelsThresh{i} = num2str(masterMerges(find(masterMerges(:,1)==regenChannels(i),1),2)); end % Maps threshold to each unique channel 

% Delete Old Figs & Regen
parfor i = 1:chanLen
    dirFigPath = [basepath patientID taskStr figsDir regenChannelsThresh{i} fs Area num2str(regenChannels(i)) '_CL_*.png'];
    delDir = dir(dirFigPath);
    pathsToDel = strcat(strcat( {delDir.folder}',fs), {delDir.name}'); % Appends the file name to the file path. 
    for j = 1:numel(pathsToDel)
        delete(pathsToDel{j});
    end
    
    
    % Replots cluster graphs & raw graphs. (Accurate raw graphs for ground normalized channels not supported .)
    paths=[];
    paths.patientID = subjectList{1};
    paths.basePath = [basepath paths.patientID fs taskStr];
    paths.pathOut=[paths.basePath 'sort/'];
    paths.pathRaw=[paths.basePath 'raw/'];
    paths.pathFigs=[paths.basePath 'figs/']; %When creating figs after  practice merges, use /figs_merged/ directory instead of just /figs/ so nothing gets overwritten
    paths.timestampspath=paths.basePath;       

    %params
    paramsIn=[];
    paramsIn.doGroundNormalization=0;
    paramsIn.minNrSpikes=50; %min nr spikes assigned to a cluster for it to be valid
    paramsIn.rawFilePrefix='CSC';        % some systems use CSC instead of A
    paramsIn.processedFilePrefix='A';

    paramsIn.rawFileVersion = 6; %1 is analog cheetah, 2 is digital cheetah (NCS), 3 is txt file, 6 is Atlas. See defineFileFormat.m
    paramsIn.samplingFreq = 32000; %only used if rawFileVersion==3
    paramsIn.blockNrRawFig=[ 10 50 80 150 ];
    paramsIn.labelBlockNrs = 0; %label blocks on the x-axis of the 'Spike rate & amplitude' graph
    paramsIn.labelBlockNrsText = 0; %add text (e.g. 'B10') to the block labels
    paramsIn.outputFormat='png';
    paramsIn.thresholdMethod=1; %1=approx, 2=exact
    paramsIn.prewhiten=0; %0=no, 1=yes,whiten raw signal (dont)
    paramsIn.defaultAlignMethod=3;  %only used if peak finding method is "findPeak". 1=max, 2=min, 3=mixed
    paramsIn.peakAlignMethod=1; %1 find Peak, 2 none, 3 peak of power, 4 MTEO peak

    %for power detection method
    paramsIn.detectionMethod=1; %1 power, 2 T pos, 3 T min, 3 T abs, 4 wavelet
    kernelSize=18; 
    paramsIn.detectionParams=kernelSize;

    paramsIn.tillBlocks = 999;  %how many blocks to process (each ~20s). 0=no limit.
    paramsIn.doDetection = 0; paramsIn.doSorting = 0; % Should always be 0 for regen
    paramsIn.doFigures = 1;
    paramsIn.noProjectionTest = 1;
    paramsIn.doRawGraphs = 0; % Throw in if statement for ground normed raw graphs. 
    paramsIn.doshortRawGraphs = 0; %zoomed-in raw graphs
    paramsIn.displayFigures = 0 ;  %1 yes (keep open), 0 no (export and close immediately); for production use, use 0 
    
    [filesAlignMax, filesAlignMin] = translateThreshold(regenChannelsThresh{i}, regenChannels(i));
    [normalizationChannels,paramsIn,filesToProcess] = StandaloneGUI_prepare([],0,paramsIn, regenChannels(i), filesAlignMax, filesAlignMin, [], [] );
    StandaloneGUI_JZ(paths, filesToProcess, str2double(regenChannelsThresh{i}), normalizationChannels, paramsIn);
end
%% execute define usable clusters (Error prone due to manual data entry)

% Add section to automatically resume where the error occured if you
% re-read the excel without clearing variables. 
if ~exist('errChan','var') 
    startChan = 1; % Start from beginning
else
    startChan = errChan; % Start from error
end

channelsToProcess = unique( masterTable(:,1) );
for j = startChan:length(channelsToProcess) % Recommended to not use parfor, for easier troubleshooting
    
    channelNr = channelsToProcess(j);    
    inds = find(masterTable(:,1)==channelNr);
    
    cls = masterTable(inds,3);
    thresh = masterTable(inds,2);  %all thresholds are the same
    thresh = thresh(1);
    
    overwriteParams = [ channelNr thresh unique(cls') ];
    
    if ~defineUsableClusters( [basepath patientID taskStr], sortDir, figsDir, finalDir, overwriteParams );
%    if ~defineUsableClusters_v2( [basepath patientID],Area, sortDir, figsDir, finalDir, overwriteParams );
        errChan = j; %#ok<UNRCH>
        error('error, fix manually and repeat: Ch%d (%d)',channelNr,j);
        
    end
    
end
%% next processing steps
overwriteWarningDisable=1;
rangeToRun=[129:208, 225:240]; %for Cedars (129:208)
% convertClustersToCells(basepath, patientID, ['/' sortDir '/' finalDir '/'], rangeToRun,overwriteWarningDisable);
convertClustersToCells_v2( Area, basepath, [patientID, taskStr], ['/' sortDir '/' finalDir '/'], rangeToRun,overwriteWarningDisable)

%% copy *_cells.mat files 
for k=1:length(rangeToRun)
    fnameFrom=[basepath patientID taskStr sortDir  finalDir num2str(Area) num2str(rangeToRun(k)) '_cells.mat'];
    fnameTo=[pathIn patientID taskStr];
    if exist(fnameFrom) & exist(fnameTo)
        disp(['Copying: ' fnameFrom ' ' fnameTo ])
        copyfile(fnameFrom,fnameTo);
    end
end

%% make brain area file
overwriteWarningDisable=1;
rangeToRun=[129:240];
defineBrainArea(pathIn,pathOut,patientID,taskStr, mapping,overwriteWarningDisable,rangeToRun, Area);

%% Move *_cells.mat files and event files into Share sorted/events folder.

shareFolder_events = 'Y:\Share1\dataRawEpilepsy\events\';
shareFolder_sorted = 'Y:\Share1\dataRawEpilepsy\sorted\';

%Create session file in 'R:\'
% patientID(strfind(patientID, '\')) = [];

%Write the patient folder within '\sorted'
sortedFolder = [shareFolder_sorted, patientID,filesep, taskStr]
if exist(sortedFolder) 
    warning('This folder already exists: %s', sortedFolder) 
else 
    mkdir(sortedFolder)
end 

%Write the patient folder within '\events'
eventsFolder = [shareFolder_events, patientID, filesep, taskStr];
if exist(eventsFolder) 
    warning('This folder already exists: %s', eventsFolder) 
else 
    mkdir(eventsFolder)
end 

sessionFolder_main = [basepath, patientID, filesep, taskStr]; 
if ~exist(sessionFolder_main)
    error('This file does not exist: %s', sessionFolder_main)
else 
    directory_contents = dir(sessionFolder_main); 
end 

%Move files
for i = 1:length(directory_contents) 
    
    directoryFile = [directory_contents(i).folder, filesep, ... 
        directory_contents(i).name]; 
    
    %Move *_cells.mat files -----> sorted folder 
    if contains(directory_contents(i).name, '_cells') && contains(directory_contents(i).name, '.mat')
        %fprintf('%s \n',directory_contents(i).name )
        
        copyfile(directoryFile,sortedFolder);
        disp(['Copied: ' directoryFile ' ' sortedFolder ])
    end 
    
    %Move Events files
    if contains(directory_contents(i).name, 'brainArea.mat') ||  ... 
            contains(directory_contents(i).name, 'newold80.txt') || ... 
            contains(directory_contents(i).name, 'newold81.txt') || ... 
            contains(directory_contents(i).name, 'eventsRaw.mat')
        
        %fprintf('%s \n',directory_contents(i).name )
        
        copyfile(directoryFile,eventsFolder);
        disp(['Copied: ' directoryFile ' ' eventsFolder ])
    end  
    
end 



%% =============================== below this -- manual things, usually not needed

%% manual min/max merge

% channelNr=22;
% sortDirMin='5.502';
% sortDirMax='5.501';
% sortDirMerge='5.509';
% 
% clustersMin=[565 537];
% clustersMax=[269 523 455];
% 
% % list clusters here which are clearly miss-aligned to make spikes available to merge into other clusters. this has to be a subset of what is given in clustersMin/Max
% nonPriorityClusters=[455];  
% 
% priorityFile=2;
% 
% clustersMinMaxMerge([basepath patientID '/' sortDir '/'], channelNr, sortDirMin, sortDirMax, sortDirMerge, clustersMin, clustersMax, priorityFile,nonPriorityClusters);
% 
% %% manual define usable
% %defineUsableClusters( [basepath patientID], sortDir, figsDir, finalDir, [27 5.03 706 683 349 710 419] );
% 
% %defineUsableClusters( [basepath patientID], sortDir, figsDir, finalDir, [47 4.5 1323 1324 1428 1558 1593 1604 1606] );
% %defineUsableClusters( [basepath patientID], sortDir, figsDir, finalDir, [47 4 1960 1998 2009 2024 2035 1932 2020] );
% %defineUsableClusters( [basepath patientID], sortDir, figsDir, finalDir, [47 5.5 1059 1029 997 861 444] );
% %defineUsableClusters( [basepath patientID], sortDir, figsDir, finalDir, [47 5.2 1146 1142 1129 1044 1029 998] );
% %defineUsableClusters( [basepath patientID], sortDir, figsDir, finalDir, [47 5.01 1166 1277 1307 1309 1022 1271 1180] );
% 
% %defineUsableClusters( [basepath patientID], sortDir, figsDir, finalDir, [44 5 625 614 611 515 622] );
% %defineUsableClusters( [basepath patientID], sortDir, figsDir, finalDir, [41 5.005 1851,1823,  1741] );
% 
% defineUsableClusters( [basepath patientID], sortDir, figsDir, finalDir, [33 5.302 775 763 774] );
% 
%   %mergeClusters( [basepath patientID], sortDir, figsDir, finalDir, [22 5.091 446 448] );
% 
% %% next processing steps
% overwriteWarningDisable=1;
% rangeToRun=1:32;
% %rangeToRun=33;
% convertClustersToCells( basepath, patientID, ['/' sortDir '/' finalDir '/'], rangeToRun,overwriteWarningDisable);
% 
% %% copy cell files
% %(manual)
% copyFrom=[basepath patientID '/' sortDir '/' finalDir '/A' num2str(rangeToRun) '_cells.mat'];
% copyTo=[pathIn patientID '/' taskStr];
% disp(['Copy from/to: ' copyFrom ' / ' copyTo]);
% copyfile(copyFrom,copyTo);
% 
% 
% %%
% %need to manually define params in below before running
% 
% overwriteWarningDisable=1;
% 
% 
% defineBrainArea(pathIn,pathOut,patientID,taskStr, mapping,1);

