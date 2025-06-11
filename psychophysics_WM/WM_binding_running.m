%% Feature Binding Working Memory experiment Pilot Nov 2024
% Participants are asked to hold two items with two features (cat/num) in their WM.
% A probe question then asks one feature (num) in one of the item

% test version on 245.4-4ubuntu3.24 system

% Using Cedrus box model C-8434

% Junda Zhu, April 2025
%% Prep
clear all, close all

% Bring command window to front. Easier to kill in case of bug...
commandwindow
%% Switches and initial information
% real experiment or just testing?
is_real_exp = input('Real exp (0/1): ');

if is_real_exp
    stim_set = input("Which stimuli set (1/2): ");
end

% background luminance?
c.bg_lum = 0;

%% clear commandwindow
home
fprintf('\n  Feature_binding_pilot 2024\n  -----------------\n\n')

% files
c.path.base = pwd;
c.path.data = fullfile(c.path.base, 'data');

%% Prepare Cedrus stuff
try
    c.cedrus_handle=initCEDRUS;
    c.is_cedrus_box = 1;
catch
    c.is_cedrus_box = 0;
    warning('Cedrus Box not connected. Use internal keyboard!')
end

%% ask for participant info
if is_real_exp
    participant_info;
else
    c.patientID = 'Pxx';
    c.age = 99;
    c.gender = 'xx';
    c.handedness = 'xx';
    c.session = 1;
    startintrial = 1;
    num_trials_wanted = input('How many trials (288?): ');

end

c.category1 = 'person';
c.category2 = 'animal';
c.category3 = 'food';
c.category4 = 'car';
%% start using psychtoolbox
sca
% try
AssertOpenGL; % obligatory / needed?
% which OS?
c.OS = computer;
if strcmp(c.OS, 'MACI64')
    Screen('Preference', 'SkipSyncTests', 1) % skip sync test
end
% create PTB screen w
screens = Screen('Screens');
screen_number = max(screens);

% open window
% if realexp
[w, rect] = Screen('OpenWindow',screen_number, repmat(c.bg_lum,3,1)');
% Hides cursor during experiment (recalled by "sca")
HideCursor(screen_number);

c.frame_rate = Screen('FrameRate',screen_number);
[center(1), center(2)] = RectCenter(rect);
if c.frame_rate == 0
    c.frame_rate = 60;
end % display c.frame_rate in Hz

% Use realtime priority for better timing precision:
priority_level = MaxPriority(w);
Priority(priority_level);

% Text size
Screen('TextSize', w, 60);
%% PTB ini
rng('shuffle');
KbCheck;
KbName('UnifyKeyNames')
%     ListenChar(2); % no non-number inputs
%% create config file, data matrix, behave file
if startintrial == 1
    c = set_parameters(c);
    [datMat, c] = make_stimarray(c,"stim_conditions.csv");
    if is_real_exp
        idDummy = round(clock);
        dateNtime = [num2str(idDummy(1)) num2str(idDummy(2)) num2str(idDummy(3)) '_' num2str(idDummy(4)) num2str(idDummy(5)) num2str(idDummy(6))];
        datMat_file = fullfile(c.path.data,sprintf('%s_session_%d_WM_binding_%s_datMat.mat',c.patientID,c.session,dateNtime));
        save(datMat_file, 'datMat');
        ResFileBehav = fopen(fullfile(c.path.data ,sprintf('%s_session_%d_WM_binding_%s_behav.txt',c.patientID,c.session,dateNtime)),'w+');
        fprintf(ResFileBehav,sprintf('feature binding working memory experiment - %s / session %d / %s \n',c.patientID,c.session,dateNtime));
        save(fullfile(c.path.data ,sprintf('%s_session_%d_WM_binding_%s_config.mat',c.patientID,c.session,dateNtime)), 'c')
    end
else
    % this info is loaded in participant_info since it existed already
end
%% prepare images of visual prompts
pics_cat1 = cell(20,1);
pics_cat2 = cell(20,1);
pics_cat3 = cell(20,1);
pics_cat4 = cell(20,1);
c.path.stim = sprintf('stimuli%d',stim_set);
for ipic = 10:29
    try
        img1 = imread(fullfile(c.path.base, c.path.stim, sprintf('Person/%d.jpg',ipic)));
    catch
        img1 = imread(fullfile(c.path.base,c.path.stim, sprintf('Person/%d.jpeg',ipic)));
    end
    pics_cat1{ipic,1} = Screen('MakeTexture',w,img1);
    try
        img2 = imread(fullfile(c.path.base,c.path.stim, sprintf('Animal/%d.jpg',ipic)));
    catch
        img2 = imread(fullfile(c.path.base,c.path.stim, sprintf('Animal/%d.jpeg',ipic)));
    end
    pics_cat2{ipic,1} = Screen('MakeTexture',w,img2);
    try
        img3 = imread(fullfile(c.path.base,c.path.stim, sprintf('Food/%d.jpg',ipic)));
    catch
        img3 = imread(fullfile(c.path.base,c.path.stim, sprintf('Food/%d.jpeg',ipic)));
    end
    pics_cat3{ipic,1} = Screen('MakeTexture',w,img3);
    try
        img4 = imread(fullfile(c.path.base,c.path.stim, sprintf('Car/%d.jpg',ipic)));
    catch
        img4 = imread(fullfile(c.path.base,c.path.stim, sprintf('Car/%d.jpeg',ipic)));
    end
    pics_cat4{ipic,1} = Screen('MakeTexture',w,img4);
end

% oval fixdot coordinates
fix_coord  = [center-10 center+10];
fix_color = 200;

%% Present text before starting the exp to start recording.
starting_text = 'Ready? Press Center button to start experiment.';
present_text(w, starting_text, c.key.middle, [], c)

% blank screen
Screen('Flip', w);
sendTTL(c.marker.expstart)
WaitSecs(1);

%% Trial loop
c.nTrials = min(c.nTrials,num_trials_wanted);
    categories = {'people', 'animals', 'food items', 'cars'};
    positions = {'Earlier', 'Later'};
for i_trial = startintrial:c.nTrials
    % get the relevant infos from datMat
    pic1           = datMat(i_trial, c.col.first_pic);
    pic2           = datMat(i_trial, c.col.second_pic);
    probe_pic       = datMat(i_trial, c.col.probe_pic);
    probe_cat       = datMat(i_trial, c.col.probe_cat);

    % before first trial, present countdown
    if i_trial == startintrial || i_trial == c.nTrials/2 + 1
        countdown(w,c);
    end

    %% Present stimuli
    n_pics = 2;
    pics_handle = cell(1, n_pics);
    for ipic = 1:n_pics
        cat = floor(eval(sprintf('pic%d', ipic)) / 1000);% first 1 digit
        idx = mod(eval(sprintf('pic%d', ipic)), 1000);% last 2 digits
        if ~isnan(cat) && cat >= 1 && cat <= 4
            pics_handle{ipic} = eval(sprintf('pics_cat%d{%d}', cat, idx));
        end
        hint_text(ipic) = {''};
    end
    present_stimuli(w,c,fix_coord,fix_color,pics_handle,hint_text,center);
    %% Probe
    Screen('Flip', w);
    if probe_pic == 1 || probe_pic == 2
        position_text = positions{probe_pic};
        category_text = categories{probe_cat};

        % Constructing formatted text
        probe_text = sprintf(' <color=1.0,1.0,1.0><u><b>%s<b><u> picture,\n how many <u><b>%s<u><b>?', position_text, category_text);
        present_text(w, probe_text, [], [], c);
    end
    sendTTL(c.marker.probeOnset);

    %% Response
    % Response options
    options = [{' 0 '};{' 1 '};{' 5 '}]; % 3AFC
    datMat = present_and_evaluate_response(w,rect,c,datMat,options,probe_text,i_trial);
    Screen('Flip', w);
    %% after each trial
    % Save response and trial info to file
    if is_real_exp
        fprintf(ResFileBehav, ['\n' repmat('%1.4f ', [1 c.col.n ])], single(datMat(i_trial,:)));
        save(datMat_file, 'datMat');
    end

    % break? end?
    if i_trial == c.nTrials || i_trial == c.nTrials/2
        % Give Feedback
        acc = mean(datMat(:,c.col.acc),'omitnan')*100;
        if i_trial~= c.nTrials
            sendTTL(c.marker.break)
            feedback = sprintf('BREAK! Correct answers:  %.02f%%',acc);
        else
            sendTTL(c.marker.expend)
            feedback = sprintf('You are doing great! Correct answers:  %.02f%%',acc);
        end
        present_text(w, feedback , c.key.middle, [], c)
    end
    WaitSecs(rand*0.5+0.5);
end
ShowCursor
Screen('CloseAll');
CedrusResponseBox('CloseAll');
Priority(0);
% turn off character listening and reset the buffer which holds the captured characters
ListenChar(0);
% allow all keys
RestrictKeysForKbCheck([])