function [bin_count,edges]=even_spaced_hist(data,start_edge,end_edge,num_edges)
%even_spaced_hist - a histogram algorithm based simple arithmatic to determine if each count is in
%a given bin
% !!!!!!!!!!!!!!! REQUIRES ORDERED DATA !!!!!!!!!!!!!!!!!!!!!!!!
% gives asymptotic complexity O(m·log(n)) over convertional hitograming O(n·m)

% Syntax:         bin_counts=count_search_hist(data,edges)
% Equivelent to:  bin_counts=histcounts(data,[-inf;edges;inf])
% Designed to replicate histcounts(X,edges) "The value X(i)
%is in the kth bin if edges(k)  ? X(i) < edges(k+1)" 
% Inputs:
%    data            - column vector of data/counts , MUST BE ORDERED!
%    edges           - column vector of bin edges, MUST BE ORDERED!

%
% Outputs:
%    bin_count - column vector, with length numel(edges)+1,  the first(last) element 
%                are the number of counts below(above) the first(last) edge
%
% Example: 
%     data=rand(1e5,1);
%     data=sort(data);
%     edges=linspace(0.1,1.1,1e6)';
%     out1=even_spaced_hist(data,edges);
%     out2=histcounts(data,[-inf;edges;inf])';
%     isequal(out1,out2)
% Other m-files required: none
% Also See: scaling_tests
% Subfunctions: none
% MAT-files required: none
%
% Known BUGS/ Possible Improvements
%  - try forward prediction for count search.
%
% Author: Bryce Henson
% email: Bryce.Henson@live.com
% Last revision:2018-12-31

%------------- BEGIN CODE --------------



%if ~iscolumn(data)
%    error('inputs must be column vectors')
%end

% number of bins is edges-1 with 2 extra for below lowest and above highest
num_bins_whole=num_edges-1;
num_bins_domain=num_bins_whole+2;
bin_width=(end_edge-start_edge)/(num_bins_whole); %minus 2 for the -inf and +inf

bin_count=zeros(num_bins_domain,1);
num_data=size(data,1);


for ii=1:num_data
    frac_bins=(data(ii)-start_edge)/bin_width;
    closest_idx=floor(frac_bins);
    if closest_idx<0
        closest_idx=1;
    elseif closest_idx>num_bins_whole
        closest_idx=num_bins_domain;
    else
        closest_idx=closest_idx+2;
    end
    bin_count(closest_idx)=bin_count(closest_idx)+1; 
end

edges=[-inf,start_edge+bin_width*(0.0:num_bins_whole),inf];

end








