%% Evaluate pressed key for visual response
datMat(i_trial, c.col.rt) = secs - t0;

if i_trial > c.nTrials/2 % 2nd half of experiment
    switch ch
        case c.key.bottom       %  abort experiment
            clean_up;
        case c.key.left
            datMat(i_trial, c.col.key) = 5 ;
        case c.key.right
            datMat(i_trial, c.col.key) = 1;
        case c.key.top
            datMat(i_trial, c.col.key) = 0;
        otherwise
            datMat(i_trial, c.col.key) = nan;
    end
else % 1st half of experiment
    switch ch
        case c.key.bottom       %  abort experiment
            clean_up;
        case c.key.left
            datMat(i_trial, c.col.key) = 0 ;
        case c.key.right
            datMat(i_trial, c.col.key) = 5;
        case c.key.top
            datMat(i_trial, c.col.key) = 1;
        otherwise
            datMat(i_trial, c.col.key) = nan;
    end
end

datMat(i_trial, c.col.acc) = datMat(i_trial, c.col.key) == datMat(i_trial, c.col.probeNum);






