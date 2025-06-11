function [stimarray, c]= make_stimarray(c)
%  define stimuli matrix
%  define colums of the data matrix "datMat"
c.col.trial          = 1;                       %i    running trial index
c.col.rt             = 1 + c.col.trial;         %1.4f reaction time
c.col.acc            = 1 + c.col.rt;            %i
c.col.key            = 1 + c.col.acc;           %
c.col.t_pre_stim      = 1 + c.col.key;
c.col.t_delay1       = 1 + c.col.t_pre_stim;
c.col.t_delay2       = 1 + c.col.t_delay1;
c.col.first_cat        = 1 + c.col.t_delay2;          % which Category presented first?
c.col.second_cat       = 1 + c.col.first_cat;          % which Category presented second?
c.col.first_num        = 1 + c.col.second_cat;          % which number presented first?
c.col.second_num       = 1 + c.col.first_num;          % which number presented second?
c.col.first_pic        = 1 + c.col.second_num;
c.col.second_pic       = 1 + c.col.first_pic;
c.col.probe_cat       = 1 + c.col.second_pic;   % cat of probed pic, i = 1-4
c.col.probe_pic       = 1 + c.col.probe_cat;   % i = 1 or 2
c.col.probe_validity  = 1 + c.col.probe_pic;  % valid probe = 1, nonValid probe = 0;
c.col.probe_num       = 1 + c.col.probe_validity;  % number of the probed pic, i = 1 or 5
c.col.n              = c.col.probe_num;       %     number of columns

%%
% init the stimulus matrix
% c.nTrials = 200;
stimarray = nan(c.nTrials,c.col.n);
stimarray(:,c.col.trial) = 1:c.nTrials;

% pre-stimulus time (fixation), maintenance timing
stimarray(:,c.col.t_pre_stim) = rand(c.nTrials,1)*c.t_pre_stim_jitter-c.t_pre_stim_jitter/2 + c.t_pre_stim; % 0.8 - 1.2
stimarray(:,c.col.t_delay1) = rand(c.nTrials,1)*c.t_delay1_jitter-c.t_delay1_jitter/2 + c.t_delay1;
stimarray(:,c.col.t_delay2) = rand(c.nTrials,1)*c.t_delay2_jitter-c.t_delay2_jitter/2 + c.t_delay2;

%% store stim info to stimarray
flag = 1;
while flag % try as long as there is no error (necessary since random selection of pictures might run into selection problems where there is no picture to select from yet)
    try
        % define
        probe_pic = [zeros(1, c.nTrials/2), ones(1, c.nTrials/2)]+1;
        first_cat = mod(floor((0:(c.nTrials-1))/(c.nTrials/20)), 4) + 1;
        second_cat = nan(1, c.nTrials);
        % Assign second_cat based on first_cat
        for i = 1:4
            possible_cat = setdiff(1:4, i); % Possible values for secondCat that are not equal to firstCat
            second_cat(first_cat == i) = possible_cat(randi(3,1,sum(first_cat==i)));
        end
        probe_validity = repmat([0 1], 1, c.nTrials/2);
        %shuffle and store
        shuffle_ind = randperm(c.nTrials);
        stimarray(1:c.nTrials,c.col.probe_pic) = probe_pic(shuffle_ind);
        stimarray(1:c.nTrials,c.col.first_cat) = first_cat(shuffle_ind);
        stimarray(1:c.nTrials,c.col.second_cat) = second_cat(shuffle_ind);
        stimarray(1:c.nTrials,c.col.probe_validity) = probe_validity(shuffle_ind);

        %% randomly select pictures in each trial
        for i_trial = 1:c.nTrials
            % get specific config in the trial
            probe_pic   = stimarray(i_trial, c.col.probe_pic);
            first_cat   = stimarray(i_trial, c.col.first_cat);
            second_cat  = stimarray(i_trial, c.col.second_cat);
            probe_validity = stimarray(i_trial, c.col.probe_validity);

            %pic 1
            all_pic1 = first_cat*1000 + (1:20); % 20 candidate
            first_pic = all_pic1(randperm(length(all_pic1),1));

            %pic 2
if first_pic - first_cat * 1000 <= 10
    range_offset = 10;
    first_num = 1;
    second_num = 5;
else
    range_offset = 0;
    first_num = 5;
    second_num = 1;
end
avail_pic2 = second_cat * 1000 + (1:10) + range_offset;
second_pic = avail_pic2(randperm(length(avail_pic2), 1));

            % store pics in stimarray
            stimarray(i_trial,c.col.first_pic) = first_pic;
            stimarray(i_trial,c.col.second_pic) = second_pic;
            stimarray(i_trial,c.col.first_num) = first_num;
            stimarray(i_trial,c.col.second_num) = second_num;

            if probe_validity % valid stim cat
                if probe_pic == 1
                    probe_cat = first_cat;
                    probe_num = first_num;
                else
                    probe_cat = second_cat;
                    probe_num = second_num;
                end
            else % swap stim cat
                if probe_pic == 1
                    probe_cat = second_cat;
                    probe_num = 0;
                else
                    probe_cat = first_cat;
                    probe_num = 0;
                end
            end
            stimarray(i_trial,c.col.probe_cat) = probe_cat;
            stimarray(i_trial,c.col.probe_pic) = probe_pic;
            stimarray(i_trial,c.col.probe_num) = probe_num;
        end
        flag = 0;
    catch
        %keep going
    end
end