
data=[0.25,0.6]';
num_edges=6;
edges=linspace(0,1,num_edges)'
out1=even_spaced_hist(data,0,1,num_edges)
out2=histcounts(data,[-inf;edges;inf])'
isequal(out1,out2)
