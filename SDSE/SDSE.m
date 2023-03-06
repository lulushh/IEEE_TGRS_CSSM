function [ out,fimg1 ] = SDSE( img )
% img: Original hyperspectral image;
% out: the structural profile
% Dimention reduction
%img2=average_fusion(img,40);
[no_lines, no_rows, no_bands] = size(img);
%%% normalization

no_bands=size(img,3);
fimg=reshape(img,[no_lines*no_rows no_bands]);
[fimg] = scale_new(fimg);
fimg=reshape(fimg,[no_lines no_rows no_bands]);
fimg1 = satv_1(fimg,1.2);
out =kpca(fimg1, 1000,45, 'Gaussian',20);
%out = fimg1;
end

