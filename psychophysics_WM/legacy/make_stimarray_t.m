function [datMat, c] = make_stimarray_t(c)
    % make_stimarray_t reads trial info from an Excel file called stim_condition.xlsx
    % and populates the datMat accordingly.
    %
    % It also applies logic to assign probe_cat and probe_num based on probe_validity
    % and which picture is probed.

    %% 1) Read the spreadsheet into a table
    tbl = readtable('stim_conditions.csv');

    %% 2) Determine how many trials are in the spreadsheet
    c.nTrials = height(tbl);

    %% 3) Define the columns of the data matrix "datMat"
    %  The column indexing you define here must match references in your main script.
    c.col.trial           = 1;   % Trial index
    c.col.rt              = 2;   % Reaction time
    c.col.acc             = 3;   % Accuracy
    c.col.key             = 4;   % Key pressed
    c.col.t_pre_stim      = 5;
    c.col.t_delay1        = 6;
    c.col.t_delay2        = 7;
    c.col.first_cat       = 8;   % Category of first item
    c.col.second_cat      = 9;   % Category of second item
    c.col.first_num       = 10;  % Number of first item (optional)
    c.col.second_num      = 11;  % Number of second item (optional)
    c.col.first_pic       = 12;  % Full ID of first item (inc. category in thousands)
    c.col.second_pic      = 13;  % Full ID of second item (inc. category in thousands)
    c.col.probe_cat       = 14;  % Category of the probed item
    c.col.probe_pic       = 15;  % Which picture is probed (1 or 2)
    c.col.probe_validity  = 16;  % Valid (1) or invalid (0)
    c.col.probe_num       = 17;  % Number for the probed item
    c.col.correct_answer  = 18;  % The correct answer from your Excel file

    % Total number of columns
    c.col.n = 18;

    %% 4) Initialize datMat (# of trials x # of columns).
    datMat = nan(c.nTrials, c.col.n);

    %% 5) Loop over each trial in the table, fill in datMat
    for i_trial = 1:c.nTrials
        % Read from the table
        first_cat      = tbl.first_cat(i_trial);
        second_cat     = tbl.second_cat(i_trial);
        probe_pic      = tbl.probe_pic(i_trial);        % 1 or 2
        probe_validity = tbl.probe_validity(i_trial);   % 0 or 1
        correct_ans    = tbl.correct_answer(i_trial);   % e.g. 0, 1, 5, etc.

        % If your table has columns for these numbers, uncomment & use them:
        %  first_num   = tbl.first_num(i_trial);
        %  second_num  = tbl.second_num(i_trial);
        % Otherwise set them here:
        first_num  = 1;  
        second_num = 5;  

        % If your table has columns first_pic_idx, second_pic_idx:
        first_pic_idx  = tbl.first_pic_idx(i_trial);
        second_pic_idx = tbl.second_pic_idx(i_trial);

        % Fill in datMat
        datMat(i_trial, c.col.trial)           = i_trial;
        datMat(i_trial, c.col.first_cat)       = first_cat;
        datMat(i_trial, c.col.second_cat)      = second_cat;
        datMat(i_trial, c.col.first_num)       = first_num;
        datMat(i_trial, c.col.second_num)      = second_num;
        datMat(i_trial, c.col.probe_pic)       = probe_pic;
        datMat(i_trial, c.col.probe_validity)  = probe_validity;
        datMat(i_trial, c.col.correct_answer)  = correct_ans;

        % Combine cat*1000 + pic_idx for your stimulus ID if that's your convention
        datMat(i_trial, c.col.first_pic)  = first_pic_idx  + first_cat  * 1000;
        datMat(i_trial, c.col.second_pic) = second_pic_idx + second_cat * 1000;

        % Logic for valid/invalid probes
        if probe_validity == 1  % valid
            if probe_pic == 1
                datMat(i_trial, c.col.probe_cat) = first_cat;
                datMat(i_trial, c.col.probe_num) = first_num;
            else
                datMat(i_trial, c.col.probe_cat) = second_cat;
                datMat(i_trial, c.col.probe_num) = second_num;
            end
        else  % invalid
            if probe_pic == 1
                datMat(i_trial, c.col.probe_cat) = second_cat;
                datMat(i_trial, c.col.probe_num) = 0;   % or some alternative
            else
                datMat(i_trial, c.col.probe_cat) = first_cat;
                datMat(i_trial, c.col.probe_num) = 0;
            end
        end
    end

    % datMat now contains all info for c.nTrials
end
