
data=1e9*rand(1e4,1)-0.1;
num_edges=500;
min_edge=-1e5;
max_edge=1e5;

[out1,out1_edges]=even_spaced_hist(data,0,1,num_edges);
[out3,out3_edges]=histcounts(data,num_edges-1,'BinLimits',[min_edge,max_edge]);

if ~isequal(double(out1(2:end-1)),out3')
    error('not equal')
end