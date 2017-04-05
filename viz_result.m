function viz_result(dataInfo)

if nargin < 1
    dataInfo = globalOpts;
    dataInfo.objID = 'sugar';
    dataInfo.result_path = ['Result/' dataInfo.videoName dataInfo.objID '/'];
end

close all
% clear
clc

result_mat = dir([dataInfo.result_path '*.mat']);

for i = 1:length(result_mat)
    fprintf('img: %d\n', i)
    
    temp_load = load([dataInfo.result_path result_mat(i).name]);
    temp_img = im2double(imread([dataInfo.folder dataInfo.img_list(i+1).name ]));
    mask = temp_load.mask;
    
    % mask to bounding box
    [x_min, y_min, x_max, y_max] = seg2bbox(mask);
    width = x_max-x_min+1;
    height = y_max-y_min+1;
    
%     mask = imresize(temp_load.mask, 2, 'nearest');
    mask = ~mask .* 0.3 + mask;
    for j = 1:3
%        temp_img(:,:,j) = temp_img(:,:,j) .* uint8(imresize(temp_load.mask, 2, 'nearest'));
       temp_img(:,:,j) = temp_img(:,:,j) .* mask; 
    end
    
    imshow(temp_img), hold on
    rectangle('Position', [x_min, y_min, width, height],'EdgeColor','r', 'LineWidth', 3);
    pause(0.1)
%     imwrite(temp_img, sprintf('%s%04d.png', dataInfo.result_path, i+1))
end