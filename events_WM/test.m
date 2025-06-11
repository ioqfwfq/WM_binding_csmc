scriptName = mfilename;
if isempty(scriptName)
    scriptName = 'task';
end
hostname = getenv('COMPUTERNAME');
startTimestamp = datetime('now','Format','MM/dd/uuuu HH:mm:ss');

url = 'https://hooks.slack.com/services/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';

% Slack message
startMessage = sprintf('🚀 MATLAB script *%s* started on *%s* at %s', ...
    scriptName, hostname, startTimestamp);

% Send to Slack
payload = struct('text', startMessage);
options = weboptions('MediaType','application/json');
try
    webwrite(url, payload, options);
catch ME
    % warning('Slack start message failed: %s', ME.message);
end

hostname = getenv('COMPUTERNAME');  % Windows environment variable
scriptName = mfilename;
timestamp = datetime('now','Format','MM/dd/uuuu HH:mm:ss');
message = sprintf('✅ MATLAB script *%s* finished on *%s* at %s', ...
    scriptName, hostname, timestamp);

url = 'https://hooks.slack.com/services/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';
payload = struct('text', message);
options = weboptions('MediaType','application/json');
try
    webwrite(url, payload, options);
catch ME
    % warning('Slack message failed: %s', ME.message);
end