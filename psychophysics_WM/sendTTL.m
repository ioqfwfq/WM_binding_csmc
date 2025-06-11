
% sends a TTL value

function sendTTL(TTLValue)

if isunix

    global cpod

    if ~isempty(cpod)
        %By default the pulse duration is set to 0, which is "indefinite".
        %You can either set the necessary pulse duration, or simply lower the lines
        %manually when desired.
        setPulseDuration(cpod, 0)

        %mh followed by two bytes of a bitmask is how you raise/lower output lines.
        %Not every XID device supports 16 bits of output, but you need to provide
        %both bytes every time.
        write(cpod,sprintf("mh%c%c", TTLValue, 0), "char")
    end

else

    %32-bit windows, windows XP
    % writeIOw('3BC', TTLValue);

    %64 bit windows, 32bit matlab or 64bit matlab (call correct input_io io32
    %or io64)

    outp(888, TTLValue);

    % outp(49144, TTLValue);

end

end

function byte = getByte(val, index)
byte = bitand(bitshift(val,-8*(index-1)), 255);
end

function setPulseDuration(device, duration)
%mp sets the pulse duration on the XID device. The duration is a four byte
%little-endian integer.
write(device, sprintf("mp%c%c%c%c", getByte(duration,1),...
    getByte(duration,2), getByte(duration,3),...
    getByte(duration,4)), "char")
end