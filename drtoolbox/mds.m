function [mappedA, mapping] = mds(X, no_dims)
%MDS Run MDS on the data to get a low-dimensional visualization
% 
%   mappedX = mds(X, no_dims)
%
% Run multidimensional scaling on the dataset X to get a two-dimensional 
% visualization. The low-dimensional representation is returned in mappedX.
% It has dimensionality no_dims (default = 2).
%
%

% This file is part of the Matlab Toolbox for Dimensionality Reduction.
% The toolbox can be obtained from http://homepage.tudelft.nl/19j49
% You are free to use, change, or redistribute this code in any way you
% want for non-commercial purposes. However, it is appreciated if you 
% maintain the name of the original author.
%
% (C) Laurens van der Maaten, Delft University of Technology


    if ~exist('no_dims', 'var')
        no_dims = 2;
    end
    
    X = double(reshape(X, size(X,1)*size(X,2), size(X,3)));%%自己加的一句话
    
    % NOTE: Classical scaling is identical to performing PCA, except the
    % input data is different. Specifying pairwise similarity data is not
    % yet supported by the toolbox.
	[mappedA, mapping] = compute_mapping(X, 'PCA', no_dims);