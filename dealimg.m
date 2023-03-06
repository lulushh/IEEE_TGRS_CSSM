function img_out = dealimg(img)
% 这个函数用于处理预处理完成后的图像
% img: Original hyperspectral image;
% out: the structural profile
% Dimention reduction
[rows, cols, bands] = size(img);
%%% normalization

bands=size(img,3);
fimg=reshape(img,[rows*cols bands]);
[fimg] = scale_new(fimg);
fimg=reshape(fimg,[rows cols bands]);

img_out =kpca(fimg, 1000,45, 'Gaussian',20);
end




