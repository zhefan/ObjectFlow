close all
clear
clc

result_path = '/home/zhefanye/Documents/Programs/code/test/ObjectFlow/Result/waterpot/1/';
result_mat = dir([result_path '*.mat']);

img_path = '/home/zhefanye/Documents/Programs/code/test/ObjectFlow/Videos/waterpot/';
img_dir = dir([img_path '*.png']);

for i = 1:length(result_mat)
    temp_load = load([result_path result_mat(i).name]);
    temp_img = imread([img_path img_dir(i+1).name]);
    for j = 1:3
       temp_img(:,:,j) = temp_img(:,:,j) .* uint8(imresize(temp_load.mask, 2, 'nearest')); 
    end
    
    imshow(temp_img)
    pause(0.1)
end