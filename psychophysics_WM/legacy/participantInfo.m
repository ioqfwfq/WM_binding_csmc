% ask for patient
c.patientID = input('Patient ID: ','s');
if isempty(c.patientID)
    c.patientID = 'Pxx';
end
% ask for session
thisCheck = 0;
while thisCheck == 0
    c.session = input('Session: ');
    if isempty(c.session)
        c.session = 0;
    end
    if c.session > 0
        thisCheck = 1;
    end
end

%% Now check if file exists and load the rest
c_path = dir(fullfile(c.path.data ,sprintf('%s_session_%d_WM_binding_*_config.mat',c.patientID,c.session)));
datMat_path = dir(fullfile(c.path.data ,sprintf('%s_session_%d_WM_binding_*_datMat.mat',c.patientID,c.session)));
resp_path = dir(fullfile(c.path.data, sprintf('%s_session_%d_WM_binding_*.txt',c.patientID,c.session)));
if size(c_path,1) > 1 || size(resp_path,1) > 1 || size(datMat_path,1) > 1
    error('More than one file for c and/or response! Delete the unwanted first!')
end
if ~isempty(datMat_path)
    datMat_file = fullfile(c.path.data, datMat_path.name);
    load(datMat_file);
    load(fullfile(c.path.data, c_path.name));
    ResFileBehav = fopen(fullfile(c.path.data ,resp_path.name),'a');
    startintrial = sum(~isnan(datMat(:,c.col.rt)))+1;
    fprintf('Patient data exists already. Starting in trial %d...\n',startintrial)
    WaitSecs(2);
else
    % ask for age
    thisCheck = 0;
    while thisCheck == 0
        c.age = input('Age (18-99): ');
        if isempty(c.age)
            c.age = 99;
        end
        if c.age < 100 && c.age > 17
            thisCheck = 1;
        end
    end
    % ask for gender
    c.gender = input('Gender: ', 's');
    % ask for handedness
    c.handedness = input('Handedness (l,r,b): ', 's');
%     % ask for cat1 and cqt2
%     c.category1 = input('Category1: ', 's');
%     c.category2 = input('Category2: ', 's');
    startintrial = 1;
end




