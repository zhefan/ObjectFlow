function [x_min, y_min, x_max, y_max] = seg2bbox(mask)
% mask to bounding box

fore_idx = find(mask ~= 0);
[y, x] = ind2sub(size(mask),fore_idx);
x_min = min(x);
y_min = min(y);
x_max = max(x);
y_max = max(y);


end