
function testCpod
% tests CPod connection and sends an array of TTLs if found
% JD 2022

clear cpod device

availports = serialportlist;

ports = struct;

for p = 1:length(availports)
    device = serialport(availports(p),115200,"Timeout",1);
    %In order to identify an XID device, you need to send it "_c1", to
    %which it will respond with "_xid" followed by a protocol value. 0 is
    %"XID", and we will not be covering other protocols.
    device.flush()
    write(device,"_c1","char")
    query_return = read(device,5,"char");
    if length(query_return) > 0 && query_return == "_xid0"
        write(device,"_d3","char") % determines the model number
        model = read(device,1,"char");
        if strcmp(model,'P')
            ports.cpod = availports(p);
        end
    end
end
clear device

if isfield(ports,'cpod')
    disp('Cpod found!')
    cpod = serialport(ports.cpod,115200,"Timeout",1);


    % tests the cpod connection and sends a bunch of TTLs for testing

    %By default the pulse duration is set to 0, which is "indefinite".
    %You can either set the necessary pulse duration, or simply lower the lines
    %manually when desired.
    setPulseDuration(cpod, 0)
    maxTTL = 255;
    lastsize = 0;
    for TTLValue = 1:maxTTL
        fprintf(repmat('\b',1,lastsize));
        lastsize = fprintf('Sending TTL %d of %d\n',TTLValue,maxTTL);
        write(cpod,sprintf("mh%c%c", TTLValue,0), "char")
        pause(0.1)
    end
    clear cpod
else
    disp('Cpod not found. Check connection and run again.')
end
clear all
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