function [] = clean_up
% clean up and abort
CedrusResponseBox('CloseAll');
fclose('all');
Screen('CloseAll');
Priority(0);
ListenChar(0);
RestrictKeysForKbCheck([])
disp('++++++++ Experiment aborted by user! ++++++++')
error('Program terminated by user')
end

