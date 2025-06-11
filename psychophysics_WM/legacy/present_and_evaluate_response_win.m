function datMat = present_and_evaluate_response_win(w, rect, c, datMat, options,probe_text,i_trial)
% ver. 202412. Junda Zhu
%% present instruction text
[~,~,~,~,~] = DrawFormattedText2(probe_text, ...
                'win',w,'sx','center','sy','center','xalign','center','yalign','center','baseColor',[0,0,0]);
%% present response options
[scrX,scrY] = RectCenter(rect);
options_color = [{'0,0.8,0'};{'0,0,0.8'};{'0.8,0,0'}];
if i_trial <= c.nTrials/2 % 1st half of experiment
    options_loc = [scrX-500,scrY;scrX,scrY-300;scrX+500,scrY];
else
    options_loc = [scrX,scrY-300;scrX+500,scrY;scrX-500,scrY];
end

for io = 1:size(options,1)
    option_text = sprintf('<size=150><color=%s><b>%s',options_color{io}, options{io});
    DrawFormattedText2(option_text,'win',w, ...
        'sx',options_loc(io,1),'sy',options_loc(io,2), ...
        'xalign','center','yalign','center','baseColor',[0 0 0]);
end
t0 = Screen('Flip', w);
%% evaluate
if c.is_cedrus_box
    evt = CedrusResponseBox('WaitButtonPress', c.cedrus_handle);
    ch = num2str(evt.button);
    secs = evt.ptbfetchtime;
else
    [ch, when] = GetChar();
    secs = when.secs;
end
if i_trial <= c.nTrials/2 % 1st half of experiment
    switch ch
        case c.key.bottom       %  abort experiment
            clean_up;
        case c.key.left
            datMat(i_trial, c.col.key) = 0;
        case c.key.right
            datMat(i_trial, c.col.key) = 5;
        case c.key.top
            datMat(i_trial, c.col.key) = 1;
        otherwise
            datMat(i_trial, c.col.key) = nan;
    end
else
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
end
% sendTTL(c.marker.response)
datMat(i_trial, c.col.rt) = secs - t0;
datMat(i_trial, c.col.acc) = datMat(i_trial, c.col.key) == datMat(i_trial, c.col.probe_num);






