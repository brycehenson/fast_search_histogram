function [count edges] = histcn_search(X, varargin)
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
% matrix if desired (supports an insane number of bins)
% i only expect this to be faster for sparse hist, but this is often what I want to use in some data
% processing eg 3d correlations
% the time complexity of the index building should be O( d·n·log(m)) d=dimensionality, n=counts, m=bins
% while the algo works at current, there is only speedup for d=1 which is strange
% then I find some odd superlinear scaling
% cant beat ndhist for dimensionality greater than 2
% dont understand where the linear dependend with number of bins comes from when i expect a log(bins)^dim relationship



if ndims(X)>2
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
    loc(:,dim) = index_bin_search(single_dim_cord, one_dim_edge);
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
%count=1;
%end


end



function bin_idx=index_bin_search(data,edges)
if ~iscolumn(data) || ~iscolumn(edges)
    error('inputs must be column vectors')
end

% number of bins is edges-1 +  2 extra for below lowest and above highest
num_edges=size(edges,1);
num_data=size(data,1);
bin_idx=zeros(num_data,1);
for ii=1:num_data
    data_val=data(ii);
    closest_idx=binary_search_first_elm(edges,data_val,1,num_edges);
    closest_idx=closest_idx+1;
    %if closest is on the edge check if it should go up or down
    if closest_idx==2
    	if data_val<edges(1)
            closest_idx=closest_idx-1;
    	end
    elseif closest_idx==num_edges
    	if data_val>edges(num_edges)
            closest_idx=closest_idx+1;
    	end
    end
	bin_idx(ii)=closest_idx; 
end

end



%modified from mathworks submission by Benjamin Bernard 
%from https://au.mathworks.com/matlabcentral/fileexchange/37915-binary-search-for-closest-value-in-an-array
function idx_closest = binary_search_first_elm(vec, val,lower_idx,upper_idx)
% Returns index of vec that is closest to val, searching between min_idx start_idx . 
%If several entries
% are equally close, return the first. Works fine up to machine error (e.g.
% [v, i] = closest_value([4.8, 5], 4.9) will return [5, 2], since in float
% representation 4.9 is strictly closer to 5 than 4.8).
% ===============
% Parameter list:
% ===============
% arr : increasingly ordered array
% val : scalar in R
% use for debug in loop %fprintf('%i, %i, %i\n',btm,top,mid)

top = upper_idx(1);
btm = lower_idx(1);

% Binary search for index
while top > btm + 1
    mid = floor((top + btm)/2);
    % Replace >= here with > to obtain the last index instead of the first.
    if vec(mid) <= val %modified to work to suit histogram
        btm = mid;
    else
        top = mid;
    end
end

% Replace < here with <= to obtain the last index instead of the first.
%if top - btm == 1 && abs(arr(top) - val) < abs(arr(btm) - val)
%    btm = top;
%end  

idx_closest=btm;
end