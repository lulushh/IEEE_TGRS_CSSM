function re_img = Normalization( img )

%   �˴���ʾ��ϸ˵��
[nu_lines,nu_rows,nu_bands]=size(img);
re_img=reshape(img,nu_lines*nu_rows,nu_bands);
re_img=scale_new(re_img);
re_img=reshape(re_img,[nu_lines nu_rows,nu_bands]);
end

