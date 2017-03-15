function viz_result(dataInfo)

close all
% clear
clc

result_mat = dir([dataInfo.result_path '*.mat']);

for i = 1:length(result_mat)
    temp_load = load([dataInfo.result_path result_mat(i).name]);
    temp_img = imread([dataInfo.img_list(i+1).folder '/' dataInfo.img_list(i+1).name ]);
    for j = 1:3
       temp_img(:,:,j) = temp_img(:,:,j) .* uint8(imresize(temp_load.mask, 2, 'nearest')); 
    end
    
    imshow(temp_img)
    pause(0.5)
end