%% Feature Binding Working Memory experiment Pilot Nov 2024
% Participants are asked to hold two items with two features (cat/num) in their WM.
% A probe question then asks one feature (num) in one of the item

% pilot demo run on WIN64 system, TTL disabled!

% Junda Zhu, Nov 2024, adapt from *Johathan Daume, 2024*
%% Prep
clear all, close all

% Bring command window to front. Easier to kill in case of bug...
commandwindow
%% Switches and initial information
% real experiment or just testing?
realexp = 0;

% background luminance?
c.bgLum = 0;

%% clear commandwindow
home
fprintf('\n  Feature_binding_pilot 2024\n  -----------------\n\n')

% files
c.path.base = pwd;
c.path.data = fullfile(c.path.base, 'data');

%% Prepare Cedrus stuff
try
    c.cedrus_handle=initCEDRUS;
    c.CedrusBox = 1;
catch
    c.CedrusBox = 0;
    warning('Cedrus Box not connected. Use internal keyboard!')
end

%% ask for participant info
if realexp
    participant_info;
else
    c.patientID = 'Pxx';
    c.age = 99;
    c.gender = 'xx';
    c.handedness = 'xx';
    c.session = 1;
    startintrial = 1;
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
% if strcmp(c.OS, 'MACI64')
Screen('Preference', 'SkipSyncTests', 1) % skip sync test
% end
% create PTB screen w
screens = Screen('Screens');
screenNumber = max(screens);

% open window
% if realexp
[w, rect] = Screen('OpenWindow',screenNumber, repmat(c.bgLum,3,1)');

% Hides cursor during experiment (recalled by "sca")
% HideCursor(screenNumber);

c.frame_rate = Screen('FrameRate',screenNumber);
[center(1), center(2)] = RectCenter(rect);
if c.frame_rate == 0, c.frame_rate = 60; end % display c.frame_rate in Hz

% Use realtime priority for better timing precision:
priorityLevel = MaxPriority(w);
Priority(priorityLevel);

% Text size
Screen('TextSize', w, 60);
%% PTB ini
rng('shuffle');
KbCheck;
KbName('UnifyKeyNames')
% ListenChar(2); % no non-number inputs
%% create config file, data matrix, behave file
if startintrial == 1
    c = set_parameters(c);
    c.nTrials = 120;
    [datMat, c] = make_stimarray_demo(c);
    if realexp == 1
        idDummy = round(clock);
        dateNtime = [num2str(idDummy(1)) num2str(idDummy(2)) num2str(idDummy(3)) '_' num2str(idDummy(4)) num2str(idDummy(5)) num2str(idDummy(6))];
        datMat_file = fullfile(c.path.data,sprintf('%s_session_%d_feature_binding_%s_datMat.mat',c.patientID,c.session,dateNtime));
        save(datMat_file, 'datMat');
        ResFileBehav = fopen(fullfile(c.path.data ,sprintf('%s_session_%d_feature_binding_%s_behav.txt',c.patientID,c.session,dateNtime)),'w+');
        fprintf(ResFileBehav,sprintf('feature binding working memory experiment - %s / session %d / %s \n',c.patientID,c.session,dateNtime));
        save(fullfile(c.path.data ,sprintf('%s_session_%d_feature_binding_%s_config.mat',c.patientID,c.session,dateNtime)), 'c')
    end
else
    % this info is loaded in participant_info since it existed already
end

%% prepare images of visual prompts
pics_cat1 = cell(20,1);
pics_cat2 = cell(20,1);
pics_cat3 = cell(20,1);
pics_cat4 = cell(20,1);
for ipic = 1:20
    try
        img1 = imread(fullfile(c.path.base,sprintf('stimuli/Person/%d.jpg',ipic+9)));
    catch
        img1 = imread(fullfile(c.path.base,sprintf('stimuli/Person/%d.jpeg',ipic+9)));
    end
    pics_cat1{ipic,1} = Screen('MakeTexture',w,img1);
    try
        img2 = imread(fullfile(c.path.base,sprintf('stimuli/Animal/%d.jpg',ipic+9)));
    catch
        img2 = imread(fullfile(c.path.base,sprintf('stimuli/Animal/%d.jpeg',ipic+9)));
    end
    pics_cat2{ipic,1} = Screen('MakeTexture',w,img2);
    try
        img3 = imread(fullfile(c.path.base,sprintf('stimuli/Food/%d.jpg',ipic+9)));
    catch
        img3 = imread(fullfile(c.path.base,sprintf('stimuli/Food/%d.jpeg',ipic+9)));
    end
    pics_cat3{ipic,1} = Screen('MakeTexture',w,img3);
    try
        img4 = imread(fullfile(c.path.base,sprintf('stimuli/Car/%d.jpg',ipic+9)));
    catch
        img4 = imread(fullfile(c.path.base,sprintf('stimuli/Car/%d.jpeg',ipic+9)));
    end
    pics_cat4{ipic,1} = Screen('MakeTexture',w,img4);
end

% oval fixdot coordinates
fix_coord  = [center-10 center+10];
fix_color = 200;

%% Present text before starting the exp to start recording.
present_text(w, 'Ready? Press ''Start'' button to start experiment.' , c.key.middle, [], c.bgLum, c)

% blank screen
Screen('Flip', w);
% sendTTL(c.marker.expstart)
WaitSecs(1);


%% Begin experiment

for i_trial = startintrial:c.nTrials

    % get the relevant infos from datMat
    t_preStim      = datMat(i_trial, c.col.t_preStim);
    t_delay1       = datMat(i_trial, c.col.t_delay1);
    t_delay2       = datMat(i_trial, c.col.t_delay2);
    pic1           = datMat(i_trial, c.col.firstPic);
    pic2           = datMat(i_trial, c.col.secondPic);
    probePic       = datMat(i_trial, c.col.probePic);
    probeCat       = datMat(i_trial, c.col.probeCat);

    %% start presentation
    % % present countdown
    % if i_trial == startintrial || i_trial == c.nTrials/2 + 1
    %     countdown(c,w);
    % end

    %% Present stimuli
    n_pics = 2;
    pics_handle = cell(1, n_pics);
    for ipic = 1:n_pics
        cat = floor(eval(sprintf('pic%d', ipic)) / 1000);
        idx = mod(eval(sprintf('pic%d', ipic)), 1000);
        if ~isnan(cat) && cat >= 1 && cat <= 4
            pics_handle{ipic} = eval(sprintf('pics_cat%d{%d}', cat, idx));
        end
    end
    present_stimuli;
    %% Probe
    Screen('Flip', w);
    categories = {'people', 'animals', 'food items', 'cars'};
    positions = {'first', 'second'};

    if probePic == 1 || probePic == 2
        position_text = positions{probePic};
        category_text = categories{probeCat};

        % Constructing formatted text
        text_to_draw = sprintf(' In the <u><b>%s<b><u> picture,\n how many <u><b>%s<u><b>\n were there?', position_text, category_text);
        [~,~,~,~,wbounds] = DrawFormattedText2(text_to_draw, ...
            'win',w,'sx','center','sy','center','xalign','center','yalign','center');
    end
    Screen('Flip', w);
    % sendTTL(c.marker.retrocue);

    %% Evaluate response
    % response cue
    [scrX,scrY] = RectCenter(rect);
    [~,~,~,~,wbounds] = DrawFormattedText2(text_to_draw, ...
        'win',w,'sx','center','sy','center','xalign','center','yalign','center');
    DrawFormattedText2('<size=150><color=0,0.8,0>0', ...
        'win',w,'sx',scrX-500,'sy','center','xalign','center','yalign','center');
    DrawFormattedText2('<size=150><color=0.8,0,0>5', ...
        'win',w,'sx',scrX+500,'sy','center','xalign','center','yalign','center');
    DrawFormattedText2('<size=150><color=0,0,0.8>1', ...
        'win',w,'sx','center','sy',scrY-300,'xalign','center','yalign','center');

    t0 = Screen('Flip', w);
    % sendTTL(c.marker.probe)

    if c.CedrusBox
        evt = CedrusResponseBox('WaitButtonPress', c.cedrus_handle);
        ch = num2str(evt.button);
        secs = evt.ptbfetchtime;
    else
        [ch, when] = GetChar();
        secs = when.secs;
    end
    % sendTTL(c.marker.response)
    evaluate_pressed_key;
    Screen('Flip', w);

    %% after each trial

    % Save response and trial info to file
    if realexp
        fprintf(ResFileBehav, ['\n' repmat('%1.4f ', [1 c.col.n ])], single(datMat(i_trial,:)));
        save(datMat_file, 'datMat');
    end

    % break? end?
    if i_trial == c.nTrials || i_trial == c.nTrials/2
        % sendTTL(c.marker.break)
        % Give Feedback
        acc = mean(datMat(:,c.col.acc),'omitmissing')*100;
        if i_trial~= c.nTrials
            feedback = sprintf('B R E A K ! Correct answers:  %.02f%%',acc);
        else
            feedback = sprintf('Thank you! Correct answers:  %.02f%%',acc);
        end
        present_text(w, feedback , c.key.start, [], c.bgLum, c)
        % if i_trial == c.nTrials/2
        %     present_text(w, 'From now on, please hit GREEN for "NO" and RED for "YES".' , c.key.start, [], c.bgLum, c)
        % elseif i_trial == c.nTrials
        %     % sendTTL(c.marker.expend)
        % end
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