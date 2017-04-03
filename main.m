close all
clear
clc

%% setups
setup_all;
dataInfo = globalOpts;

for i = 1:length(dataInfo.gt_objID)
    dataInfo.objID = dataInfo.gt_objID{i};
    dataInfo.result_path =...
        [dirInfo.resultPath sprintf('%s/%s/',dataInfo.videoName(1:end-1),dataInfo.objID)];

    run_objectFlow(dataInfo, dirInfo, para);
end

output_anno;