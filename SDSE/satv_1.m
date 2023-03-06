function u = satv_1(g,mu)
    % Prepare images
    %f_orig  = im2double(imread('./data/lena512.png'));
    %[rows cols frames] = size(f_orig);
    %H   = fspecial('gaussian', [9 9], 2);
    H = 1;
    H = double(H);
    


    % Setup parameters (for example)
    opts.rho_r   = 5;
    opts.rho_o   = 100;
    opts.beta    = [1 1 0];
    opts.print   = true;
    opts.alpha   = 0.7;
    opts.method  = 'l1';

u = deconvtv(g, mu, H, opts);





