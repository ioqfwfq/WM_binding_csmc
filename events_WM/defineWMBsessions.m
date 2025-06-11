% Defines all sessions available for Wm binding task.
%    Add each new patient/session to this set
%
% JZhu 202505
function [sessions] = defineWMBsessions()

sessions = table('Size', [0 2], 'VariableTypes', {'string','string'}, 'VariableNames', {'sessionID','taskDescr'});


% P106CS
c=1;
sessions(c,:) = {"P106CS", "WMbinding"};

% P107CS
c = height(sessions) + 1;
sessions(c,:) = {"P107CS", "WMbinding"};

% P108CS
c = height(sessions) + 1;
sessions(c,:) = {"P108CS", "WMbinding"};

% P108CS var2
c = height(sessions) + 1;
sessions(c,:) = {"P108CS_1", "WMbinding"};