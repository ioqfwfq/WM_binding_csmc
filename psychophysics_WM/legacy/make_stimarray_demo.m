function [stimarray, c]= make_stimarray_demo(c)

% define stimuli matrix
%  define colums of the data matrix "datMat"
c.col.trial          = 1;                       %i    running trial index
c.col.rt             = 1 + c.col.trial;         %1.4f reaction time
c.col.acc            = 1 + c.col.rt;            %i    accuracy
c.col.key            = 1 + c.col.acc;           % which key? -1 left, 1 = right
c.col.t_preStim      = 1 + c.col.key;
c.col.t_delay1       = 1 + c.col.t_preStim;
c.col.t_delay2       = 1 + c.col.t_delay1;
c.col.firstCat        = 1 + c.col.t_delay2;          % which Category presented first?
c.col.secondCat       = 1 + c.col.firstCat;          % which Category presented second?
c.col.firstNum        = 1 + c.col.secondCat;          % which number presented first?
c.col.secondNum       = 1 + c.col.firstNum;          % which number presented second?
c.col.firstPic        = 1 + c.col.secondNum;
c.col.secondPic       = 1 + c.col.firstPic;
c.col.probeCat       = 1 + c.col.secondPic;   % cat of probed pic, i = 1-4
c.col.probePic       = 1 + c.col.probeCat;   % i = 1 or 2
c.col.probeValidity  = 1 + c.col.probePic;  % valid probe = 1, nonValid probe = 0;
c.col.probeNum       = 1 + c.col.probeValidity;  % number of the probed pic, i = 1 or 5
c.col.n              = c.col.probeNum;       %     number of columns

%%
% init the stimulus matrix
% c.nTrials = 200;
stimarray = nan(c.nTrials,c.col.n);
stimarray(:,c.col.trial) = 1:c.nTrials;

% pre-stimulus time (fixation), maintenance timing
stimarray(:,c.col.t_preStim) = rand(c.nTrials,1)*c.t_pre_stim_jitter-c.t_pre_stim_jitter/2 + c.t_pre_stim; % 0.8 - 1.2
stimarray(:,c.col.t_delay1) = rand(c.nTrials,1)*c.t_delay1_jitter-c.t_delay1_jitter/2 + c.t_delay1;
stimarray(:,c.col.t_delay2) = rand(c.nTrials,1)*c.t_delay2_jitter-c.t_delay2_jitter/2 + c.t_delay2;

%% store stim infos to stimarray
flag = 1;
while flag % try as long as there is no error (necessary since random selection of pictures might run into selection problems where there is no picture to select from yet)
    try
        % define
        probePic = [zeros(1, c.nTrials/2), ones(1, c.nTrials/2)]+1;
        firstCat = mod(floor((0:(c.nTrials-1))/(c.nTrials/20)), 4) + 1;
        secondCat = nan(1, c.nTrials);
        % Assign secondCat based on firstCat, ensuring no match and equal distribution
        for i = 1:4
            possibleValues = setdiff(1:4, i); % Possible values for secondCat that are not equal to firstCat
            secondCat(firstCat == i) = possibleValues(randi(3,1,sum(firstCat==i)));
        end
        probeValidity = repmat([0 1], 1, c.nTrials/2);
        %shuffle and store
        shuffle_ind = randperm(c.nTrials);
        stimarray(1:c.nTrials,c.col.probePic) = probePic(shuffle_ind);
        stimarray(1:c.nTrials,c.col.firstCat) = firstCat(shuffle_ind);
        stimarray(1:c.nTrials,c.col.secondCat) = secondCat(shuffle_ind);
        stimarray(1:c.nTrials,c.col.probeValidity) = probeValidity(shuffle_ind);

        %% randomly select pictures in each trial
        for i_trial = 1:c.nTrials
            % get specific config in the trial
            probePic   = stimarray(i_trial, c.col.probePic);
            firstCat   = stimarray(i_trial, c.col.firstCat);
            secondCat  = stimarray(i_trial, c.col.secondCat);
            probeValidity = stimarray(i_trial, c.col.probeValidity);

            %pic 1
            allPics1 = firstCat*1000 + (1:20); % 20 candidate
            firstPic = allPics1(randperm(length(allPics1),1));

            %pic 2
if firstPic - firstCat * 1000 <= 10
    range_offset = 10;
    firstNum = 1;
    secondNum = 5;
else
    range_offset = 0;
    firstNum = 5;
    secondNum = 1;
end
availPics2 = secondCat * 1000 + (1:10) + range_offset;
secondPic = availPics2(randperm(length(availPics2), 1));

            % store pics in stimarray
            stimarray(i_trial,c.col.firstPic) = firstPic;
            stimarray(i_trial,c.col.secondPic) = secondPic;
            stimarray(i_trial,c.col.firstNum) = firstNum;
            stimarray(i_trial,c.col.secondNum) = secondNum;

            if probeValidity % valid stim cat
                if probePic == 1
                    probeCat = firstCat;
                    probeNum = firstNum;
                else
                    probeCat = secondCat;
                    probeNum = secondNum;
                end
            else % swap stim cat
                if probePic == 1
                    probeCat = secondCat;
                    probeNum = 0;
                else
                    probeCat = firstCat;
                    probeNum = 0;
                end
            end
            stimarray(i_trial,c.col.probeCat) = probeCat;
            stimarray(i_trial,c.col.probePic) = probePic;
            stimarray(i_trial,c.col.probeNum) = probeNum;
        end
        flag = 0;
    catch
        %keep going
    end
end