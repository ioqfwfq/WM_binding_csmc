%% show response

positions = [-center(1)*3/4 -center(1)/4 center(1)/4 center(1)*3/4];
Screen('FillRect', w, 255,[center(1)+positions(str2double(ch))-c.rectSizeW center(2)-c.rectSizeH center(1)+positions(str2double(ch))+c.rectSizeW center(2)+c.rectSizeH]);
Screen('DrawTexture', w, pics_handle{3},[],[center(1)-center(1)*3/4-c.stimSizeW center(2)-c.stimSizeH center(1)-center(1)*3/4+c.stimSizeW center(2)+c.stimSizeH]);
Screen('DrawTexture', w, pics_handle{4},[],[center(1)-center(1)/4-c.stimSizeW center(2)-c.stimSizeH center(1)-center(1)/4+c.stimSizeW center(2)+c.stimSizeH]);
Screen('DrawTexture', w, pics_handle{5},[],[center(1)+center(1)/4-c.stimSizeW center(2)-c.stimSizeH center(1)+center(1)/4+c.stimSizeW center(2)+c.stimSizeH]);
Screen('DrawTexture', w, pics_handle{6},[],[center(1)+center(1)*3/4-c.stimSizeW center(2)-c.stimSizeH center(1)+center(1)*3/4+c.stimSizeW center(2)+c.stimSizeH]);

t1 = Screen('Flip', w);
WaitSecs(0.2);

Screen('DrawTexture', w, pics_handle{3},[],[center(1)-center(1)*3/4-c.stimSizeW center(2)-c.stimSizeH center(1)-center(1)*3/4+c.stimSizeW center(2)+c.stimSizeH]);
Screen('DrawTexture', w, pics_handle{4},[],[center(1)-center(1)/4-c.stimSizeW center(2)-c.stimSizeH center(1)-center(1)/4+c.stimSizeW center(2)+c.stimSizeH]);
Screen('DrawTexture', w, pics_handle{5},[],[center(1)+center(1)/4-c.stimSizeW center(2)-c.stimSizeH center(1)+center(1)/4+c.stimSizeW center(2)+c.stimSizeH]);
Screen('DrawTexture', w, pics_handle{6},[],[center(1)+center(1)*3/4-c.stimSizeW center(2)-c.stimSizeH center(1)+center(1)*3/4+c.stimSizeW center(2)+c.stimSizeH]);

Screen('Flip', w);

if ~cue
    %% Evaluate response 2
    
    clear ch when
    if c.CedrusBox
        evt = CedrusResponseBox('WaitButtonPress', c.cedrus_handle);
        ch = num2str(evt.button);
        secs = evt.ptbfetchtime;
    else
        [ch, when] = GetChar();
        secs = when.secs;
    end
    sendTTL(c.marker.response2)
    if strcmp(ch, c.key.break)       %  abort experiment
        clean_up;
    else
        datMat(i_trial, c.col.rt2) = secs - t1;
        datMat(i_trial, c.col.key2) = str2double(ch);
        datMat(i_trial, c.col.acc2) = str2double(ch) == match_position2;
    end
    Screen('FillRect', w, 255,[center(1)+positions(str2double(ch))-c.rectSizeW center(2)-c.rectSizeH center(1)+positions(str2double(ch))+c.rectSizeW center(2)+c.rectSizeH]);
    Screen('DrawTexture', w, pics_handle{3},[],[center(1)-center(1)*3/4-c.stimSizeW center(2)-c.stimSizeH center(1)-center(1)*3/4+c.stimSizeW center(2)+c.stimSizeH]);
    Screen('DrawTexture', w, pics_handle{4},[],[center(1)-center(1)/4-c.stimSizeW center(2)-c.stimSizeH center(1)-center(1)/4+c.stimSizeW center(2)+c.stimSizeH]);
    Screen('DrawTexture', w, pics_handle{5},[],[center(1)+center(1)/4-c.stimSizeW center(2)-c.stimSizeH center(1)+center(1)/4+c.stimSizeW center(2)+c.stimSizeH]);
    Screen('DrawTexture', w, pics_handle{6},[],[center(1)+center(1)*3/4-c.stimSizeW center(2)-c.stimSizeH center(1)+center(1)*3/4+c.stimSizeW center(2)+c.stimSizeH]);
    
    Screen('Flip', w);
    WaitSecs(0.2);
else
    WaitSecs(0.2);
end