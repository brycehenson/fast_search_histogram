function [count] = hist_sortn(X, varargin)
% - X: is (M x N) array, represents M data points in R^N
%   - edgek: are the bin vectors on dimension k, k=1...N.

%recursively defined n dimensional histogram algo
% rough pseudocode
% sort input by first dim
% for edge in edges:
%       use fast sorted mask to select the counts that fit in a given bin
%       if input is one dim
%           accumulate output array
%       else
%           select data in bin then call hist_sortn
% pseudocode
% 
% STATUS 2019-11-11
% - no speedup demonstrated 
% - does not give the same result as histcn because of an edge issue
% TODO
% - work out complexity to see if even in principle speedup
% - comment code
% - subfunction histogram data selector & use adaptive algo for sparse/dense case
%   - as go down in dimensionality will likely traverse from dense to sparse histogram
% - try to implmenet adaptive histogramer for last dimension (1d) step
% Outlook
% - dont expect massive wins but will be a learning experience
% - may be limited by data shuffling

cell_edges = varargin;
nd=size(X,2);
[~,order] =sort(X(:,1),1);
X=X(order,:);
%X=sortrows(X,1);

edge=cell_edges{1};
if size(cell_edges,2)>1
    do_count=0;
else
    do_count=1;
end

if size(cell_edges,2)==2
    %fprintf('thing')
end
   
%should search for upper edge first and pass to binary search 
%to avoid searching ourside the domain
out_size= cellfun(@(x) size(x,1),cell_edges);
if numel(out_size)==1
    count=zeros(out_size-1,1);
else
    count=zeros(out_size-1);
end
index_cell=cell(1, nd);
index_cell(:) = {':'};
num_edges=size(edge,1);
counts=size(X,1);
for ii=1:(num_edges-1)
    if ii==1
        le=edge(ii);
        [val_l,idx_l]=binary_search_first_elm(X,le,1,size(X,1));
        if val_l<le &&  counts>1
            idx_l=idx_l+1;
        end
        idx_u=idx_l;
        
        maxe=edge(end);
        [val_max,idx_max]=binary_search_first_elm(X,maxe,idx_u,size(X,1));
        if val_max>maxe
            idx_max=idx_max-1;
        end
    end
    ue=edge(ii+1);
    [val_u,idx_u]=binary_search_first_elm(X,ue,idx_u,idx_max); %idx_l
    if val_u>ue && idx_u~=1
            idx_u=idx_u-1;
    end
    if do_count
        count(ii)=idx_u-idx_l+1;
    else
        if idx_l~=idx_u+1
            index_cell{1}=ii;
            subx=X(idx_l:idx_u,2:end);
            count(index_cell{:})=hist_sortn(subx, cell_edges{2:end});
        end
    end
        
    idx_l=idx_u+1;

end

end


function [v, btm] = binary_search_first_elm(arr, val,min_idx,start_idx)
% Returns value and index of arr that is closest to val srarting from start_idx. If several entries
% are equally close, return the first. Works fine up to machine error (e.g.
% [v, i] = closest_value([4.8, 5], 4.9) will return [5, 2], since in float
% representation 4.9 is strictly closer to 5 than 4.8).
% ===============
% Parameter list:
% ===============
% arr : increasingly ordered array
% val : scalar in R

top = start_idx(1);
btm = min_idx(1);


% Binary search for index
while top - btm > 1
    med = floor((top + btm)/2);
    % Replace >= here with > to obtain the last index instead of the first.
    if arr(med,1) >= val 
        top = med;
    else
        btm = med;
    end
end

% Replace < here with <= to obtain the last index instead of the first.
%if top - btm == 1 && abs(arr(top) - val) < abs(arr(btm) - val)
%    btm = top;
%end  



v = arr(btm,1);
end



%based on https://au.mathworks.com/matlabcentral/fileexchange/37915-binary-search-for-closest-value-in-an-array?focused=5242723&tab=function
function [v, btm] = binary_search(arr, val,start_idx)
% Returns value and index of arr that is closest to val srarting from start_idx. If several entries
% are equally close, return the first. Works fine up to machine error (e.g.
% [v, i] = closest_value([4.8, 5], 4.9) will return [5, 2], since in float
% representation 4.9 is strictly closer to 5 than 4.8).
% ===============
% Parameter list:
% ===============
% arr : increasingly ordered array
% val : scalar in R


len = length(arr);
btm = start_idx(1);
top = len;

% Binary search for index
while top - btm > 1
    med = floor((top + btm)/2);
    
    % Replace >= here with > to obtain the last index instead of the first.
    if arr(med) >= val 
        top = med;
    else
        btm = med;
    end
end

% Replace < here with <= to obtain the last index instead of the first.
%if top - btm == 1 && abs(arr(top) - val) < abs(arr(btm) - val)
%    btm = top;
%end  



v = arr(btm);
end




% Copyright (c) 2012, Benjamin Bernard
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
% 
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in
%       the documentation and/or other materials provided with the distribution
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.





%2274
%2497
% mask=le<X(:,1) & ue>X(:,1);
%indicies=mask.*(1:numel(mask));



