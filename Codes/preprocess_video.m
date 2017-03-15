function dataInfo = preprocess_video(dataInfo, dirInfo, para)
%% load video data
dataInfo.inputPath = [dataInfo.videoPath dataInfo.videoName];
inputPath = dataInfo.inputPath;

list = dir([inputPath '*.' dataInfo.videoFormat]);
dataInfo.totalFrame = length(list);
totalFrame = dataInfo.totalFrame;

videoAll = cell(totalFrame,1);
for ff = 1:totalFrame
    videoAll{ff} = imresize(imread([inputPath '/' list(ff).name]), 0.5);
end
dataInfo.videoAll = videoAll;

%% compute optical flows
tic
dataInfo = compute_optical_flow(dataInfo, dirInfo);
dataInfo.of_time = toc;
%% compute CNN features
tic
extract_CNN_features(dataInfo, dirInfo, para);
dataInfo.cnn_time = toc;
%% compute supervoxels
tic
extract_supervoxels(dataInfo, dirInfo, para);
dataInfo.voxel_time = toc;

dataInfo.img_list = list;
