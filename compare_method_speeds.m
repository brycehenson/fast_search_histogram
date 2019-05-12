function [best_method_str,details]=compare_method_speeds(x_dat,bin_lims,bins)
% calculate the runtime of various histogram methods
% also check that they return the same answers

meth_times=[];
aux_times=[];
aux_times.sort=0;
out=[];

if ~issorted(x_dat)
    timer_handle=tic;
    x_dat=sort(x_dat);
    aux_times.sort=toc(timer_handle);
end


bin_lims=sort(bin_lims);

%generate the edges vector
timer_handle=tic;
edges=linspace(bin_lims(1),bin_lims(2),bins+1)';
aux_times.gen_edges=toc(timer_handle);

%call histcounts with edges
timer_handle=tic;
out.histcounts_edges=histcounts(x_dat,[-inf;edges;inf])';
meth_times.histcounts_edges=toc(timer_handle);

%call histcounts with nbins and limits
timer_handle=tic;
out.histcounts_nbins=histcounts(x_dat,bins,'BinLimits',bin_lims)';
meth_times.histcounts_nbins=toc(timer_handle);

%because there is not the below min and above max bin comparison must be simpler
if ~isequal(out.histcounts_edges(2:end-1),out.histcounts_nbins)
    error('histcounts_edges and histcounts_nbins did not return the same output')
end

timer_handle=tic;
out.hist_bin_search=hist_bin_search(x_dat,edges);
meth_times.hist_bin_search=toc(timer_handle);

if ~isequal(out.histcounts_edges,out.hist_bin_search)
    error('histcounts_edges and hist_bin_search did not return the same output')
end

timer_handle=tic;
out.hist_count_search=hist_count_search(x_dat,edges);
meth_times.hist_count_search=toc(timer_handle);

if ~isequal(out.histcounts_edges,out.hist_count_search)
    error('histcounts_edges and hist_count_search did not return the same output')
end

% to be perfectly fair the methods that used the edge vector must have the edge vector generation time added
meth_times.histcounts_edges=aux_times.gen_edges+meth_times.histcounts_edges;
meth_times.hist_bin_search=aux_times.gen_edges+meth_times.hist_bin_search;
meth_times.hist_count_search=aux_times.gen_edges+meth_times.hist_count_search;


meth_times.hist_count_search=meth_times.hist_count_search+aux_times.sort;


feild_names=fields(meth_times);
[~,min_idx]=min(cell2mat(struct2cell(meth_times)));
best_method_str=feild_names{min_idx};


details=[];
details.core_times=meth_times;
details.aux_times=aux_times;
details.out=out;




end

