function present_stimuli_win(w,c,fix_coord,fix_color,pics_handle,center)
% ver. 202412. Junda Zhu
% for WM_binding task.

% present fixation dot
Screen('FillOval', w, fix_color, fix_coord);
Screen('Flip', w);
% sendTTL(c.marker.fixOnset);
WaitSecs(c.t_pre_stim);

% first pic
Screen('DrawTexture', w, pics_handle{1},[],[center(1)-c.stimSizeW center(2)-c.stimSizeH center(1)+c.stimSizeW center(2)+c.stimSizeH]);
Screen('Flip', w);
% sendTTL(c.marker.pic1);
WaitSecs(c.t_stim);

if size(pics_handle,2) == 2

% delay 1
DrawFormattedText(w, 'HOLD', 'center', 'center',[200 200 200]);
Screen('Flip', w);
% sendTTL(c.marker.delay1);
WaitSecs(c.t_delay1);


% % second pic
Screen('DrawTexture', w, pics_handle{2},[],[center(1)-c.stimSizeW center(2)-c.stimSizeH center(1)+c.stimSizeW center(2)+c.stimSizeH]);
Screen('Flip', w);
% sendTTL(c.marker.pic2);
WaitSecs(c.t_stim);
end

% delay 2
DrawFormattedText(w, 'HOLD', 'center', 'center',[200 200 200]);
Screen('Flip', w);
% sendTTL(c.marker.delay2);
WaitSecs(c.t_delay2);


if c.is_cedrus_box
    CedrusResponseBox('FlushEvents', c.cedrus_handle);
else
    FlushEvents
end