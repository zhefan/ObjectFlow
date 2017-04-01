close all
clear
clc

%% setups
setup_all;

gt_objID = {'tide', 'sugar', 'red_bowl', 'downy', 'waterpot', 'ranch'};

dataInfo.videoPath = 'Videos/';
dataInfo.videoName = 'various_1/';
dataInfo.gtName = 'gt/';
dataInfo.videoFormat = 'png';

for i = 1:length(gt_objID)
    dataInfo.objID = gt_objID{i};
    dataInfo.result_path =...
        [dirInfo.resultPath sprintf('%s/%s/',dataInfo.videoName(1:end-1),dataInfo.objID)];

    run_objectFlow(dataInfo, dirInfo, para);
end

viz_result(dataInfo)