function out=adaptive_hist_method(x_dat,edges,is_x_sorted)

dat_size=numel(x_dat);
edges_size=numel(edges);

if is_x_sorted
    if edges_size<2e3
        out=hist_count_search(x_dat,edges);
    else
        if dat_size>1e3
            %call histcounts with edges
            out=histcounts(x_dat,[-inf;edges;inf])';
        else
            out=hist_bin_search(x_dat,edges);
        end
    end
else
    if dat_size>1e3
        %call histcounts with edges
        out=histcounts(x_dat,[-inf;edges;inf])';
    else
         out=hist_bin_search(x_dat,edges);
    end
end



end