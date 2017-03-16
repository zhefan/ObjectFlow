function viz_result(dataInfo)

if nargin < 1
    dataInfo.result_path = 'Result/various/01/';
    dataInfo.img_list = dir('Videos/various/*.png');
end

close all
% clear
clc

result_mat = dir([dataInfo.result_path '*.mat']);

for i = 1:length(result_mat)
    temp_load = load([dataInfo.result_path result_mat(i).name]);
    temp_img = im2double(imread([dataInfo.img_list(i+1).folder '/' dataInfo.img_list(i+1).name ]));
    mask = temp_load.mask;
%     mask = imresize(temp_load.mask, 2, 'nearest');
    mask = ~mask .* 0.3 + mask;
    for j = 1:3
%        temp_img(:,:,j) = temp_img(:,:,j) .* uint8(imresize(temp_load.mask, 2, 'nearest'));
       temp_img(:,:,j) = temp_img(:,:,j) .* mask; 
    end
    
%     imshow(temp_img)
    imwrite(temp_img, sprintf('%s%04d.png', dataInfo.result_path, i+1))
%     pause(0.1)
end