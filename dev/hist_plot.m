% create a plot of a histogram for the logo
rng(3)
x = randn(210,1);
x=cat(1,x,repmat(1.3,15,1));
x=sort(x);
edges=linspace(-3,3,15)';
centers=(edges(2:end)+edges(1:end-1))/2;
counts = adaptive_hist_method(x,edges,1);
bar(centers,counts(2:end-1),1)