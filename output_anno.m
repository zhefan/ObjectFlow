close all
clear
clc

viz = 0;

dataInfo = globalOpts;

tracked_objs = cell(length(dataInfo.gt_objID),1);
for i = 1:length(dataInfo.gt_objID)
    result_path = ['Result/various_1/' dataInfo.gt_objID{i} '/'];
    gtPath = [dataInfo.inputPath dataInfo.gtName dataInfo.gt_objID{i} '/*.' dataInfo.videoFormat];
    gt_img_name = dir(gtPath);
    gt_img = imread([dataInfo.inputPath dataInfo.gtName dataInfo.gt_objID{i} '/' gt_img_name.name]);
    % mask to bounding box
    [x_min, y_min, x_max, y_max] = seg2bbox(gt_img);
    tracked_pos = [x_min, y_min, x_max, y_max];
    
    result_mat = dir([result_path '*.mat']);
    fname_list = cell(length(result_mat),1);
    fname_list{1} = gt_img_name.name;
    
    for j = 1:length(result_mat)
        temp_load = load([result_path result_mat(j).name]);
        mask = temp_load.mask;
        
        % mask to bounding box
        [x_min, y_min, x_max, y_max] = seg2bbox(mask);
        
        tracked_pos = [tracked_pos; x_min y_min x_max y_max];
        width = x_max-x_min+1;
        height = y_max-y_min+1;
        fname_list{j+1} = dataInfo.img_list(j+1).name;
        
        % viz
        if viz
            temp_img = im2double(imread([dataInfo.folder dataInfo.img_list(j+1).name ]));
            imshow(temp_img), hold on
            rectangle('Position', [x_min, y_min, width, height],'EdgeColor','r', 'LineWidth', 3);
            % pause(0.1)
        end
        
    end
    tracked_objs{i}.name = dataInfo.gt_objID{i};
    tracked_objs{i}.pos = tracked_pos;
    tracked_objs{i}.img_names = fname_list;
    
end

gen_xml(tracked_objs);
dataset_img = '/home/zhefanye/Documents/datasets/ProgressLab/progress/JPEGImages/';
command = sprintf('cp %s*.%s %s', dataInfo.folder, dataInfo.videoFormat, dataset_img);
fprintf('Copying images...\n')
system(command,'-echo');
fprintf('Done\n')




