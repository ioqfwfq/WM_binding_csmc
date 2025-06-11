%
% This cell is a callback function for runForAllCellsInSession.m
%
% NOTE: It appears that this script detects cells that are both concept and
% maintenance cells and plots a Raster & PSTH for Enc1-3 + Maint + Probe.
function [params] = WMB_singleCellAnalysis_plotRasters(timestampsOfCell, figNr, brainAreaOfCell, plabel, params, varargin )

params.nrProcessed = params.nrProcessed+1;
stimOnset = params.prestimEnc;   % time before stim onset (baseline)
maintOnset = params.prestimMaint;   % time before maint onset in periods
probeOnset = params.prestimProbe;

alphaLim=0.05;

disp(['Processing ID:' params.sessionID ' Cell#:' num2str(params.origClusterID) ]);

%% assess selectivity

PicOrder_Enc1 = int8(params.SBPicOrder(:,1));   %  Enc1 trials, which image was shown
PicOrder_Enc2 = int8(params.SBPicOrder(:,2));   %  Enc2 trials, which image was shown
PicOrder_Enc3 = int8(params.SBPicOrder(:,3));   %  Enc3 trials, which image was shown

PicOrder_Probe = int8(params.ProbePic(:,1));   %  Probe, which image was shown

normalizeCounts = 1;
countStimulus_Enc1 = extractPeriodCountsSimple( timestampsOfCell, params.periods_Enc1, stimOnset+.2, stimOnset+1, normalizeCounts );
countStimulus_Maint = extractPeriodCountsSimple( timestampsOfCell, params.periods_Maint, maintOnset, maintOnset+2.5, normalizeCounts );

countStimulus_Baseline = extractPeriodCountsSimple( timestampsOfCell, params.periods_Enc1, 0, .5, normalizeCounts );

% ANOVA across Enc1 trials with image identity as a factor. 
DVs = string(PicOrder_Enc1);
[pANOVA,~,~] = anovan( countStimulus_Enc1, {DVs},'alpha',alphaLim,'display','off', 'model', 'linear', 'varnames','picID');

isTunedCell=0;
DOS=nan; % Depth of Selectivity
pANOVA2=nan;
PSI=[nan nan nan];
pANOVA_maint = nan;

% Second verification stage: check if max response is significant with
% respect to each of the stimuli. 
% fprintf('pANOVA: %f\n',pANOVA)
% if pANOVA < alphaLim
   %check if max sig vs rest
   nUniqueStim = 5;
   mResp=nan(nUniqueStim,1);
   for k=1:nUniqueStim
      mResp(k) = mean(countStimulus_Enc1( find(  PicOrder_Enc1==k ) ));
   end
   
   [indMax] = find( mResp == max(mResp),1);   
   PicOrder_Enc1_maxOnly = PicOrder_Enc1;    
   PicOrder_Enc1_maxOnly(PicOrder_Enc1~=indMax) = -1;   % binarize, max is kept and all others are =-1
   

   % see if sig different
    [pANOVA2,~,~] = anovan( countStimulus_Enc1, {string(PicOrder_Enc1_maxOnly)},'alpha',alphaLim,'display','off', 'model', 'linear');
    % if pANOVA2<0.05
        
        isTunedCell = 1;        
        prefCat = indMax;
        
        indsPref = find(PicOrder_Enc1_maxOnly>0);
        indsNonPref = find(PicOrder_Enc1_maxOnly==-1);
        
        nrCategories = 5;        
        meanFR=[];
        for kk=1:nrCategories
            meanFR(kk) = mean( countStimulus_Enc1(find(PicOrder_Enc1==kk)));
        end
                            
        %== this cell is tuned, calculate metrics        
        DOS = (nrCategories - sum(meanFR./max(meanFR))) / (nrCategories-1); % Depth of Selectivity calculation

        % test if same difference applicable during maintenance
        [pANOVA_maint] = anovan( countStimulus_Maint, {string(PicOrder_Enc1_maxOnly)},'alpha',alphaLim,'display','off', 'model', 'linear');              
        
        %== assess tuning using picture selectivity index (PSI) -- during maintenance
        mBaseline = mean(countStimulus_Baseline);

        for loadID=1:1   % only implemented for load1 for now
        
            mResp_Pref = mean(countStimulus_Maint(find(PicOrder_Enc1==prefCat & params.Loads==loadID)));
            mResp_NonPref = mean(countStimulus_Maint(find(PicOrder_Enc1~=prefCat & params.Loads==loadID )));
        
        
            PSI(loadID) = ((mResp_Pref - mResp_NonPref)/mBaseline) * 100;
        end
        
    % end   
% end

%% plot raster

HzGlobal = length(timestampsOfCell)/(max(timestampsOfCell) - min(timestampsOfCell));

% fprintf('pANOVA_maint: %f\n',pANOVA_maint)
if (isTunedCell && params.doPlot &&  pANOVA_maint<0.05 && params.doPlot) || params.plotAlways
%     figNr=params.pannelNr + params.SBind*100;
    figure( figNr );
    normalize=0;
    
    plabelStr = ['SBID: ' params.sessionID ' BA: ' num2str(params.brainAreaOfCell) ' Cl:' num2str(params.origClusterID) ' p1=' num2str(pANOVA) ' p2=' num2str(pANOVA2) ' pM=' num2str(pANOVA_maint)];
    
    %% === Raster plots
    spikePlotParams=[];
    spikePlotParams.colors1 = {[1.0 0 0],[1.0 0.8 0.6], [0.2 0.8 1.0],[0 0 1]};   % splitup into 4
    spikePlotParams.spikewidth  = 1.5;
    spikePlotParams.spikeheight = 1;
    spikePlotParams.smoothKernelWidth = .200;
    spikePlotParams.binsizePSTH = .250;

    % === Encoding 1 == Plot Raster and PSTH
%     offsets = [];
%     limitRange_forRaster = [ 0 2500 ];
%     limitRange_forPSTH = [ 0 2000 ]; %
%     markerPos=[stimOnset ];
%     
%     plotSpikeRaster_multiple_simplified( 3, offsets, limitRange_forRaster, limitRange_forPSTH, markerPos, ...
%         timestampsOfCell, {params.periods_Enc1}, {indsNonPref,indsPref}, {'NP','P'}, [3 6 1], [3 6 ], spikePlotParams );
% 
    
        
    % === Encoding 1 and Maintenance as multi align plot == Plot Raster and PSTH
    offsets = [2.5];
    limitRange_forRaster = [ 0 2.5; 0 maintOnset+2.5  ];
    limitRange_forPSTH = [ 0 2; offsets offsets+maintOnset+2.5 ]; %
    markerPos=[stimOnset offsets+maintOnset];
    
    [~,axPSTH_Enc1] = plotSpikeRaster_multiple_simplified( 3, offsets, limitRange_forRaster, limitRange_forPSTH, markerPos, ...
        timestampsOfCell, {params.periods_Enc1, params.periods_Maint}, {indsNonPref,indsPref}, {'NP','P'}, [2 6 1 2], [2 6 7 8], spikePlotParams );

     title(['Enc1 + Maint' ])
     xlabel(plabelStr);
    % === end plotting Enc1 + Maint

    % % === Encoding 2 == Plot Raster and PSTH
    % offsets = [];
    % limitRange_forRaster = [0 2.5];
    % limitRange_forPSTH = [0 2]; %
    % markerPos = [stimOnset];
    % 
    % indsEnc2_load2shown = find(PicOrder_Enc2>0);    
    % 
    % if length(indsEnc2_load2shown)>size(params.periods_Enc2,1)
    %     warning('more images then trial periods, missmatch?');
    %     indsEnc2_load2shown = indsEnc2_load2shown(1:size(params.periods_Enc2,1));
    % end
    % 
    % PicOrder_Enc2_shownOnly_inEnc2 = PicOrder_Enc2( indsEnc2_load2shown );    % order of images shown during Enc2, onlly those shown in Enc2    
    % PicOrder_Enc1_shownOnly_inEnc2 = PicOrder_Enc1( indsEnc2_load2shown );
    % 
    % indsPref_Enc2 = find( PicOrder_Enc2_shownOnly_inEnc2==prefCat );
    % 
    % indsNonPref_Enc2_NonPrefEnc1 = find(PicOrder_Enc2_shownOnly_inEnc2 ~=prefCat &  PicOrder_Enc1_shownOnly_inEnc2 ~= prefCat );   % pref not shown in Enc1, and not shown in Enc1
    % indsNonPref_Enc2_PrefEnc1 = find(PicOrder_Enc2_shownOnly_inEnc2    ~=prefCat &   PicOrder_Enc1_shownOnly_inEnc2 == prefCat);   % pref not shown in Enc2, but was shown in Enc1
    % 
    % [~,axPSTH_Enc2] = plotSpikeRaster_multiple_simplified( 3, offsets, limitRange_forRaster, limitRange_forPSTH, markerPos, ...
    %     timestampsOfCell, {params.periods_Enc2}, {indsNonPref_Enc2_NonPrefEnc1, indsNonPref_Enc2_PrefEnc1, indsPref_Enc2}, {'NP NP','NP P', 'P'}, [2 6 3], [2 6 9], spikePlotParams );
    % title(['Enc2 ' ])
    % % === end plotting Enc2
    

    % % === Encoding 3 == Plot Raster and PSTH
    % offsets = [];
    % limitRange_forRaster = [ 0 2.5 ];
    % limitRange_forPSTH = [ 0 2 ]; %
    % markerPos=[stimOnset ];
    % 
    % indsEnc3_load3shown = find(PicOrder_Enc3 > 0);
    % 
    % PicOrder_Enc3_shownOnly_inEnc3 = PicOrder_Enc3( indsEnc3_load3shown );
    % PicOrder_Enc2_shownOnly_inEnc3 = PicOrder_Enc2( indsEnc3_load3shown );
    % PicOrder_Enc1_shownOnly_inEnc3 = PicOrder_Enc1( indsEnc3_load3shown );
    % 
    % indsPref_Enc3 = find(PicOrder_Enc3_shownOnly_inEnc3==prefCat);
    % 
    % indsNonPref_Enc3_NonPrefEnc12 = find(PicOrder_Enc3_shownOnly_inEnc3~=prefCat &  PicOrder_Enc2_shownOnly_inEnc3 ~= prefCat &  PicOrder_Enc1_shownOnly_inEnc3 ~= prefCat ); % pref not shown in Enc3, not in Enc2, not in Enc1
    % 
    % indsNonPref_Enc3_PrefEnc2 = find(PicOrder_Enc3_shownOnly_inEnc3~=prefCat &  PicOrder_Enc2_shownOnly_inEnc3 == prefCat ); % pref not shown in Enc3, pref shown in Enc2
    % indsNonPref_Enc3_PrefEnc1 = find(PicOrder_Enc3_shownOnly_inEnc3~=prefCat &  PicOrder_Enc1_shownOnly_inEnc3 == prefCat ); % pref not shown in Enc3, pref shown in Enc1
    % 
    % [~,axPSTH_Enc3] = plotSpikeRaster_multiple_simplified( 3, offsets, limitRange_forRaster, limitRange_forPSTH, markerPos, ...
    %     timestampsOfCell, {params.periods_Enc3}, {indsNonPref_Enc3_NonPrefEnc12, indsNonPref_Enc3_PrefEnc2, indsNonPref_Enc3_PrefEnc1, indsPref_Enc3}, {'NP NP','NP PE2', 'NP PE1', 'P'}, [2 6 4], [2 6 10], spikePlotParams );
    % title(['Enc3 ' ])
    % % === end plotting Enc3


    % === Probe == Plot Raster and PSTH
    indsProbe_pref_inmem = find( PicOrder_Probe == prefCat & params.ProbeInOut==1 );
    indsProbe_pref_outmem = find( PicOrder_Probe == prefCat & params.ProbeInOut==0 );
    indsProbe_nonpref_inmem = find( PicOrder_Probe ~= prefCat & params.ProbeInOut==1 );
    indsProbe_nonpref_outmem = find( PicOrder_Probe ~= prefCat & params.ProbeInOut==0 );
    
    offsets = [];
    limitRange_forRaster = [ 0 2.5  ];
    limitRange_forPSTH = [ 0 2]; %
    markerPos=[probeOnset];
    
    [~,axPSTH_Probe] = plotSpikeRaster_multiple_simplified( 3, offsets, limitRange_forRaster, limitRange_forPSTH, markerPos, ...
        timestampsOfCell, {params.periods_Probe}, {indsProbe_nonpref_inmem,indsProbe_nonpref_outmem,indsProbe_pref_inmem, indsProbe_pref_outmem }, ...
        {'NP in','NP out', 'P in', 'P out'}, [2 6 5], [2 6 11], spikePlotParams );
        
    title(['Probe ' 'k=' num2str(params.pannelNr)]);
    % === end plotting Probe

    % setCommonAxisRange( [axPSTH_Enc1 axPSTH_Enc2 axPSTH_Enc3 axPSTH_Probe], 2 );   % set common Y axis
    setCommonAxisRange( [axPSTH_Enc1 axPSTH_Probe], 2 );   % set common Y axis
    
    fig = gcf;
    fig.WindowState = 'maximized';
    movegui(gcf,'west')
    fig.WindowState = 'maximized';   
    
    
    
    
    % % Plotting Concept Image
    % StimulusTemplates = nwb.stimulus_templates.get('StimulusTemplates');
    % imgSet = StimulusTemplates.image;
    % order_of_images = StimulusTemplates.order_of_images.data;
    % 
    % prefPathUnstripped = order_of_images(prefCat).path; % Loading raw path
    % stripPrepPath = split(prefPathUnstripped,'/'); % Stripping fileseps
    % prefPath = stripPrepPath{end}; % Grabbing final entry
    % 
    % prefImgload = imgSet.get(prefPath).data.load(); % Loading using the key from order_of_images. 
    % prefImg = permute(prefImgload,[2,3,1]); % Permuting for matlab compatibility
    % 
    % subplot(2,6,6)
    % image(prefImg);
    % pbaspect([4 3 1])
    % set(gca,'YTick',[])
    % set(gca,'XTick',[])    
    
    
    
    if params.exportFig
        if ~isfield(params,'exportPath') || isempty(params.exportPath)
            figPath = 'D:\sandbox'; 
        else
            figPath = params.exportPath;
        end
        if ~exist(figPath,'dir')
            mkdir(figPath)
        end
        %fh=gcf;
        %fh.WindowState = 'maximized';
        
%         paperPosition=[0 0 20 18];
%         set(gcf,'PaperUnits','inches','PaperPosition',paperPosition);
        
        fName = [num2str(figNr) '_SBID' num2str(params.SBind) '_BA_' num2str(params.brainAreaOfCell) '_Cl_' num2str(params.origClusterID) ];        
%         saveas(gcf, [figPath filesep fName '.eps' ], 'epsc')
        saveas(gcf, [figPath filesep fName '.png' ], 'png')
%         saveas(gcf, [figPath filesep fName '.pdf' ], 'pdf','-bestfit')
%         print(gcf,'-dpdf','-bestfit',[figPath filesep fName '.pdf']);
        close(gcf);
    end
    
    
    
    
    

    
end


%% Organizing Results 

if ~isfield(params,'allStats')
    params.allStats=[];
end


params.allStats( size(params.allStats,1)+1,:) = [params.channel  params.cellNr brainAreaOfCell params.origClusterID params.nTrials params.nCORRECTTrials isTunedCell pANOVA pANOVA2 DOS PSI];

% prepare data to return
cellStats=[];
cellStats = copyStructFields( params, cellStats );
if isfield(params,'cellStats')
    fieldsToRemove = {'onlyChannels','plotAlways','onlyAreas','doPlot','pannelNr','onlyCells','allStats','cellStats'};
else
    fieldsToRemove = {'onlyChannels','plotAlways','onlyAreas','doPlot','pannelNr','allStats','onlyCells'};
end
cellStats = rmfield(cellStats, fieldsToRemove);
cellStats.timestamps = timestampsOfCell;



%store spike counts for later analysis
runInd=params.pannelNr;
params.cellStats(runInd) = cellStats;

