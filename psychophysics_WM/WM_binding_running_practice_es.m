%% Feature Binding Working Memory experiment Pilot Nov 2024
% ES version
% Participants are asked to hold two items with two features (cat/num) in their WM.
% A probe question then asks one feature (num) in one of the item

% test version on 245.4-4ubuntu3.24 system

% Using Cedrus box model C-8434

% Junda Zhu, Feb 2025
%% Prep
clear all, close all

% Bring command window to front. Easier to kill in case of bug...
commandwindow
%% Switches and initial information
% real experiment or just testing?
is_real_exp = 0

% background luminance?
c.bg_lum = 0;

%% clear commandwindow
home
fprintf('\n  Feature_binding_pilot_es 2024\n  -----------------\n\n')

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
    num_trials_wanted = 6;

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
    [datMat, c] = make_stimarray(c,"conditions_practice.csv");
else
    % this info is loaded in participant_info since it existed already
end
%% prepare images of visual prompts
pics_cat1 = cell(20,1);
pics_cat2 = cell(20,1);
pics_cat3 = cell(20,1);
pics_cat4 = cell(20,1);
for ipic = 10:29
    try
        img1 = imread(fullfile(c.path.base,sprintf('stimuli/Person/%d.jpg',ipic)));
    catch
        img1 = imread(fullfile(c.path.base,sprintf('stimuli/Person/%d.jpeg',ipic)));
    end
    pics_cat1{ipic,1} = Screen('MakeTexture',w,img1);
    try
        img2 = imread(fullfile(c.path.base,sprintf('stimuli/Animal/%d.jpg',ipic)));
    catch
        img2 = imread(fullfile(c.path.base,sprintf('stimuli/Animal/%d.jpeg',ipic)));
    end
    pics_cat2{ipic,1} = Screen('MakeTexture',w,img2);
    try
        img3 = imread(fullfile(c.path.base,sprintf('stimuli/Food/%d.jpg',ipic)));
    catch
        img3 = imread(fullfile(c.path.base,sprintf('stimuli/Food/%d.jpeg',ipic)));
    end
    pics_cat3{ipic,1} = Screen('MakeTexture',w,img3);
    try
        img4 = imread(fullfile(c.path.base,sprintf('stimuli/Car/%d.jpg',ipic)));
    catch
        img4 = imread(fullfile(c.path.base,sprintf('stimuli/Car/%d.jpeg',ipic)));
    end
    pics_cat4{ipic,1} = Screen('MakeTexture',w,img4);
end

% oval fixdot coordinates
fix_coord  = [center-10 center+10];
fix_color = 200;

%% Present text before starting the exp to start recording.
starting_text = '¿Listo? Presiona el botón central para comenzar la práctica.';
present_text(w, starting_text, c.key.middle, [], c)

% blank screen
Screen('Flip', w);
WaitSecs(1);

%% Trial loop
c.nTrials = min(c.nTrials,num_trials_wanted);
categories = {'personas', 'animales', 'alimentos', 'autos'};
positions = {'primera', 'última'};
for i_trial = startintrial:c.nTrials
    % get the relevant infos from datMat
    pic1           = datMat(i_trial, c.col.first_pic);
    pic2           = datMat(i_trial, c.col.second_pic);
    probe_pic       = datMat(i_trial, c.col.probe_pic);
    probe_cat       = datMat(i_trial, c.col.probe_cat);

    % before first trial, present countdown
    if i_trial == startintrial
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
        hint_text(ipic) = positions(ipic);% hint text
    end
    present_stimuli_es(w,c,fix_coord,fix_color,pics_handle,hint_text,center);
    %% Probe
    Screen('Flip', w);

    if probe_pic == 1 || probe_pic == 2
        position_text = positions{probe_pic};
        category_text = categories{probe_cat};

        % Constructing formatted text
        probe_text = sprintf(' <color=1.0,1.0,1.0><u><b>%s<b><u> imagen,\n ¿cuántos <u><b>%s<u><b>?', position_text, category_text);
        present_text(w, probe_text, [], [], c);
    end

    %% Response
    % Response options
    options = [{' 0 '};{' 1 '};{' 5 '}]; % 3AFC
    datMat = present_and_evaluate_response(w,rect,c,datMat,options,probe_text,i_trial);
    Screen('Flip', w);
    %% after each trial
    % Save response and trial info to file

    % break? end?
    if i_trial == c.nTrials
        % Give Feedback
        acc = mean(datMat(:,c.col.acc),'omitnan')*100;
        feedback = sprintf('¡Bien hecho! Respuestas correctas: %.02f%%',acc);
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