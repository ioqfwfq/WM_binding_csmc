%% read
% Load .mat file
clear
data = load('WMB_P106_1_20250511.mat');

%% struct
for ii = 1:size(data.cellStatsAll,2)
    data.cellStatsAll(ii).Trials = table2struct(data.cellStatsAll(ii).Trials);
end

%% write
% Save it in an older version format, e.g., v7
% data.cellStatsAll = cellStatsAll;
% data.totStats = totStats;
save('WMB_P106_1_20250511_v7.mat', '-struct', 'data', '-v7');
