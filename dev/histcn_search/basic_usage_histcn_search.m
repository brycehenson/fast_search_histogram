%simple script to call index_bin_search
% code scrap for diagnosing xover
bins=3e4;   
num_counts=1e2;
dimensions=2;
data=normrnd(0,0.5,[num_counts,dimensions]);


edges={linspace(-1,1,bins+1)'};
edges=repmat(edges,[1,dimensions]);

out_histcn_search=histcn_search(data, edges{:});
