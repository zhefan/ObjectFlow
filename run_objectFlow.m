% demo for video object segmentation in the paper: "Video Segmentation via Object Flow",
% Y.-H. Tsai, M.-H. Yang and M. J. Black, CVPR 2016.
close all
clear
clc

%% setups
setup_all;

%% video data information
% change below for different videos
dataInfo.videoPath = 'Videos/';
dataInfo.videoName = 'various/';
dataInfo.gtName = 'gt/';
dataInfo.videoFormat = 'png';
dataInfo.objID = 1;
dataInfo.result_path =...
    [dirInfo.resultPath sprintf('%s/%02d/',dataInfo.videoName(1:end-1),dataInfo.objID)];

%% pre-process data
dataInfo = preprocess_video(dataInfo, dirInfo, para);
inputPath = dataInfo.inputPath;
totalFrame = dataInfo.totalFrame;

%% load ground truths
gtPath = [inputPath  dataInfo.gtName sprintf('%02d/', dataInfo.objID) ['*.' dataInfo.videoFormat]];
gtMask = cell(totalFrame,1);
gt_list = dir(gtPath);

% for incomplete ground truths (e.g., Youtube-Objects dataset)
for ff = 1:length(gt_list)
    tmp = imresize(imread([inputPath...
        dataInfo.gtName sprintf('%02d/', dataInfo.objID) gt_list(ff).name]), 0.5);
    
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
    if ~exist(dataInfo.result_path,'dir'), mkdir(dataInfo.result_path); end;
    mask = imresize(onlineModel.mask, 2, 'nearest');
    [~, out_name, ~] = fileparts(dataInfo.img_list(ff+1).name);
    save([dataInfo.result_path out_name '.mat'], 'mask', '-v7.3');
end
dataInfo.tracking_time = toc;
% fprintf('finish segmetnting video: %s obj %d, average IOU: %f.\n\n',dataInfo.videoName(1:end-1), dataInfo.objId, onlineModel.iou/(totalFrame-1));

