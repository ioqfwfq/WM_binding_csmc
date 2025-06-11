%
%generic function
%
%loops over all cells of a channel and calls a custom function for evaluation. 
%
%input arguments:
% evalFunc is a function pointer. it can be an internal function of the calling function or a function defined in a separate file.
% its arguments are: evalFunc( timestampsOfCell, figNr, brainAreaOfCell, plabel, params, varargin )
%
% if params.isMUA=1, this function clusters als SUA as one MUA and runs the function once per channel.
% if params.onlyChannels -> only these channels will be processed. Otherwise,all (1-64).
% if params.onlyCells -> only these cells will be processed. Otherwise,all.
% onlyChannels/onlyCells can be used to request processing of only subsets of channels/cells
% onlyAreas: if set,only areas listed here
%
%urut/april06
function params = runForAllCellsInSession( basedirData,  brainArea, sessionID, evalFunc, params, varargin )

prefix='A';
spikes=[];
pannelNr=0; %a running index so the callback function knows how many times it has been called so far.

%import parameters; set to default if not set
isMUA = copyFieldIfExists( params, 'isMUA', 0);
channelsToProcess = copyFieldIfExists( params, 'onlyChannels', [1:256]);
if isempty(channelsToProcess)
    channelsToProcess=1:96;
end

onlyCells = copyFieldIfExists( params, 'onlyCells', []);
onlyAreas = copyFieldIfExists( params, 'onlyAreas', []);

for channelId=1:length(channelsToProcess)
    channel=channelsToProcess(channelId);
    
    fname = fullfile(basedirData,[prefix,num2str(channel),'_cells.mat']);
    if exist(fname)~=2
        continue;
    end

    load(fname);
    %has no spikes in this channel
    if size(spikes,1)==0
        fprintf('opened: %s - no spikes in this channel \n', fname);
        continue;
    end

    cells = unique(spikes(:,1) );
    fprintf('opened: %s - %s cells in this channel \n', fname, num2str(length(cells)));

    if ~isempty(onlyCells)
        cells=onlyCells;
        fprintf('In %s process only cells: %s\n', fname, num2str(onlyCells));        
    end
    
    if isMUA
        fprintf('MUA mode enabled. pool all cells to one (cellNr=0)');
        cells=0;
    end

    for i=1:length(cells)
        currentCell=cells(i);

        origClusterIDs = spikes(find(spikes(:,1)==currentCell),2);
        origClusterIDs = unique(origClusterIDs);
        
        if currentCell>0
            %SUA
            timestampsOfCell = spikes( find(spikes(:,1)==currentCell), 3);
        else
            %MUA
            timestampsOfCell=[];
            for tmpCellNr=1:length(unique(spikes(:,1)))
                timestampsOfCell = [timestampsOfCell; spikes( find(spikes(:,1)==tmpCellNr), 3)];
            end
        end

        if size(timestampsOfCell,1)==0
            continue;
        end

        figNr = channel*100+i;
        if currentCell>0
            if ~isempty(brainArea)
                brainAreaOfCell = brainArea( find (  brainArea(:,1)==channel & brainArea(:,2)==currentCell ), 4 );
                if isempty(brainAreaOfCell)
                    brainAreaOfCell = 99;   % undefined
                end
            else
                brainAreaOfCell = nan;
            end
        else
            brainAreaOfCell = getBrainareaOfChannel( brainArea, channel); %MUA, channel lookup only
        end
        
        if ~isempty(onlyAreas) 
           if isempty(find(brainAreaOfCell == onlyAreas))
               fprintf('skip - processing of area %s is disabled \n', num2str(brainAreaOfCell));
               continue;
           end
        end
        
        brainAreaDescr = translateArea ( brainAreaOfCell );
        plabel = [sessionID ' ' prefix 'C' num2str(channel) '-' num2str(currentCell) ' ' brainAreaDescr ' '];
        
        pannelNr=pannelNr+1;
        params.pannelNr = pannelNr;
        params.channel=channel;
        params.cellNr=currentCell;
        params.brainAreaOfCell = brainAreaOfCell;
        params.sessionID = sessionID;
        params.origClusterID = origClusterIDs;
        
        %call the callback function that processes this cell
        params = evalFunc( timestampsOfCell, figNr, brainAreaOfCell, plabel, params, varargin );  
        
        drawnow; %make sure figures continously update so results can be observed while this loops through all cells
    end    
end