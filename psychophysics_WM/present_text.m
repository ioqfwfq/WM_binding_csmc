function present_text(w, this_text, next_key, t_present, c)
% ver. 202412. Junda Zhu

if c.is_cedrus_box
    CedrusResponseBox('FlushEvents', c.cedrus_handle);
else
    FlushEvents
end
    text_to_draw = sprintf('<color=1.0,1.0,1.0>%s<color>', this_text);

[~,~,~,~,~] = DrawFormattedText2(text_to_draw, ...
    'win',w,'sx','center','sy','center','xalign','center','yalign','center','baseColor',[0 0 0]);

Screen('Flip',w);

if isempty(next_key)
    if isempty(t_present)
    else
        WaitSecs(t_present);
    end
else    % wait for "next" key
    while 1
        if c.is_cedrus_box
            evt = CedrusResponseBox('WaitButtonPress', c.cedrus_handle);
            ch = num2str(evt.button);
        else
            ch = GetChar();
        end
        if isequal(next_key, ch)
            break
        elseif isequal(c.key.bottom, ch)
            clean_up;
        end
    end
end
