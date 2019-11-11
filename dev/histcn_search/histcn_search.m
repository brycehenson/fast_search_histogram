function [count,edges] = histcn_search(X, varargin)
% function [count edges mid loc] = histcn(X, edge1, edge2, ..., edgeN)
%
% Purpose: compute n-dimensional histogram using a bin search algorithm for faster sparse histograms

% Bryce Henson 2019-11-11
% Development notes
% Getting a speedup on multi dim hist. has been a long term goal
% while some kind of recursive count search histogram algo is in principle faster for dense hist. in practice the 
% function call, data sectioning gives worse performance (I wrote and tested this code previously, It would be
% good to bring it into this dev branch just for understanding how it fell down)
% However a bin search algorithm has some hope for a sparse histogram speedup
% pseudocode:
% for d in dims:
    % for data_idx in size(data(dim)) :
        % bin_idx(data_idx,dim)=binary_search_bin(edges,data(data_idx,dim))
% count_matrix=accumarray(bin_idx)
% the building of each dimesnion index seperately means that this could be easily transformed into a sparse
% matrix if desired (supports an insane number of bins) however matlabs sparse matrix is limited to 2d!
% i only expect this to be faster for sparse hist, but this is often what I want to use in some data
% processing eg 3d correlations
% the time complexity of the index building should be O( d·n·log(m)) d=dimensionality, n=counts, m=bins
% and then the complexity of constructing the output matrix will be O(d*m + n )
% this algo uses a mex compiled function for the index_bin_search which speeds that up a lot!
% however because the matrix constuction with accumarray is slower than the inxed creation this function has
% very little speedup on histcn for dimensionality greater than one



if ~ismatrix(X)
    error('histcn: X requires to be an (M x N) array of M points in R^N');
end

AccumData = [];

% Get the dimension
num_dim = size(X,2);
edges = varargin;
% if nd<length(edges)
%     nd = length(edges); % wasting CPU time warranty
% else
%     edges(end+1:nd) = {DEFAULT_NBINS};
% end

% Allocation of array loc: index location of X in the bins
loc = zeros(size(X));
out_size = zeros(1,num_dim);
% Loop in the dimension
for dim=1:num_dim
    one_dim_edge = edges{dim};
    single_dim_cord = X(:,dim);
    % find the index in each dimension
    loc(:,dim) = index_bin_search_mex(single_dim_cord, one_dim_edge);
    % Use sz(d) = length(ed); to create consistent number of bins
    out_size(dim) = length(one_dim_edge)-1 +2;
end % for-loop


% This is need for seldome points that hit the right border
%sz = max([sz; max(loc,[],1)]);

          
% Count for points where all coordinates are falling in a corresponding
% bins
if num_dim==1
    out_size = [out_size 1]; % Matlab doesn't know what is one-dimensional array!
end

% hasdata = all(loc>0, 2);
% if ~isempty(AccumData)
%     count = accumarray(loc(hasdata,:), AccumData(hasdata), sz, Fun{:});
% else


count = accumarray(loc, 1, out_size);
%count=loc;


end



