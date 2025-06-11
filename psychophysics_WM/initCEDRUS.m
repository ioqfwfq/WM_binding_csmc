function handle = initCEDRUS
% this initiaizes the Cedrus devices and returns a handle for the Response box. 
% It's necessary to do this for all Cedrus devices since Cpod and
% CedrusResponseBoxes are initallized the same way and therefore difficult
% to differentiate solely by the port name

% JD 2022

%An exhaustive list of all commands written to the serial port in this
%example see https://cedrus.com/support/xid/commands.htm
clear global
clear device

availports = serialportlist;

for p = 1:length(availports)
    device = serialport(availports(p),115200,"Timeout",2);
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
        else
            ports.rbox = availports(p);
        end
    end
end
clear device

handle = CedrusResponseBox('Open', char(ports.rbox));

if isfield(ports,'cpod')
    global cpod
    cpod = serialport(ports.cpod,115200,"Timeout",1);
end


