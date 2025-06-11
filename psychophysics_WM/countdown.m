function [] = countdown(w, c)
% countdown
for ii =  fliplr(1:c.countdown.num)
    myText = num2str(ii);
    if c.bg_lum == 255
        DrawFormattedText(w, myText, 'center', 'center',0);
    elseif c.bg_lum == 0
        DrawFormattedText(w, myText, 'center', 'center',255);
    else
        DrawFormattedText(w, myText, 'center', 'center',[200 200 200]);
    end
    Screen('Flip',w);
    WaitSecs(c.countdown.t1);
    Screen('Flip', w);
    WaitSecs(c.countdown.t2);
end
end

