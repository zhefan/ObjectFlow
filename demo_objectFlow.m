% demo for video object segmentation in the paper: "Video Segmentation via Object Flow",
% Y.-H. Tsai, M.-H. Yang and M. J. Black, CVPR 2016.
close all
clear
clc

%% setups
setup_all;
para.seeResult = 1;  % visualize results
para.saveResult = 1; % save binary masks as mat files

%% video data information
% change below for different videos
dataInfo.videoPath = 'Videos/';
dataInfo.videoName = 'waterpot/';
dataInfo.gtName = 'gt/';
dataInfo.videoFormat = 'png';
dataInfo.gtFormat = 'png';

%% pre-process data
dataInfo = preprocess_video(dataInfo, dirInfo, para);
inputPath = dataInfo.inputPath;
totalFrame = dataInfo.totalFrame;

%% load ground truths
gtPath = [inputPath  dataInfo.gtName ['*.' dataInfo.gtFormat]];
gtMask = cell(totalFrame,1);
list = dir(gtPath);

% for incomplete ground truths (e.g., Youtube-Objects dataset)
for ff = 1:length(list)
    tmp = imresize(imread([inputPath dataInfo.gtName list(ff).name]), 0.5);
    
    % change below according to different ground truth formats
    %frame = str2double(list(ff).name(1:end-4));
    gtMask{1} = (double(tmp)>128);
end
dataInfo.gtMask = gtMask;

%% build the initial model
tic
fprintf('Build initial models...\n');
onlineModel = build_initial_model(dataInfo, dirInfo, para);
dataInfo.init_model_time = toc;

%% track segments from frame t to t+1
tic
onlineModel.iou = 0;
fprintf('Start tracking segments...\n');
for ff = 1:totalFrame-1    
    %% build the online model
    onlineModel.ff = ff;
    onlineModel = build_online_model(onlineModel, dataInfo, dirInfo, para);
    
    %% estimate the object location
    onlineModel.video = dataInfo.videoAll(ff:ff+1); onlineModel.flows = dataInfo.flowsAll(ff); onlineModel.flowsInv = dataInfo.flowsInvAll(totalFrame-ff);
    onlineModel = estimateObjectLoc(onlineModel, para);
    
    %% track object segment 
    % 1) build the multi-level graph
    % 2) compute potentials
    % 3) solved by graph cut
    onlineModel = objectSegmentTracking(onlineModel, para);
    
    %% plot results
    %fprintf('Finish segmentating frame %d/%d in %f seconds.\n', ff, totalFrame-1, toc);
    % onlineModel = plotResult(onlineModel, dataInfo, dirInfo, para);
    
    %% save results
    if para.saveResult == 1
        path = [dirInfo.resultPath sprintf('%s/',dataInfo.videoName(1:end-1) )];
        if ~exist(path,'dir'), mkdir(path); end;
        save([path sprintf('%05d_mask.mat',ff+1)],'mask','-v7.3');
    end
end
dataInfo.tracking_time = toc;
fprintf('finish segmetnting video: %s obj %d, average IOU: %f.\n\n',dataInfo.videoName(1:end-1), dataInfo.objId, onlineModel.iou/(totalFrame-1));

