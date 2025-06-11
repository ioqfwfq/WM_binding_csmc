%% Retro Cue Working Memory experiment Pilot 1 Nov 2024
% Participants are asked to hold two items in their WM. A retro cue then
% asks whether to focus on first or second item which will be asked about
% in 80% of the cases

% This is meant to be a pilot study

% JD Nov 2024

% To do

clear all, close all, clc


% Bring command window to front. Easier to kill in case of bug...
commandwindow


%% Switches and initial information

% real experiment or just testing?
realexp = 0;

% background luminance?
c.bgLum = 0;

%% clear commandwindow
home
fprintf('\n  RetroCue-Pilot 2024\n  -----------------\n\n')

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

c.category1 = 'Person';
c.category2 = 'Animal';
c.category3 = 'Food';
%% start using psychtoolbox
sca
% try
AssertOpenGL; % obligatory / needed?
% which OS?
c.OS = computer;
% if strcmp(c.OS, 'MACI64')
Screen('Preference', 'SkipSyncTests', 1)
% end
% create PTB screen w
screens = Screen('Screens');
screenNumber = max(screens);

% open window
% if realexp
[w, rect] = Screen('OpenWindow',screenNumber, repmat(c.bgLum,3,1)');
% else
%     [w, rect] = Screen('OpenWindow',screenNumber, repmat(c.bgLum,3,1)', [20 20 800 320]);
% end

% Hides cursor during experiment (recalled by "sca")
% HideCursor(screenNumber);

c.frame_rate = Screen('FrameRate',screenNumber);
[center(1), center(2)] = RectCenter(rect);
if c.frame_rate == 0, c.frame_rate = 60; end% display c.frame_rate in Hz


% Use realtime priority for better timing precision:
priorityLevel = MaxPriority(w);
Priority(priorityLevel);

% Text size
Screen('TextSize', w, 60);


%% PTB ini
rng('shuffle');
KbCheck;
KbName('UnifyKeyNames')
ListenChar(2);

%% create config file, data matrix, behave file
if startintrial == 1
    c = set_parameters(c);
    c.nTrials = 12;
    [datMat, c] = make_stimarray_demo(c);
    if realexp == 1
        idDummy = round(clock);
        dateNtime = [num2str(idDummy(1)) num2str(idDummy(2)) num2str(idDummy(3)) '_' num2str(idDummy(4)) num2str(idDummy(5)) num2str(idDummy(6))];
        datMat_file = fullfile(c.path.data,sprintf('%s_session_%d_retroCue_%s_datMat.mat',c.patientID,c.session,dateNtime));
        save(datMat_file, 'datMat');
        ResFileBehav = fopen(fullfile(c.path.data ,sprintf('%s_session_%d_retroCue_%s_behav.txt',c.patientID,c.session,dateNtime)),'w+');
        fprintf(ResFileBehav,sprintf('RetroCue experiment - %s / session %d / %s \n',c.patientID,c.session,dateNtime));
        save(fullfile(c.path.data ,sprintf('%s_session_%d_retroCue_%s_config.mat',c.patientID,c.session,dateNtime)), 'c')
    end
else
    % this info is loaded in participant_info since it existed already
end

%% prepare images of visual prompts
pics_cat1 = cell(c.nTrials,1);
pics_cat2 = cell(c.nTrials,1);
pics_cat3 = cell(c.nTrials,1);
for ipic = 1:c.nTrials
    img1 = imread(fullfile(c.path.base,sprintf('stimuli/demo/1people/%d.jpg',ipic)));
    pics_cat1{ipic,1} = Screen('MakeTexture',w,img1);
    img2 = imread(fullfile(c.path.base,sprintf('stimuli/demo/2animals/%d.jpg',ipic)));
    pics_cat2{ipic,1} = Screen('MakeTexture',w,img2);
    img3 = imread(fullfile(c.path.base,sprintf('stimuli/demo/3food/%d.jpg',ipic)));
    pics_cat3{ipic,1} = Screen('MakeTexture',w,img3);
end

% oval fixdot coordinates
fix_coord  = [center-10 center+10];
fix_color = 200;

%% Present text before starting the exp to start recording.
present_text(w, 'Ready? Press ''Start'' button to start experiment.' , c.key.start, [], c.bgLum, c)

% blank screen
Screen('Flip', w);
% sendTTL(c.marker.expstart)
WaitSecs(1);


%% Begin experiment

for i_trial = startintrial:c.nTrials

    % get the relevant infos from datMat
    t_preStim      = datMat(i_trial, c.col.t_preStim);
    t_maint1       = datMat(i_trial, c.col.t_maint1);
    t_maint2       = datMat(i_trial, c.col.t_maint2);
    cue            = datMat(i_trial, c.col.retrocue);
    match          = datMat(i_trial, c.col.match);
    pic1           = datMat(i_trial, c.col.firstPic);
    pic2           = datMat(i_trial, c.col.secondPic);
    pic3           = datMat(i_trial, c.col.probePic);

    %% start presentation
    % present countdown
    if i_trial == startintrial || i_trial == c.nTrials/2 + 1
        countdown(c,w);
    end

    %% Present stimuli
    n_pics = 3;
    pics_handle = cell(1,n_pics);
    for ipic = 1:n_pics
        eval(sprintf('cat = floor(pic%d/1000);',ipic));
        if cat == 1
            eval(sprintf('idx = pic%d - 1000;',ipic));
        elseif cat == 2
            eval(sprintf('idx = pic%d - 2000;',ipic));
        else
            eval(sprintf('idx = pic%d - 3000;',ipic));
        end
        if ~isnan(cat)
            eval(sprintf('pics_handle{%d} = pics_cat%d{%d};',ipic,cat,idx));
        end
    end
    present_stimuli;

    %% Cue
    % cue
    Screen('Flip', w);
    WaitSecs(.1);
    if cue == 1 % first pic
        DrawFormattedText(w, 'FIRST', 'center', 'center',[200 200 200]);
    elseif cue == 2 % second pic
        DrawFormattedText(w, 'SECOND', 'center', 'center',[200 200 200]);
    end
    Screen('Flip', w);
    % sendTTL(c.marker.retrocue);
    WaitSecs(t_maint2);

    %% Evaluate response
    % response cue

    Screen('DrawTexture', w, pics_handle{3},[],[center(1)-c.stimSizeW center(2)-c.stimSizeH center(1)+c.stimSizeW center(2)+c.stimSizeH]);
    DrawFormattedText2('<size=80><color=0,0.8,0>NO','win',w,'sx',100,'sy',50);
    DrawFormattedText2('<size=80><color=0.8,0,0>YES','win',w,'sx',rect(3)-300,'sy',50);
    DrawFormattedText(w, '??', 'center', 100,[200 200 200]);

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

    %% Do all necessary things after each trial

    % Save response and trial info to file
    if realexp
        fprintf(ResFileBehav, ['\n' repmat('%1.4f ', [1 c.col.n ])], single(datMat(i_trial,:)));
        save(datMat_file, 'datMat');
    end


    % break? end?
    if i_trial == c.nTrials || i_trial == c.nTrials/2
        % sendTTL(c.marker.break)
        % Give Feedback
        acc = mean(datMat(:,c.col.acc))*100;
        if i_trial~= c.nTrials
            feedback = sprintf('B R E A K ! Correct answers:  %.02f%%',acc);
        else
            feedback = sprintf('Thank you! Correct answers:  %.02f%%',acc);
        end
        present_text(w, feedback , c.key.start, [], c.bgLum, c)
        if i_trial == c.nTrials/2
            present_text(w, 'From now on, please hit GREEN for "NO" and RED for "YES".' , c.key.start, [], c.bgLum, c)
        elseif i_trial == c.nTrials
            % sendTTL(c.marker.expend)
        end
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