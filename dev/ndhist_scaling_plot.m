%%
dimensions=1;
num_counts=1e5;
bins=1e2;

%%
%nthroot(counts,dimensions)
data=normrnd(0,0.5,[num_counts,dimensions]);
edges=linspace(-1,1,bins);
edges=repmat(edges,[dimensions,1]);
cout=histcn(data, edges(1,:)');
sum(cout(:))
plot(sum(cout,3))

%%
clf
cout=hist_sortn(data, edges(1,:)');
sum(cout(:))
plot(sum(cout,3))




%%
dimensions=2;
num_counts=1e6;
bins=1e2;


data=normrnd(0,0.5,[num_counts,dimensions]);
edges=linspace(-1,1,bins);
edges=repmat(edges,[dimensions,1]);
size(edges)
cout_normal=histcn(data, edges(1,:)',edges(2,:)');
imagesc(sum(cout_normal,3))
sum(cout_normal(:))
%%
clear('count');
cout_sorted=hist_sortn(data,0, edges(1,:)',edges(2,:)' );
imagesc(sum(cout_sorted,3))
sum(cout_sorted(:))

%%
imagesc(sum(cout_sorted-cout_normal,3))
isequal(cout_sorted,cout_normal)



%%
tic
dimensions=3;
num_counts=1e5;
bins=1e2;
num_list=round(linspace(1e2,1e6,1e2));
time_taken=num_list*nan;
for n=1:numel(num_list)
num_counts=num_list(n);   
%nthroot(counts,dimensions)
data=normrnd(0,0.5,[num_counts,dimensions]);
edges=linspace(-1,1,bins);
edges=repmat(edges,[dimensions,1]);
tic
cout=histcn(data, edges(1,:)',edges(2,:)',edges(3,:)' );
time_taken(n)=toc;
fprintf('n= %03u time %f.2\n',num_list(n),time_taken(n))
end
%imagesc(sum(cout,3))
%%
plot(num_list,time_taken)
xlabel('counts to histogram (n)')
ylabel('evaluation time (s)')


%%
tic
dimensions=3;
num_counts=1e4;
bins=1e2;
num_list=round(linspace(1e2,1e7,1e3));
time_taken_sort=num_list*nan;


time_taken=num_list*nan;
for n=1:numel(num_list)
num_counts=num_list(n);   
%nthroot(counts,dimensions)
data=normrnd(0,0.5,[num_counts,dimensions]);
edges=linspace(-1,1,bins);
edges=repmat(edges,[dimensions,1]);
tic
cout=histcn(data, edges(1,:)',edges(2,:)',edges(3,:)' );
time_taken(n)=toc;
fprintf('n= %03u time %f.2\n',num_list(n),time_taken(n))
end


for n=1:numel(num_list)
num_counts=num_list(n);   
%nthroot(counts,dimensions)
data=normrnd(0,0.5,[num_counts,dimensions]);
edges=linspace(-1,1,bins);
edges=repmat(edges,[dimensions,1]);
tic
cout=hist_sortn(data, 0,edges(1,:)',edges(2,:)',edges(3,:)' );

time_taken_sort(n)=toc;
fprintf('n= %03u time %f.2\n',num_list(n),time_taken_sort(n))
end
%imagesc(sum(cout,3))



%%
%n scaling
tic
dimensions=1;
num_counts=1e2;
bins=1e4;
num_list=round(linspace(1e3,1e6,1e2));
time_taken_sort=num_list*nan;
time_taken=num_list*nan;
time_taken=num_list*nan;
sfigure(1)
set(gcf,'color','w')
for n=1:numel(num_list)
num_counts=num_list(n);   
%nthroot(counts,dimensions)
data=normrnd(0,0.5,[num_counts,dimensions]);
edges=linspace(-1,1,bins);
edges=repmat(edges,[dimensions,1]);
tic
cout=histcn(data, edges(1,:)');
time_taken(n)=toc;
fprintf('n= %03u time %f.2\n',num_list(n),time_taken(n))
sfigure(1);
plot(num_list,time_taken_sort)
hold on
plot(num_list,time_taken)
hold off
xlabel('counts to histogram (n)')
ylabel('evaluation time (s)')
legend('my sort based histogram','histcn')
title(sprintf('bins=10^{%.1f}',log10(bins)))
pause(1e-3)
end


for n=1:numel(num_list)
num_counts=num_list(n);   
%nthroot(counts,dimensions)
data=normrnd(0,0.5,[num_counts,dimensions]);
edges=linspace(-1,1,bins);
edges=repmat(edges,[dimensions,1]);
tic
cout=hist_sortn(data,edges(1,:)');

time_taken_sort(n)=toc;
fprintf('n= %03u time %f.2\n',num_list(n),time_taken_sort(n))
plot(num_list,time_taken_sort)
hold on
plot(num_list,time_taken)
hold off
xlabel('counts to histogram (n)')
ylabel('evaluation time (s)')
legend('my sort based histogram','histcn')
title(sprintf('bins=10^{%.1f}',log10(bins)))
pause(1e-3)
end
%%
plot(num_list,time_taken_sort)
hold on
plot(num_list,time_taken)
hold off
xlabel('counts to histogram (n)')
ylabel('evaluation time (s)')
legend('my sort based histogram','histcn')



%% b scaling
tic
dimensions=1;
num_counts=1e7;
bins_list=round(linspace(1e3,1e6,1e2));
order=randperm(numel(bins_list));
bins_list=bins_list(order);
time_taken_sort=bins_list*nan;
time_taken=bins_list*nan;
sfigure(1)
set(gcf,'color','w')
for n=1:numel(bins_list)
bins=bins_list(n);   
%nthroot(counts,dimensions)
data=normrnd(0,0.5,[num_counts,dimensions]);
edges=linspace(-1,1,bins);
edges=repmat(edges,[dimensions,1]);
tic
cout=histcn(data, edges(1,:)');
time_taken(n)=toc;
tic
cout=hist_sortn(data,edges(1,:)');
time_taken_sort(n)=toc;
fprintf('bins %03.1e time inbuilt %05.2f, mine(sort) %05.2f, ratio %.2f \n',...
    bins_list(n),time_taken(n),time_taken_sort(n),...
    time_taken(n)/time_taken_sort(n))

sfigure(1);
plot(bins_list,time_taken_sort,'xr')
hold on
plot(bins_list,time_taken,'xb')
hold off
xlabel('bins to histogram (n)')
ylabel('evaluation time (s)')
legend('my sort based histogram','histcn')
title(sprintf('bins=10^{%.1f}',log10(bins)))
pause(1e-3)
end


%%
[num_mesh,bin_mesh] = meshgrid(linspace(1e1,1e8,1e2),linspace(1e1,1e8,1e2));
bin_range=[min(bin_mesh(:)),max(bin_mesh(:))];
num_range=[min(num_mesh(:)),max(num_mesh(:))];
bin_vals=[];
num_vals=[];
time_sort=[];
time_inbuilt=[];
order=randperm(numel(time_sort));
surface_every=5;
for ii=1:10000
bin_vals(ii)=round(bin_range(1)+range(bin_range)*rand(1));
num_vals(ii)=round(num_range(1)+range(num_range)*rand(1));
bins=bin_vals(ii);   
num_counts=num_vals(ii);
%nthroot(counts,dimensions)
data=normrnd(0,0.5,[num_counts,dimensions]);
edges=linspace(-1,1,bins);
edges=repmat(edges,[dimensions,1]);
tic
histcn(data, edges(1,:)');
time_inbuilt(ii)=toc;
tic
hist_sortn(data,edges(1,:)');
time_sort(ii)=toc;
fprintf('bins %03.1e, num %03.1e, time inbuilt %05.2f, mine(sort) %05.2f, ratio %.2f \n',...
    bin_vals(ii),num_vals(ii),time_inbuilt(ii),time_sort(ii),...
    time_inbuilt(ii)/time_sort(ii))

sfigure(1);

plot3(bin_vals,num_vals,time_inbuilt,'ro')
hold on
plot3(bin_vals,num_vals,time_sort,'bo')

if mod(ii+1,5)==0
    time_inbuilt_interp = griddata(bin_vals,num_vals,time_inbuilt,bin_mesh,num_mesh);
    time_sort_interp = griddata(bin_vals,num_vals,time_sort,bin_mesh,num_mesh);
    
end

if ii>surface_every
    mesh(bin_mesh,num_mesh,time_inbuilt_interp)
    mesh(bin_mesh,num_mesh,time_sort_interp)
    
end
hold off
xlabel('Counts (n)')
xlim(bin_range)
ylim(num_range)
ylabel('Bins (b)')
zlabel('evaluation time (s)')
legend('inbuilt','mine')
pause(1e-3) 
    
end


%%
plot(bins_list,time_taken_sort)
hold on
plot(bins_list,time_taken)
hold off
xlabel('counts to histogram (n)')
ylabel('evaluation time (s)')
legend('my sort based histogram','histcn')