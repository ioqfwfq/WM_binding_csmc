%% adapted from SBneural_main. Junda Zhu 202504

%% 
% === Main Working Memory Binding Task Analysis
%
%
% Section 1: Define sessions

% Section 2: Create Database for given analysis mode
%        1 --> all WM binding cells
%% ==== Section 1: Define the sessions
clear;clc;
setpath_CSMC_win_jz
% path below must include the following two sub-directories: sorted and events.

basepathData = 'D:/sandbox';   %path to all patients
basepathResults = 'D:/sandbox';

[sessions] = defineWMBsessions(); % all sessions to be included

%pick which sessions to analyze (based on sessions)
allSessionsToUse = [3];% e.g. 1, 2, 3

%% ==== Section 2: Database for All Cells
%    loops over all sessions and cells

% Set which analysis to run:  
analysisMode = 1;   % 1 WMbinding experiment, gather data; 2 WMbinding exp, plot rasters (exploratory)
% paramsInPreset.onlyChannels = 1;
% paramsInPreset.onlyCells    = [];
% paramsInPreset.onlyAreas    = [];
paramsInPreset.doPlot       = 1;
paramsInPreset.plotAlways   = 1;
paramsInPreset.exportFig = 1;

% main function for analysis
[totStats,cellStatsAll] = WMBneural_loopOverSessions(allSessionsToUse, sessions, basepathData,analysisMode, paramsInPreset );
for i = 1:length(cellStatsAll)
    if istable(cellStatsAll(i).Trials)
        cellStatsAll(i).Trials = table2struct(cellStatsAll(i).Trials);
    end
end
close all;
% totStats Columns: 1) Patient/Session ID (see defineSBsessions), 2)
% Channel, 3) Cell number, 4) Brain Area (see defineUsableClusters_brainAreaOnly.m), 
% 6) Cluster ID 



% Saving cellStatsAll & totStats
switch(analysisMode)
    case 1 % save; construct database
        save(fullfile(basepathResults,'WMB_P108_1_20250511.mat'),'totStats', 'cellStatsAll')
end


%% ==== Section 3: Concept Cells (Sternberg)

% load precomputed if skipping Sections 1+2, otherwise dont run this
% load('e:\workspace_sternberg_Oct5_2022.mat','cellStatsAll' );  
% load('e:\workspace_sternberg_Oct5_2022.mat','totStats' );  



% basepathResults = '\\csclvault\rutishauserulab\LabUsers\sullivansx\Sternberg Data\Main Database\';
% load([basepathResults, 'AllEncode_DataBase']);
load([basepathResults, 'Sternberg_DataBase']);
%pathFig = '\\csclvault\rutishauserulab\LabUsers\sullivansx\Sternberg Data\figures'; % desired path to CC Rasters and PSTH

% pathFig = 'x:\share1\dataRawSternberg\figures'; % desired path to CC Rasters and PSTH


computethis = 'isCC= find(cellStats.Accuracy(:,1)==1);'; % correct trials


[cellStatsAll_Enc] = SB_ConceptCells(cellStatsAll, computethis); %, pathFig);
[cellStatsAll_Enc, totStats_withDOS] = DoS_SB(cellStatsAll_Enc, totStats)

%save([basepathResults,'SBCC_Database.mat'],'totStats', 'cellStatsAll_Enc','-v7.3')

computethat = 'addCC= find([cellStatsAll.isCC]==1);'; % CCs
[All_Areas, CC_Areas, totStats, cellStatsCC] = CCstats_organizedata(basepathResults, totStats, cellStatsAll_Enc, computethat)


%% Section 3.1. testing interacting with the data (ueli - oct 2022)

%how many tuned concept cells?
stats_ofCells=[];
for k=1:length(cellStatsAll_Enc)  
    cellStat_one = cellStatsAll_Enc(k);    
    isTunedCell=0;
    if cellStat_one.p<0.05
        isTunedCell=1;
    end
    
    stats_ofCells(k,:) = [ k isTunedCell cellStat_one.brainAreaOfCell cellStat_one.DoS];
end

indsMTL = find( stats_ofCells(:,3)<=4 );
length(indsMTL)     % # of cells in MTL

indsMTL_tuned = find( stats_ofCells(:,3)<=4 & stats_ofCells(:,2)==1);
length(indsMTL_tuned)

figure(220);
%histogram of DOS
subplot(2,2,1)
hist( stats_ofCells( indsMTL_tuned, 4));
mean(stats_ofCells( indsMTL_tuned, 4))   %mean DOS

% brain area mapping used.  1,2,3,4...  see translateArea.m
%CC_Areas = {'RH','LH','RA','LA','RAC','LAC','RSMA','LSMA','.','.','.','LOFC','ROFC','','','H','A','AC','SMA','OFC'}';



%% ==== Section 4:Grand Average PSTH
BA = [1:4]; % MTL cells     % Brain areas: 1=RH, 2=LH, 3=RA, 4=LA, 5=RAC, 6=LAC, 7=RSMA, 8=LSMA, 12=LOFC, 13=ROFC
DoSmode = 0; % 0=all CCs tested ; 1=only CCs w/ DoS >0.5 tested
% ProbeInOut: 0 = Probe IN, 1 = Probe OUT

% PART A: COPY PROBE PSTH TO CC DATABASE
load('\\csclvault\rutishauserulab\LabUsers\sullivansx\Sternberg Data\Main Database\Probe2_DataBase.mat')
FIELD = {'ProbePSTH'};
[cellStatsCC] = addPSTHtoCCDB(cellStatsAll,cellStatsCC, FIELD)

% --------------------------------------------------------------------- %

% PART B: SET ONE OF THE FOLLOWING CONDITIONS TO BE ANALYZED/PLOTTED
% execute just one condition and move to Part C

%Enc 1 v Probe In
computethis{1}='con1=find(cellStatsCC(spk).Accuracy==1 & selectiveTRIALS );'; % encoding 1
computethis{2}='con2=find(cellStatsCC(spk).Accuracy==1 & cellStatsCC(spk).ProbeInOut(:,1)==0 & selectiveTRIALS & cellStatsCC(spk).ProbePic(:,1)==cellStatsCC(spk).PreferredPic);'; % Probe IN memory, preferred pic as probe
load = [];
DataCompare = 'EvIn';
color = {};

%Enc 1 v Probe Out
computethis{1}='con1=find(cellStatsCC(spk).Accuracy(:,1)==1 & selectiveTRIALS );' % encoding 1
computethis{2}='con2=find(cellStatsCC(spk).Accuracy(:,1)==1 & cellStatsCC(spk).ProbeInOut(:,1)==1 & ~selectiveTRIALS & cellStatsCC(spk).ProbePic(:,1)==cellStatsCC(spk).PreferredPic);'% Probe OUT of memory, preferred pic as probe
load = [];
DataCompare = 'EvOut';
color = {};

%enc 1 vs probe(probe w/ loads separated)
computethis{1}='con1=find(cellStatsCC(spk).Accuracy(:,1)==1 & selectiveTRIALS );'; % encoding 1
computethis{2}='con2=find(cellStatsCC(spk).Accuracy(:,1)==1 & cellStatsCC(spk).ProbeInOut(:,1)==0 & selectiveTRIALS & cellStatsCC(spk).Loads(:,1)==load & cellStatsCC(spk).ProbePic(:,1)==cellStatsCC(spk).PreferredPic);'; % Probe IN memory, preferred pic as probe
% computethis{2}='con2=find(cellStatsCC(spk).Accuracy(:,1)==1 & cellStatsCC(spk).ProbeInOut(:,1)==1 & ~selectiveTRIALS & cellStatsCC(spk).Loads(:,1)==load & cellStatsCC(spk).ProbePic(:,1)==cellStatsCC(spk).PreferredPic);'; % Probe OUT memory, preferred pic as probe
%  computethis{2}='con2=find(cellStatsCC(spk).Accuracy(:,1)==1 & cellStatsCC(spk).Loads(:,1)==load & cellStatsCC(spk).ProbePic(:,1)==cellStatsCC(spk).PreferredPic);'; % Probe IN+OUT memory, preferred pic as probe
load = 1; % CHANGE FOR EACH LOAD 1, 2, 3
color ={'g','b','y'};
DataCompare = 'EvP';


% Probe IN v OUT
computethis{1}='con1=find(cellStatsCC(spk).Accuracy(:,1)==1 & cellStatsCC(spk).ProbeInOut(:,1)==0 & selectiveTRIALS & cellStatsCC(spk).ProbePic(:,1)==cellStatsCC(spk).PreferredPic);'; % Probe IN memory, preferred pic as probe
computethis{2}='con2=find(cellStatsCC(spk).Accuracy(:,1)==1 & cellStatsCC(spk).ProbeInOut(:,1)==1 & ~selectiveTRIALS & cellStatsCC(spk).ProbePic(:,1)==cellStatsCC(spk).PreferredPic);'% Probe OUT of memory, preferred pic as probe
load = [];
DataCompare = 'PInvPOut';
color = {};

% All Encodings
computethis{1}='con1=find(cellStatsCC(spk).Accuracy(:,1)==1 & selectiveTRIALS );'; % encoding 1
computethis{2}='con2=find(cellStatsCC(spk).Accuracy(find(cellStatsCC(spk).Loads==2 | cellStatsCC(spk).Loads==3),1)==1 & selectiveTRIALS2 );'; % encoding 2
computethis{3}='con3=find(cellStatsCC(spk).Accuracy(find(cellStatsCC(spk).Loads==3),1)==1 & selectiveTRIALS3 );'; % encoding 3
load = [];
DataCompare = 'AllEnc';
color = {};
% ------------------------------------------------------------------- %


% PART C: COMPUTING STANDARDIZED PSTHs AND PLOTTING
S = SB_probevsencoding(cellStatsCC, computethis,load, BA, DataCompare)
GrandAvg2 = {S{1},S{2}};
% or if computing all encodings
 S = SB_allencoding(cellStatsCC, computethis, BA)
GrandAvg2 = {S{1},S{2}, S{3}};

plotLPconditions2(GrandAvg2,DoSmode, DataCompare, load, color{load})



%% ==== Section 5: Split Persistent Activity

% PART A: COPY MAINTENANCE PSTH TO CC DATABASE
load('\\csclvault\rutishauserulab\LabUsers\sullivansx\Sternberg Data\Main Database\Maint2_DataBase.mat')
FIELD = {'MaintPSTH', 'MaintRaster'};
[cellStatsCC] = addPSTHtoCCDB(cellStatsAll,cellStatsCC, FIELD)
% ------------------------------------------------------------------- %

% PART B: All Loads Combined
DoSmode = 0;
BA =[1:4];
load = [];    
%computethis: {1} = probe in (for split PA), {2} = probe out
computethis={'tomedian=find(cellStatsCC(spk).Accuracy(:,1)==1 & selectiveTRIALS & cellStatsCC(spk).ProbeInOut(:,1)==0 & cellStatsCC(spk).ProbePic(:,1)==cellStatsCC(spk).PreferredPic);'...
    'forprobeout=find(cellStatsCC(spk).Accuracy(:,1)==1 & ~selectiveTRIALS & cellStatsCC(spk).ProbeInOut(:,1)==1 & cellStatsCC(spk).ProbePic(:,1)==cellStatsCC(spk).PreferredPic);'};
[SPA, GoodTrials, BadTrials]=SBsplitPA(cellStatsCC,load,BA, computethis)
plotLPconditions2(SPA, DoSmode, ['SplitPA ' 'all'], [])

% ------------------------------------------------------------------- %

% PART C: Loads separated
%computethis: {1} = probe in (for split PA), {2} = probe out
computethat={'tomedian=find(cellStatsCC(spk).Accuracy(:,1)==1 &  cellStatsCC(spk).Loads(:,1)==load & selectiveTRIALS & cellStatsCC(spk).ProbeInOut(:,1)==0 & cellStatsCC(spk).ProbePic(:,1)==cellStatsCC(spk).PreferredPic);'...
    'forprobeout=find(cellStatsCC(spk).Accuracy(:,1)==1 &  cellStatsCC(spk).Loads(:,1)==load  & ~selectiveTRIALS & cellStatsCC(spk).ProbeInOut(:,1)==1 & cellStatsCC(spk).ProbePic(:,1)==cellStatsCC(spk).PreferredPic);'};
SPA_combo ={};
for load = 1:3
    [SPA{1,load}, GoodTrialsLoad{1,load}, BadTrialsLoad{1,load}]=SBsplitPA(cellStatsCC,load, BA, computethat)
    plotLPconditions2(SPA{load}, DoSmode, ['SplitPA ' num2str(load)], load)
%     SPA_combo = [SPA_combo;SPA{1,load}]; % combine loads
    GoodTrials2(:,load) = GoodTrialsLoad{1,load}; % trials w/ "Good" persistent activity
    BadTrials2(:,load) = BadTrialsLoad{1,load}; % trials w/ "Bad" persistent activity
end
% for g = 1:3
%     SPA_combo2{g} = cell2mat(SPA_combo(:,g)') % combine loads for plotting
% end
% plotLPconditions2(SPA_combo2, DoSmode, ['SplitPA ' 'all'], [])

% ------------------------------------------------------------------- % 

%% ==== Section 6: Plot deltaFR (probe onset, peak FR) and Plot Depth of Selectivity

% deltaFR btwn Probe onset and Peak after onset beween Good and Bad PA
run FR_zeroVSpeak

% plot DoS for MTL CCs
run DoS_plot

%% ==== Section 7: Latency Effects Analysis - onset latency (ANALYSIS IN PROGRESS)
for i = 1:length(cellStatsCC)
    cellStats = cellStatsCC(i);
%     relevantTrs = find(cellStatsCC.Accuracy(:,1)==1 & cellStats.SBPicOrder(:,1) == cellStats.PreferredPic),:);
    relevantPrPics = cellStats.SBPicOrder(find(cellStats.Accuracy(:,1)==1),1); % probe pics for correct trials
    correctTrs = find(cellStats.Accuracy(:,1)==1); % correct trials
    relevantTrs = find(relevantPrPics == cellStats.PreferredPic); % correct trials in which probe pic was selective pic
    mean_rate = cellStats.PSTHvals(1); % meanFR for Enc1
    rate_thresh = 2;
   
    %lims_analysis = [0 cellStats.periods_Enc1(114,3)+1000]; % timestamp limits
    
    %[first_bursts(i),peakbursts(i),trials(i)] = 
    
    lims_analysis = [1000 2000]; % timestamp limits.    500=stim onset (enc) ;  1000=stimonset (probe)
    
    [first_bursts,peakbursts,trials] = SBburst_latency(cellStats.timestamps,cellStats.periods_Probe(relevantTrs,:),mean_rate,rate_thresh,lims_analysis);
    P_All_Fbursts{i} = first_bursts;
    P_All_Pbursts{i} = peakbursts;
    P_All_trials{i} = trials;

    indsValid = find(first_bursts>0);
    meanPOnset_forCell(i) = mean(first_bursts(indsValid));
    clear indsValid first_bursts relevantPrPics correctTrs relevantTrs mean_rate
    
end

% plotting
% figure
% for i = 1:length(first_bursts)
% plot(first_bursts(i)+200,i+185,'Marker','+','LineWidth',2,'Color','k')
% hold on
% end
% plot(meanPOnset_forCell,i+185,'MarkerFaceColor',[0.494117647409439 0.494117647409439 0.494117647409439],'MarkerSize',8,'Marker','diamond', 'Color', 'k')
% 
% 
% %raster for cell...needs fixing
% RasterToPlot = cellStats.Enc1Raster(:,correctTrs);
% 
% for time = 1:size(RasterToPlot,1)
%     for trials = 1:size(RasterToPlot,2)
%         if RasterToPlot(time,trials) == 1
%             plot(time,ones(1)*trials,'MarkerFaceColor','g','Marker','square','LineStyle','none','MarkerS',4, 'Color', 'g')
%             hold on
%         end
%     end
% end




