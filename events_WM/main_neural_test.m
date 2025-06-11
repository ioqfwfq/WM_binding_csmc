%%main_SternbergStandard_neural.m
%
% Demonstrates how to analyze the sternberg standard dataset used in 
% Kaminski et al. 2017 (Nat Neurosci) and Kaminski et al. 2020 (Neuron).
%
% This is a simplified version of SBneural_main.m, originally written by Shannon Sullivan
%
% Oct 2022, urut

% Before running this, make sure to add to path:
% - events/Sternberg/SullivanAnalysis_SBeffect
% - 3rdParty/Violinplot

%%
clear;clc;
% basepathData_sternberg = ['Y:\share1\dataRawSternberg'];   %path to all patients (STERNBERG)
% basepathData_screening = ['Y:\share1\dataRawSternberg\SCREENING'];   %path to all patients (SCREENING)
basepathData_sternberg = 'Z:\LabUsers\kyzarm\data\NWB_SB\data_Native\STERNBERG';
basepathData_screening = 'Z:\LabUsers\kyzarm\data\NWB_SB\data_Native\SCREENING';

saveResults = 1; basepathResults = 'Z:\LabUsers\kyzarm\data\NWB_SB\data_Native\Summary Databases\';
loadResults = 0;

% [SBsessions] = defineSBsessions(); % all Sternberg sessions to be included
SBsessions = defineSBsessionsNWB();
SBsessionsScreening = defineSBsessionsNWB('SCREENING');

%pick which sessions to analyze (based on SBsessions)
allSessionsToUse_Sternberg = 1:21; 
% allSessionsToUse_Sternberg = [6:10]; % only list here the sessions for which screening was already processed.   still have to be processed: [1:5 19 20]
% allSessionsToUse_Sternberg = [];
% allSessionsToUse_Screening = 6:18; % For the test set, screening sessions overlap perfectly with sternberg sessions
allSessionsToUse_Screening = 1:20;

%% prepare the data (load all cells), for sternberg task
paramsInPreset=[];

analysisModes = [];
%== Sternberg
% analysisMode = 0; analysisModes(end+1) = analysisMode;   % -1 screening, gather data; 0 sternberg experiment, gather data;   1 sternberg exp, plot rasters (exploratory)
% [totStats_sternberg, cellStatsAll_sternberg] = SBneural_loopOverSessions(allSessionsToUse_Sternberg, SBsessions, basepathData_sternberg, analysisMode, paramsInPreset );
%== Screening
analysisMode = -1; analysisModes(end+1) = analysisMode;  % -1 screening, gather data; 0 sternberg experiment, gather data;   1 sternberg exp, plot rasters (exploratory)
[totStats_screening, cellStatsAll_screening] = SBneural_loopOverSessions(allSessionsToUse_Screening, SBsessionsScreening, basepathData_screening, analysisMode, paramsInPreset );

%== Saving cellStatsAll & totStats
if saveResults % This loop is able to save results even if you comment out one of the analysis modes. 
    for mode = analysisModes
        switch(mode)
            case -1
                statSuffix = '_screening';
            case 0
                statSuffix = '_sternberg';
        end
        save([basepathResults,['database' statSuffix '.mat']],['totStats' statSuffix], ['cellStatsAll' statSuffix],'-v7.3')
    end
end

%% assess selectivity during sternberg task
% go through all cells and assess selectivity for each; plot example rasters for cells

allStats = [];

indsToUse = 1:length(cellStatsAll_sternberg);  % all cells

%indsToUse = [-];  % a few example cells good for testing
%indsToUse = [547];  % a few example cells good for testing
for k=1:length(indsToUse)
    
    cellStats_one = cellStatsAll_sternberg( indsToUse(k) );
    
    figNr=k;
    plabel='';

    paramsIn = copyStructFields(cellStats_one, []);  
    paramsIn.pannelNr=k;
    paramsIn.nrProcessed=0;
    paramsIn.doPlot = 1;   % set =0 to turn off plotting
    paramsIn.plotAlways = 1;
    paramsIn.exportFig=1;   % 1-> export to file and then close
    paramsIn.exportPath = 'D:\sandbox\figsSternberg\';
    
    paramsOut = SB_singleCellAnalysis_plotRasters(cellStats_one.timestamps, figNr, cellStats_one.brainAreaOfCell, plabel, paramsIn );

    allStats(k,:) = paramsOut.allStats;
end

%% plot population summary (sternberg)
% How many tuned concept cells in MTL ?
indsTuned_enc1 = find( allStats(:,8)<=0.05 & allStats(:,9)<=0.05  ); % all tuned cells in enc1
indsMTL = find(  allStats(:,3)<=4 );   % all cells recorded in MTL
indsTuned_MTL = intersect( indsTuned_enc1, indsMTL );
propTuned = length(indsTuned_MTL) / length(indsMTL)
DOSvals = allStats(indsTuned_MTL, 10);

PSIvals_load1 = allStats(indsTuned_MTL, 11);

figure(220);
%histogram of DOS
subplot(2,2,1)
%hist( DOSvals );
violinplot(DOSvals);
title(['Sternberg; mDOS=' num2str(mean(DOSvals)) ' propTuned=' num2str(propTuned)]);

subplot(2,2,2)
%hist( PSIvals_load1)
title(['PIS m=' num2str(mean(PSIvals_load1))]);

vs = violinplot(PSIvals_load1); %, Origin);

%% assess selectivity during screening task
allStats_screening = [];
indsToUse = 1:length(cellStatsAll_screening);  % all cells
for k=1:length(indsToUse)    
    cellStats_one = cellStatsAll_screening( indsToUse(k) );
    
    figNr=k;
    plabel='';

    paramsIn = copyStructFields(cellStats_one, []);  
    paramsIn.pannelNr=k;
    paramsIn.nrProcessed=0;
    paramsIn.doPlot = 1;   % set =0 to turn off plotting
    paramsIn.plotAlways = 0;
    paramsIn.exportFig=0;   % 1-> export to file and then close
    
    paramsOut = SB_singleCellAnalysis_Screening_plotRasters(cellStats_one.timestamps, figNr, cellStats_one.brainAreaOfCell, plabel, paramsIn );

    allStats_screening(k,:) = paramsOut.allStats;
end

%% plot population summary (screening)

% How many tuned concept cells in MTL ?
indsTuned_screen = find( allStats_screening(:,7)<=0.05   ); % all tuned cells in enc1
indsMTL_screen = find(  allStats_screening(:,3)<=4 );   % all cells recorded in MTL
indsTuned_MTL = intersect( indsTuned_screen, indsMTL_screen );
propTuned = length(indsTuned_MTL) / length(indsMTL_screen)
DOSvals = allStats_screening(indsTuned_MTL, 8);

figure(221);
%histogram of DOS
subplot(2,2,1)
hist( DOSvals );
title(['Screening; mDOS=' num2str(mean(DOSvals)) ' propTuned=' num2str(propTuned)]);
