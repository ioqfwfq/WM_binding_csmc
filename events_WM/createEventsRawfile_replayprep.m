%
% Script to create eventsRaw.mat for replay  (April 05/23/17)
%
%
% Update Logging/times (Nand 07/2018)

%% creates events variable with time labels
% read timestamps from events file
basepath='\\smb.researchcampus.csmc.edu\rutishauserulab-data\dataRawEpilepsy\P108CS\20250425_WM_binding\';
loadpath=[basepath 'raw\Events.nev'];
savepath_mat=[basepath 'eventsRaw.mat'];
savepath_txt=[basepath 'timestampsInclude.txt'];
events = getRawTTLs(loadpath);

%% locates time points at which the experiment starts and stops  

start = [find(events(:,2)==89)]

if length(start) == 1 
    disp('There are one: 89')
else 
    error('Incorrect TTLs: 89')
end 

stop = [find(events(:,2)==90)]

if length(stop) == 1
    disp('There are one: 90')
else 
    error('Incorrect TTls: 90')
end 
    
    
%% labels the exp phases and saves variable as eventsRaw.mat for replay

expstart = start(1,1); %Start 
expend = stop(end,1); %End

events(expstart:expend,3)=1;

%% Save Events file to desired folder 

% save('Z:\dataRawEpilepsy\P80CS\20220727_JonathanNO\NO_training\var3\eventsRaw.mat', 'events')
save([basepath 'eventsRaw.mat'], 'events')

%% Check times

%Start of exp
startTIME = events(expstart, 1);
%End of exp
endTIME = events(expend, 1);

%Total exp time (min)
timeLearning = endTIME - startTIME;
total_time = (timeLearning.*10.^-6)./(60)


