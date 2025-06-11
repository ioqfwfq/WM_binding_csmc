% Exports data from the Sternberg task into NWB format
%
% Michael K.J.I. Kyzar 12-1-22
%
%
% MATLAB API. v2.6.0.1 release of NWB, downloaded from:
% https://github.com/NeurodataWithoutBorders/matnwb/releases/tag/v2.6.0.1
% NOTE: There is a critical error in the v2.6.0.0 release that prevents
% export of ImageSeries objects. This has been fixed in the v2.6.0.1
% release. 
% =====

clear;clc;
%% Path Parameters
% Edit this section before running. This sets paths for all code, data, &
% extensions. 

taskDesc='STERNBERG';
basePathData = 'Z:\LabUsers\kyzarm\data\NWB_SB\data_Native'; % Temporarily using this as the stimuli path. 
% Native Data Path
basePathNative = [basePathData filesep taskDesc];
% Output Data Path
basePathNWBsave = ['Z:\LabUsers\kyzarm\data\NWB_SB\data_NWB\' taskDesc]; % Windows
% basePathNWBsave = ['Z:\LabUsers\kyzarm\data\NWB_SB\data_Dandiset\000469'];

% Code Path
basePathCode = 'D:\neuro1\code\events\Sternberg\NWB-SB';
% MATNWB 
basePathNWBCode = 'D:\neuro1\code\3rdParty\matnwb';
% Session List Path
basePathSessions = [basePathCode filesep 'helpers' filesep 'defineSBsessionsNWB.m'];

%% Initialize NWB Package
%generateCore() for first instantiation of matnwb API

if exist([basePathNWBCode, filesep, '+types', filesep, '+core', filesep, 'NWBFile.m'],'file')
     disp('generateCore() already initialized...') %only need to do once
else 
    cd(basePathNWBCode)
    generateCore();
    disp('generateCore() initialized...')
end 

addpath(basePathNWBCode); 
addpath(basePathCode); 
addpath(genpath([basePathCode filesep 'helpers'])); 

%% Define Sessions
%Convert .m file ----> SB sessions 
if ~exist(basePathSessions,'file')
    error('This file does not exist: %s', basePathSessions)
else
    % NOTE: cellStatsAll will be extracted on a per session basis. 
    SBsessions = defineSBsessionsNWB();
end 

%% NWB EXPORT LOOP
TIME_SCALING = (10.^(-6)); % Converts timestamps to seconds

% exportRange = [SBsessions(:).ID]; % Full Export
exportRange = 1:21; % Full Export
% exportRange = 6:19; % K2017
% exportRange = 1:20; % K2020
% exportRange = 11;

exportFlag = 1;
% plotProjectionTest = 0;

% tryFlag = 0; % Mark as 1 to skip errors.
proj_dist_all = []; % Temporary fix for storing projection distances. They'll be plotted in the export script for later usage. 
exportLog = strings([length(exportRange),1]); % Logs success/error in export
for i=exportRange
%     try
        %% Instantiate NWB File
        nwb = NwbFile();
        
        %% Define General

        % General Attributes
        identifier = SBsessions(i).session;
        subjectDir = SBsessions(i).sessionID;
        variant = SBsessions(i).variant;
        SBID = SBsessions(i).ID;
        experimenter = 'Kyzar, Michael';
        lab = 'Rutishauser';
        institution = 'Cedars-Sinai Medical Center';
        related_publications = 'doi: 10.1038/nn.4509, 10.1016/j.neuron.2020.01.032'; % DOI for Kaminsky 2017 paper
        keywords = 'single neuron, human, intracranial, persistent activity, working memory';
        source_script = 'SB_NWB_export_main.m';
        source_script_file = 'NWB-SB';
        sessionDate = [SBsessions(i).sessionYear '-01-1']; %Provide default date to protect PHI. Note: This date is not the ACTUAL date of the experiment 
        general_notes = 'The session start time has been set to Jan 1st of the recording year to avoid disclosure of protected health information (PHI).';
        
        % Write into NWB    
        nwb.identifier = identifier;
        nwb.session_description = ['SBID: ', num2str(SBID)];
        
        nwb.file_create_date = datetime("today",'Format','yyyy-MM-dd');
        nwb.session_start_time = datetime(sessionDate,'Format','yyyy-MM-dd');
        nwb.general_notes = general_notes;
        nwb.general_experimenter = experimenter;
        nwb.general_lab = lab;
        nwb.general_institution = institution;
        nwb.general_related_publications = related_publications;
        nwb.general_keywords = keywords;
        nwb.general_source_script = source_script;
        nwb.general_source_script_file_name = source_script_file;
        nwb.general_session_id = '2'; % Counts number of sessions per subject. 1 is SC. 2 is SB.
        nwb.general_experiment_description = ... 
            'This data contains electrophysiological recordings and behavior from the Sternberg task performed in patients with intractable epilepsy implanted with depth electrodes and Behnke-Fried microwires in the human medial temporal lobe and medial frontal cortex.';

        % Subject Attributes
        species = 'Homo sapiens';
        subjectID = num2str(SBsessions(i).ID);
        sex = SBsessions(i).sex;
        age = ['P' num2str(SBsessions(i).age) 'Y'];  % this is ISO8601 duration format, P(n)Y(n)M(n)DT(n)H(n)M(n)S
        % Write into NWB

        nwb.general_subject = types.core.Subject(...
            'description', 'Subject metadata',...
            'species', species, ...
            'subject_id', subjectID, ...
            'sex', sex, ...
            'age', age);
        
        %% Import Cell Stats (SB Analysis Pipeline)
        paramsInPreset = [];
        [totStats, cellStatsAll] = SBneural_loopOverSessions(i, SBsessions, basePathNative, SBsessions(i).ExperimentID, paramsInPreset);
        cellStatsAll = SBneural_appendWaveforms(cellStatsAll,basePathNative); % Appending waveform info
        sessFirstCellInd = find([cellStatsAll.SBind]==i,1); % Used to easily access info common to all cells in a session

        %% Import Experiment Log
        logFilePath = [basePathNative filesep SBsessions(i).sessionID filesep 'logfile.mat'];
        logInfoIn = load(logFilePath);
        if isfield(logInfoIn, 'h')
            log = logInfoIn.h;
        else
            error('Incorrect experiment log loaded. Expecting ''h'' field.')
        end

        %% Define Acquisition
        events_description = [...
            'The events coorespond to the TTL markers for each trial. ', ...
            'The TTL markers are the following: ',...
            '61 = Start of Experiment, ', ...
            '11 = Fixation Cross, ', ...
            '1 = Picture #1 Shown, ', ...
            '2 = Picture #2 Shown, ', ...
            '3 = Picture #3 Shown, ', ...
            '5 = Transition between each picture presentation, ',...
            '6 = End of Encoding Sequence / Start of Maintenance Period, ',...
            '7 = Probe Stimulus, ',...
            '8 = Subject Response, ',...
            '60 = End of Experiment '];
%             '4 = Picture #4 Shown, ', ... % No Enc4 period was used        
%             '10 = Break',...      % Commented out because no lengthy break occurs   
%             '9 = Response Feedback (Correct/Incorrect Answer); Not shown to subject',... % Commented out due to being vestigial TTL.        
        
        TTL_START = 61;
        TTL_FIX = 11;
        TTL_ENC1 = 1;
        TTL_ENC2 = 2;
        TTL_ENC3 = 3;
%         TTL_ENC4 = 4;
        TTL_TRANS = 5;
        TTL_MAINT =6;
        TTL_PROBE = 7;
        TTL_RESP = 8;
%         TTL_FEED = 9;
%         TTL_BREAK = 10;
        TTL_END = 60;
        TTL_ALL = [
            TTL_START, ...
            TTL_FIX, ...
            TTL_ENC1, ...
            TTL_ENC2, ...
            TTL_ENC3, ...
            TTL_TRANS, ...
            TTL_MAINT, ...
            TTL_PROBE, ...
            TTL_RESP, ...
            TTL_END, ...
            ];  
%             TTL_ENC4, ... (Not used)        
%             TTL_BREAK, ... (Not used)         
%             TTL_FEED, ... (Not used)         
        
        % Import spike timestamps from cellStatsAll. 
        origSpikesFlattened = cell2mat({cellStatsAll.timestamps}');  % Creates vertical cell array of spike times for all single units (SU).
        
        % Import events from cellStatsAll
        events = cellStatsAll(sessFirstCellInd).events;
        eventsFiltered = events(ismember(events(:,2),TTL_ALL),:); % Removing unrelated TTLS. 
        
        % Find timestampsOffset (Minimum time across all data (events and spike timestamps)
        timestampsOffset = min(nonzeros([origSpikesFlattened; eventsFiltered(:,1)]));
        
        
%         timestampsOffset = min(events(:,1)); % Offsetting timestamps to session start
        % Set Events & Assign to NWB File
        events_ts = types.core.TimeSeries('data', int8(eventsFiltered(:, 2)), 'data_unit', 'NA', ...
            'timestamps', (eventsFiltered(:, 1)-timestampsOffset).*TIME_SCALING, 'description', events_description);
        nwb.acquisition.set('events', events_ts);


    %% Define Intervals
    % Extract Timestamps (TS for each trial. Events that do not occur in a trial are marked as '0')
   
    nTrials = cellStatsAll(sessFirstCellInd).nTrials;
    loads = cellStatsAll(sessFirstCellInd).Loads;
    
    % Load Picture IDs (Arbitrary IDs for each stimulus set)
    loadPicIDs = vertcat(cellStatsAll(sessFirstCellInd).SBPicOrder);
    loadsEnc1_PicIDs = loadPicIDs(:,1);
    loadsEnc2_PicIDs = loadPicIDs(:,2);
    loadsEnc3_PicIDs = loadPicIDs(:,3);
    loadsProbe_PicIDs = cellStatsAll.ProbePic;
    

    % Using the index in eventsFiltered preceeding Enc1, due to it always
    % containing the fixation cross TTL
    filtIndFix = find(eventsFiltered(:,2)==TTL_ENC1) - 1;
    for j = 1:length(filtIndFix) % Verify that the subsequent TTL is the fixation TTL
        if ~ismember(eventsFiltered(filtIndFix(j),2),TTL_FIX)
            disp(j)
            error('Fixation TTL not found for trial.')
        end
    end
    tsFixation = (eventsFiltered(filtIndFix,1)-timestampsOffset).*TIME_SCALING;
    
    % Enc1
    tsEnc1Ind = (eventsFiltered(:,2)==TTL_ENC1); 
    tsEnc1Ind_find = find(tsEnc1Ind); % Index needed for presentation end time. 
    tsEnc1 = (eventsFiltered(tsEnc1Ind,1)-timestampsOffset).*TIME_SCALING;
    
    % Enc1_end
    tsEnc1_end = zeros(size(tsEnc1));
    for j = 1:length(tsEnc1) % Adds the timestamp for the TTL after the presentation TTL. 
        if ismember(eventsFiltered(tsEnc1Ind_find(j)+1,2),[TTL_TRANS,TTL_MAINT])
            tsEnc1_end(j) = (eventsFiltered(tsEnc1Ind_find(j)+1,1)-timestampsOffset).*TIME_SCALING;
        else
            error('Encoding TTL has no end TTL.')
        end
    end
    
    % Enc2
    tsEnc2Ind = (eventsFiltered(:,2)==TTL_ENC2); 
    tsEnc2Ind_find = find(tsEnc2Ind); % Index needed for presentation end time. 
    orig_tsEnc2 = (eventsFiltered(tsEnc2Ind_find,1)-timestampsOffset).*TIME_SCALING; % Timestamps for all P2 presentation
    trialIndEnc2 = find(ismember(loads,[2,3])); % Find trial loads that show P2
    tsEnc2 = zeros(nTrials,1); % Initialize zero array to place tsEnc2_orig entries. 
    for j=1:length(trialIndEnc2) % NOTE: length(trialIndEnc2) should equal length(tsEnc2_orig)
        tsEnc2(trialIndEnc2(j))=orig_tsEnc2(j); % Place tsEnc2_orig entries into trials-size array. 
    end
    
    % Enc2_end
    orig_tsEnc2_end = zeros(size(orig_tsEnc2));
    for j = 1:length(orig_tsEnc2_end) % Adds the timestamp for the TTL after the presentation TTL. 
        if ismember(eventsFiltered(tsEnc2Ind_find(j)+1,2),[TTL_TRANS,TTL_MAINT])
            orig_tsEnc2_end(j) = (eventsFiltered(tsEnc2Ind_find(j)+1,1)-timestampsOffset).*TIME_SCALING;
        else
            error('Encoding TTL has no end TTL.')
        end
    end
    tsEnc2_end = zeros(nTrials,1); % Initialize zero array to place tsEnc2_orig entries. 
    for j=1:length(trialIndEnc2) % NOTE: length(trialIndEnc2) should equal length(tsEnc2_orig)
        tsEnc2_end(trialIndEnc2(j))=orig_tsEnc2_end(j); % Place tsEnc2_orig entries into trials-size array. 
    end

    % Enc3
    tsEnc3Ind = (eventsFiltered(:,2)==TTL_ENC3); 
    tsEnc3Ind_find = find(tsEnc3Ind); % Index needed for presentation end time. 
    orig_tsEnc3 = (eventsFiltered(tsEnc3Ind_find,1)-timestampsOffset).*TIME_SCALING;
    trialIndEnc3 = find(ismember(loads, 3 ));
    tsEnc3 = zeros(nTrials,1);
    for j=1:length(trialIndEnc3)
        tsEnc3(trialIndEnc3(j))=orig_tsEnc3(j);
    end
    
    % Enc3_end
    orig_tsEnc3_end = zeros(size(orig_tsEnc3));
    for j = 1:length(orig_tsEnc3_end) % Adds the timestamp for the TTL after the presentation TTL. 
        if ismember(eventsFiltered(tsEnc3Ind_find(j)+1,2),[TTL_TRANS,TTL_MAINT])
            orig_tsEnc3_end(j) = (eventsFiltered(tsEnc3Ind_find(j)+1,1)-timestampsOffset).*TIME_SCALING;
        else
            disp(j)
            error('Encoding TTL has no end TTL.')
        end
    end
    tsEnc3_end = zeros(nTrials,1); % Initialize zero array to place tsEnc2_orig entries. 
    for j=1:length(trialIndEnc3) % NOTE: length(trialIndEnc2) should equal length(tsEnc2_orig)
        tsEnc3_end(trialIndEnc3(j))=orig_tsEnc3_end(j); % Place tsEnc2_orig entries into trials-size array. 
    end
    
    % Enc All
    tsEncAll = horzcat(tsEnc1,tsEnc2,tsEnc3);
    
    % Maint
    tsMaint = (eventsFiltered(eventsFiltered(:,2)==TTL_MAINT,1)-timestampsOffset).*TIME_SCALING;
    
    % Probe
    tsProbe = (eventsFiltered(eventsFiltered(:,2)==TTL_PROBE,1)-timestampsOffset).*TIME_SCALING;

    % Response
    tsResponse = (eventsFiltered(eventsFiltered(:,2)==TTL_RESP,1)-timestampsOffset).*TIME_SCALING;
%     
%     % Feedback
%     tsFeedback = (events(events(:,2)==TTL_FEED,1)-timestampsOffset).*TIME_SCALING;

    % Accuracy
    response_accuracy = cellStatsAll(sessFirstCellInd).Accuracy;
    
    % Probe In/Out
    probeInOut = NaN(size(cellStatsAll(sessFirstCellInd).ProbeInOut));
    if length(cellStatsAll(sessFirstCellInd).ProbeInOut) ~= nTrials
        error('Amount of trials must match number of ProbeInOut entries.')
    end
    for j = 1:nTrials
        trialPicIDs = [loadsEnc1_PicIDs(j), loadsEnc2_PicIDs(j), loadsEnc3_PicIDs(j)];
        probeInOut(j) = ismember(loadsProbe_PicIDs(j),trialPicIDs);
    end
    
    % Presentation All
    tsPresentAll = horzcat(tsEncAll, tsProbe);
    
    % Trial Start/Stop
    tsStart = tsFixation; % Trial starts when fixation cross appears.
    tsStop = tsResponse; % Trial ends when subject presses response button. 
    if ~(length(tsStart)==length(tsStop) && length(tsStart)==nTrials) % Validating start/stop times
        error('Inconsistent Start/Stop times.')
    end

        % Creating Trials Structure 
        trials = types.core.TimeIntervals(...
            'colnames',{...
            'loads',...
            'loadsEnc1_PicIDs',...
            'loadsEnc2_PicIDs',...
            'loadsEnc3_PicIDs',...
            'loadsProbe_PicIDs',...
            'start_time',...
            'stop_time',...
            'timestamps_FixationCross',...
            'timestamps_Encoding1',...
            'timestamps_Encoding1_end',...
            'timestamps_Encoding2',...
            'timestamps_Encoding2_end',...
            'timestamps_Encoding3',...
            'timestamps_Encoding3_end',...
            'timestamps_Maintenance',...
            'timestamps_Probe',...
            'timestamps_Response',... 
            'response_accuracy'...
            'probe_in_out',...
            }, ...
            'description', 'Intervals for the Sternberg Task');
%             'timestamps_Feedback',... % Might need commenting out. Does not contribute to the analysis.         

% Populating Trials Structure
        trials.id = types.hdmf_common.ElementIdentifiers('data', int32(0:nTrials-1));
        trials.start_time =  types.hdmf_common.VectorData(...
            'data', tsStart,'description', 'Trial start times'...
            );
        trials.stop_time =  types.hdmf_common.VectorData(...
            'data', tsStop,'description', 'Trial stop times'...
            );
        trials.vectordata.set('loads',...
            types.hdmf_common.VectorData('data',...
            uint8(loads),'description', 'Encoding loads for each trial'...
            ));
        trials.vectordata.set('loadsEnc1_PicIDs',...
            types.hdmf_common.VectorData('data',...
            uint8(loadsEnc1_PicIDs),'description', 'Picture ID for Enc1 loads.'...
            ));
        trials.vectordata.set('loadsEnc2_PicIDs',...
            types.hdmf_common.VectorData('data',...
            uint8(loadsEnc2_PicIDs),'description', 'Picture ID for Enc2 loads.'...
            ));
        trials.vectordata.set('loadsEnc3_PicIDs',...
            types.hdmf_common.VectorData('data',...
            uint8(loadsEnc3_PicIDs),'description', 'Picture ID for Enc1 loads.'...
            ));
        trials.vectordata.set('loadsProbe_PicIDs',...
            types.hdmf_common.VectorData('data',...
            uint8(loadsProbe_PicIDs),'description', 'Picture ID for Probe loads.'...
            ));
        trials.vectordata.set('timestamps_FixationCross',...
            types.hdmf_common.VectorData('data',...
            tsFixation,'description', 'Start times of fixation cross'...
            ));
        trials.vectordata.set('timestamps_Encoding1',...
            types.hdmf_common.VectorData('data',...
            tsEnc1, 'description', 'Start times of picture #1 presentation'...
            ));
        trials.vectordata.set('timestamps_Encoding1_end',...
            types.hdmf_common.VectorData('data',...
            tsEnc1_end, 'description', 'End times of picture #1 presentation'...
            ));
        trials.vectordata.set('timestamps_Encoding2',...
            types.hdmf_common.VectorData('data',...
            tsEnc2, 'description', 'Start times of picture #2 presentation'...
            ));
        trials.vectordata.set('timestamps_Encoding2_end',...
            types.hdmf_common.VectorData('data',...
            tsEnc2_end, 'description', 'End times of picture #2 presentation'...
            ));
        trials.vectordata.set('timestamps_Encoding3',...
            types.hdmf_common.VectorData('data',...
            tsEnc3, 'description', 'Start times of picture #3 presentation'...
            ));
        trials.vectordata.set('timestamps_Encoding3_end',...
            types.hdmf_common.VectorData('data',...
            tsEnc3_end, 'description', 'End times of picture #3 presentation'...
            ));
        trials.vectordata.set('timestamps_Maintenance',...
            types.hdmf_common.VectorData('data',...
            tsMaint, 'description', 'Start times of maintenance periods'...
            ));
        trials.vectordata.set('timestamps_Probe',...
            types.hdmf_common.VectorData('data',...
            tsProbe, 'description', 'Start times of probe onset'...
            ));
        trials.vectordata.set('timestamps_Response',...
            types.hdmf_common.VectorData('data',...
            tsResponse, 'description', 'Time stamps of button press'...
            ));
%         trials.vectordata.set('timestamps_Feedback',...
%             types.hdmf_common.VectorData('data',...
%             tsFeedback, 'description', 'Start times of feedback onset'...
%             ));
        trials.vectordata.set('response_accuracy',...
            types.hdmf_common.VectorData('data',...
            uint8(response_accuracy),'description', 'Whether the subject response was correct (1) or incorrect (0).'...
            ));
        trials.vectordata.set('probe_in_out',...
            types.hdmf_common.VectorData('data',...
            uint8(probeInOut),'description', 'Whether the probe image was held (1) or not held (0) in memory.'...
            ));

        % Assign to NWB File
        nwb.intervals.set('trials',trials);

        %% Define Stimulus
        picsPath = [basePathData filesep 'SCREENING_STIMULI' filesep subjectDir filesep 'images'];
        picIDs = [log.picsusing 999]; % ID of original picture (e.g. '42.jpg'). Adding a blank placeholder image (not displaced. Makes indexing slightly easier)
        % Verify number of stimuli
        if length(picIDs) ~= 6
            error('Incorrect number of pictures. (Sternberg task uses 5, with the 6th for a null image)')
        end

        picDims = [400 300]; % X x Y 
        images = cell(length(picIDs),1);
        image_names = cell(length(picIDs),1);
        image_OVs = cell(length(picIDs),1);
        for n = 1:length(picIDs)
            stimName = picIDs(n);
            stimPath = append(picsPath,filesep,string(stimName),'.jpg');
            img = imread(stimPath);
            resize_img = imresize(img,[picDims(2) picDims(1)]); % Original dims for images export
            % Convert greyscale to RGB to make uniform
            if ndims(resize_img) == 2 %#ok<ISMAT>
               resize_img = cat(3, resize_img, resize_img, resize_img);
            end
            image_final = permute(resize_img,[3 1 2]);
            % Create RGBImage object and add to set. 
            image_names{n} = sprintf('image_%d',picIDs(n));
            images{n} = types.core.RGBImage(...
                'data', image_final, ...
                'description',image_names{n}...
                );
            image_OVs{n} = types.untyped.ObjectView(...
                sprintf('stimulus/templates/StimulusTemplates/%s',image_names{n}));
        end
        % Compiling Images   
        im_refs = types.core.ImageReferences('data',[image_OVs{:}]);
        image_collection = types.core.Images(...
            'description','A collection of images presented to the subject', ...
            'order_of_images', im_refs);      
        image_collection.image.set(image_names,images);
        nwb.stimulus_templates.set('StimulusTemplates',image_collection);


        % Compiling Indices & Timestamps
        % All Presentation Testing
        SBPicOrder = cellStatsAll(sessFirstCellInd).SBPicOrder; % Index of picIDs array
        ProbePic = cellStatsAll(sessFirstCellInd).ProbePic;
        picturesAll = horzcat(SBPicOrder, ProbePic);
        totalPics = sum(picturesAll>0,'all');
        ind_stimuli = reshape(picturesAll',[],1); % ind_stimuli = nonzeros(ind_stimuli); % Row-wise flatten & remove null timestamps        
        ind_stimuli(ind_stimuli==0)=6; % Replacing the null value with the ref to the placeholder image
        ind_stimuli = int32(ind_stimuli - 1); % Offset for 0 indexing
        ts_stimuli = reshape(tsPresentAll',[],1); % ts_stimuli = nonzeros(ts_stimuli); % Row-wise flatten & remove null timestamps
        if ~isequal(size(ind_stimuli),size(ts_stimuli))
            error('Dimensions of ts_stimuli & ind_stimuli do not match.')
        end    

        % Setting null timestamps to offsets. 
        % (Counteracts the validation error when entering values for
        % intermediate null picture timestamps.)
        indZeroTS = find(ts_stimuli == 0);
        for ind = 1:length(indZeroTS)
            ts_stimuli(indZeroTS(ind)) = ts_stimuli(indZeroTS(ind)-1) + 0.01; % Arbitrary minor offset to keep the time increasing. 
        end

        % Export IndexSeries as 'StimulusPresentation'
        stimuli_index = types.core.IndexSeries(...
            'description', 'Presentation order of the stimulus. Indexes ''StimulusTemplates''.', ...
            'data',ind_stimuli, ...
            'timestamps', ts_stimuli,...
            'indexed_images', types.untyped.SoftLink('/stimulus/templates/StimulusTemplates'));
        nwb.stimulus_presentation.set('StimulusPresentation',stimuli_index);              
       
        %% Add Electrodes to General
        elecTblVars = {'x', 'y', 'z', 'location', 'filtering', 'group', 'group_name','origChannel'};
        device_description = ['Recordings were performed with Macro-Micro Hybrid ' ...
            'Depth Electrodes with Behnke Fried/Micro Inner Wire Bundle in which ' ...
            'each individual microwire has a diameter of 40 microns. ' ...
            'Likwise, each Depth Electrode has 8 microwires.'];
        electrodeTable_raw = [...
            cellStatsAll.channel;...
            cellStatsAll.cellNr;...
            cellStatsAll.brainAreaOfCell;...
            cellStatsAll.origClusterID...
            ]; electrodeTable_raw = electrodeTable_raw';

        elec_nums = unique(electrodeTable_raw(:,1));
        filterStr='300-3000Hz';

        % Create entry for each device & Create meta info electrodes table
        tbl = [];
        for i_elec = elec_nums'
            %Set the Device Label for the Microwires
            device_label=['NLX-microwires-', num2str(i_elec)];
            ov = types.untyped.ObjectView(['/general/extracellular_ephys/' device_label]);
            
            inds = find( electrodeTable_raw(:,1)==i_elec );  % Cells on this channel
            brainArea_ofChannel = electrodeTable_raw(inds(1),3); % Brain area code of this channel
            [~, brainArea_name] = translateArea_SB([], brainArea_ofChannel); % Converts number code to text string

            switch (brainArea_ofChannel)
                case 1
                    MNI_coordinates_raw = SBsessions(i).RH;
                case 2
                    MNI_coordinates_raw = SBsessions(i).LH;
                case 3
                    MNI_coordinates_raw = SBsessions(i).RA;
                case 4
                    MNI_coordinates_raw = SBsessions(i).LA;
                case 5
                    MNI_coordinates_raw = SBsessions(i).RdACC;
                case 6
                    MNI_coordinates_raw = SBsessions(i).LdACC;        
                case 7
                    MNI_coordinates_raw = SBsessions(i).RpSMA;
                case 8
                    MNI_coordinates_raw = SBsessions(i).LpSMA;
                case 12
                    MNI_coordinates_raw = SBsessions(i).LOFC;
                case 13
                    MNI_coordinates_raw = SBsessions(i).ROFC;
                otherwise
                    MNI_coordinates_raw=[];
                    warning('undefined area code (MNI coordinates not found)');
            end

            if ~isempty(MNI_coordinates_raw) && ~strcmp('NaN',MNI_coordinates_raw)
                % Converts string containing array info
                MNI_coordinates = str2num(MNI_coordinates_raw); %#ok<ST2NM> 
                %x/y/z has to be float32
                xPos = (MNI_coordinates(1));
                yPos = (MNI_coordinates(2));
                zPos = (MNI_coordinates(3));
            else
                xPos = 0;
                yPos = 0;
                zPos = 0;
            end


            channelNr = electrodeTable_raw(inds(1), 1);
            enableMissingMNIwarning = 1;
            if strcmp('NaN',MNI_coordinates_raw)
                if enableMissingMNIwarning
                    warning(['MNI coordinates missing for:Subject:' subjectDir  ' Ch:' num2str(channelNr) 'Area:' num2str(brainArea_ofChannel)  ]);
                end
            end

            if isempty(tbl)
                %create table
                tbl = table( xPos, yPos, zPos, {brainArea_name}, {filterStr}, ov,{'micros'},channelNr, 'VariableNames', elecTblVars);
            else
                %append to existing table
                tbl = [tbl; { xPos, yPos, zPos, {brainArea_name}, {filterStr}, ov, {'micros'}, channelNr} ]; %#ok<AGROW> % Changing table size acceptable due to low channel count. 
            end

           %Set the Devices() Group
           nwb.general_devices.set(device_label, types.core.Device('description', device_description));
           %Set the Electrode() Group
           nwb.general_extracellular_ephys.set(device_label,...
            types.core.ElectrodeGroup(...
            'description', 'Microwire', ...
            'location', brainArea_name, ...
            'device', types.untyped.SoftLink(['/general/devices/' device_label])));
        end
        electrode_table = util.table2nwb(tbl);
        electrode_table.id.data = int32(electrode_table.id.data); % Converting to nwb standard precision. 
        electrode_table.description='microwire electrodes table';
        nwb.general_extracellular_ephys_electrodes = electrode_table;

        %% Define Units (Clusters)
        % Reference Chart: https://github.com/NeurodataWithoutBorders/matnwb/blob/master/tutorials/html/UnitTimes.png

        % Load spiking data for session. 
        orig_spike_times_allCells = {cellStatsAll.timestamps}';  % Creates vertical cell array of spike times for all single units (SU).
        spike_times_allCells = cellfun(@(x) (x-timestampsOffset).*TIME_SCALING, orig_spike_times_allCells,'UniformOutput',false);
        waveforms_allCells = {cellStatsAll.waveforms}'; % Creates vertical cell array of Nx256 waveforms for all single units (SU).
        

        channel_ofCells = electrodeTable_raw(:,1);
        nwb.units = types.core.Units(...
            'colnames', {...
            'spike_times',  ...
            'electrodes',...
            'clusterID_orig',...
            'waveforms_mean_snr',...
            'waveforms_peak_snr',...
            'waveforms_isolation_distance',...
            'waveforms_mean_proj_dist'...
            },...
            'description','units table');
            % 'waveforms_mean_snr',...
            % 'waveforms_peak_snr',...
            % 'waveforms_isolation_distance'...


            % 'waveforms_projection_distance'... % Not supported for ragged
            % array export. 
        % % Entering Spike Times
        [spike_times_vector, spike_times_index] = util.create_indexed_column(spike_times_allCells);
        nwb.units.spike_times = spike_times_vector ;
        nwb.units.spike_times.description = 'Timestamps when spikes occured (seconds)';
        nwb.units.spike_times_index = spike_times_index;
        
        nrUnits = length(spike_times_index.data);  % entire session across all units has so many spikes
        nwb.units.id = types.hdmf_common.ElementIdentifiers('data', int32([1:length(spike_times_index.data)]-1)); %#ok<NBRAK>

        % Entering Waveforms
        [waveforms, waveforms_index,waveforms_index_index] = create_index_indexed_column(waveforms_allCells,'Array of Nx256 waveforms across all clusters.');
        waveform_mean = cell2mat(cellfun(@(x) mean(x,1),waveforms_allCells,'UniformOutput',false))';
        waveform_sd = cell2mat(cellfun(@(x) std(x,1),waveforms_allCells,'UniformOutput',false))';

        nwb.units.waveforms = waveforms;  % VectorData object of all Nx256 waveforms. 'sampling_rate' and 'unit' are appended in create_index_indexed_column()
        nwb.units.waveforms_index = waveforms_index; % Note that each SU was recorded on one electrode. ; % Index into the waveforms dataset. One value for every spike event. See ‘waveforms’ for more detail.
        nwb.units.waveforms_index_index = waveforms_index_index; % Index into the waveforms_index dataset. One value for every unit (row in the table).

        nwb.units.waveform_mean = types.hdmf_common.VectorData('data',waveform_mean,...
            'unit','microvolts',...
            'sampling_rate', 100000, ...
            'description','Mean waveform for each unit.');
        nwb.units.waveform_sd = types.hdmf_common.VectorData('data',waveform_sd,...
            'unit', 'microvolts',...
            'sampling_rate', 100000,...
            'description','Standard deviation for all waveform means at each timestamp.');

        % Waveform Metrics
        nwb.units.vectordata.set('waveforms_mean_snr',...
            types.hdmf_common.VectorData('data',[cellStatsAll.mean_SNR],'description','Mean Signal-to-Noise Ratio (SNR) across all samples of the mean waveform.'));
        nwb.units.vectordata.set('waveforms_peak_snr',...
            types.hdmf_common.VectorData('data',[cellStatsAll.peak_SNR],'description','Signal-to-Noise Ratio (SNR) of the mean signal amplitude.'));
        nwb.units.vectordata.set('waveforms_isolation_distance',...
            types.hdmf_common.VectorData('data',[cellStatsAll.isolation_distance],'description','Cluster Isolation distance, computed using all waveforms in the cluster.'));

        nwb.units.vectordata.set('waveforms_mean_proj_dist',...
            types.hdmf_common.VectorData('data',[cellStatsAll.mean_proj_dist],'description','Cluster Isolation distance, computed using all waveforms in the cluster.'));


        %== link each unit to entry in electrode table (which will identify channel it was recorded on, brain area etc.
        elec_channels = unique(electrodeTable_raw(:,1)); % each channel that has at least one unit

        link_toElectrode_table=[];
        for k=1:length(channel_ofCells)
            link_toElectrode_table(k) = find( elec_channels == channel_ofCells(k)); %#ok<SAGROW> % Growing array acceptable due to low channel count. 
        end
        link_toElectrode_table = link_toElectrode_table-1;  %id in electrode_table is zero based

        ov_elTable = types.untyped.ObjectView('/general/extracellular_ephys/electrodes');
        
        link_toElectrode_table_Cells = num2cell( link_toElectrode_table);
        [electrodes] = util.create_indexed_column(link_toElectrode_table_Cells );
        
        nwb.units.electrodes = types.hdmf_common.DynamicTableRegion('table',ov_elTable, ...
            'description', 'single electrodes', 'data', int32(electrodes.data));

        %== Assigning Cluster IDs (IDs that references back to the lab's
        % orginally sorted cluster IDs. 
        clusterID_orig = [cellStatsAll(:).origClusterID]';
        nwb.units.vectordata.set('clusterID_orig', types.hdmf_common.VectorData(...
            'data', clusterID_orig, ...
            'description', 'Cluster IDs of units, which referneces the cluster ID used in the native dataset. Used for cross-referencing validating the exported dataset'));

        %% Export to NWB File 
        if exportFlag == 1
        NWBfilename = SBsessions(i).filename;

        exportFileName = [basePathNWBsave filesep NWBfilename];
        if isfile(exportFileName)
         warning('File already exists. Creating backup.');
         movefile(exportFileName, [exportFileName '.bak']);
        end

        disp(['Exporting: ' exportFileName]);
        nwbExport(nwb, exportFileName);
        disp(['Finished Exporting: ' exportFileName]);

        logStr = sprintf('SBID_%s_%s Export Complete Without Errors',num2str(SBsessions(i).ID),SBsessions(i).sessionID);
        exportLog(find(exportLog=="",1)) = logStr;            
        end
%     catch
%         logStr = sprintf('ERROR: SBID_%s_%s Export',num2str(SBsessions(i).ID),SBsessions(i).sessionID);
%         warning(logStr) %#ok<SPWRN>
%         exportLog(find(exportLog=="",1)) = logStr;
%     end
end
disp(exportLog)


%% Projection Test Histogram (save this manually)
% 
% if plotProjectionTest
%     % Plot: Pairwise Distance (Projection Test)
%     colors = {'#02009B'};
%     figure()
%     histogram(nonzeros(proj_dist_all),20,'FaceColor',colors{1},'FaceAlpha',1);
% 
%     title('Pair Distance (Proj Test)')
% 
%     set(gca,'FontSize',13)
%     xlim([0 80])
% end

