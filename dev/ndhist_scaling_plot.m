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
cout_sorted=histcn_search(data, edges(1,:)',edges(2,:)' );
imagesc(sum(cout_sorted,3))
sum(cout_sorted(:))

%%
cout_sorted=cout_sorted(2:end-1,2:end-1);
imagesc(sum(cout_sorted-cout_normal,3))
isequal(cout_sorted,cout_normal)



%%
tic
dimensions=3;
num_counts=1e5;
bins=1e2;
num_list=round(linspace(1e2,1e6,1e2));
time_histcn=num_list*nan;
for n=1:numel(num_list)
num_counts=num_list(n);   
%nthroot(counts,dimensions)
data=normrnd(0,0.5,[num_counts,dimensions]);
edges=linspace(-1,1,bins);
edges=repmat(edges,[dimensions,1]);
tic
cout=histcn(data, edges(1,:)',edges(2,:)',edges(3,:)' );
time_histcn(n)=toc;
fprintf('n= %03u time %f.2\n',num_list(n),time_histcn(n))
end
%imagesc(sum(cout,3))
%%
plot(num_list,time_histcn)
xlabel('counts to histogram (n)')
ylabel('evaluation time (s)')


%%
tic
dimensions=1;
num_counts=1e4;
bins=1e2;
num_list=round(linspace(1e2,1e5,1e2));
time_search=num_list*nan;


time_histcn=num_list*nan;
for n=1:numel(num_list)
num_counts=num_list(n);   
%nthroot(counts,dimensions)
data=normrnd(0,0.5,[num_counts,dimensions]);
edges=linspace(-1,1,bins);
edges=repmat(edges,[dimensions,1]);
tic
cout=histcn(data, edges(1,:)',edges(2,:)',edges(3,:)' );
time_histcn(n)=toc;
fprintf('n= %03u time %f.2\n',num_list(n),time_histcn(n))
end


for n=1:numel(num_list)
num_counts=num_list(n);   
%nthroot(counts,dimensions)
data=normrnd(0,0.5,[num_counts,dimensions]);
edges=linspace(-1,1,bins);
edges=repmat(edges,[dimensions,1]);
tic
cout=histcn_search(data, 0,edges(1,:)',edges(2,:)',edges(3,:)' );

time_search(n)=toc;
fprintf('n= %03u time %f.2\n',num_list(n),time_search(n))
end
%imagesc(sum(cout,3))



%%
%n scaling
tic
dimensions=1;
num_counts=1e2;
bins=1e5;
num_list=round(linspace(1e1,1e5,1e2));
time_search=num_list*nan;
time_histcn=num_list*nan;
time_histcn=num_list*nan;
sfigure(1)
clf
set(gcf,'color','w')
for n=1:numel(num_list)
num_counts=num_list(n);   
%nthroot(counts,dimensions)
data=normrnd(0,0.5,[num_counts,dimensions]);
edges=linspace(-1,1,bins);
edges=repmat(edges,[dimensions,1]);

tic
cout=histcn(data, edges(1,:)');
time_histcn(n)=toc;
fprintf('n= %03u time %f.2\n',num_list(n),time_histcn(n))
sfigure(1);
plot(num_list,time_search)
hold on
plot(num_list,time_histcn)
hold off
xlabel('counts to histogram (n)')
ylabel('evaluation time (s)')
legend('my sort based histogram','histcn')
title(sprintf('bins=$10^{%.1f}$',log10(bins)))
pause(1e-3)
drawnow;
end


for n=1:numel(num_list)
num_counts=num_list(n);   
%nthroot(counts,dimensions)
data=normrnd(0,0.5,[num_counts,dimensions]);
edges=linspace(-1,1,bins);
edges=repmat(edges,[dimensions,1]);
tic
cout=histcn_search(data,edges(1,:)');

time_search(n)=toc;
fprintf('n= %03u time %f.2\n',num_list(n),time_search(n))
plot(num_list,time_search)
hold on
plot(num_list,time_histcn)
hold off
xlabel('counts to histogram (n)')
ylabel('evaluation time (s)')
legend('my sort based histogram','histcn')
title(sprintf('bins=$10^{%.1f}$',log10(bins)))
pause(1e-3)
end
%%
plot(num_list,time_search)
hold on
plot(num_list,time_histcn)
hold off
xlabel('counts to histogram (n)')
ylabel('evaluation time (s)')
legend('my sort based histogram','histcn')



%% b scaling
tic
dimensions=3;
num_counts=1e3;
evaluations=1e2;
bmax=nthroot(1e9,dimensions);
bins_list=unique(round(logspace(round(log10(100)),round(log10(bmax)),evaluations)));
order=randperm(numel(bins_list));
bins_list=bins_list(order);
time_search=bins_list*nan;
time_histcn=bins_list*nan;
sfigure(1)
set(gcf,'color','w')
for n=1:numel(bins_list)
bins=bins_list(n);   
%nthroot(counts,dimensions)
data=normrnd(0,0.5,[num_counts,dimensions]);
edges={linspace(-1,1,bins)'};
edges=repmat(edges,[1,dimensions]);
tic
histcn(data, edges{:});
time_histcn(n)=toc;
tic
histcn_search(data, edges{:});
time_search(n)=toc;
fprintf('bins %03.1e time inbuilt %05.2f, mine(sort) %05.2f, ratio %.2f \n',...
    bins_list(n),time_histcn(n),time_search(n),...
    time_histcn(n)/time_search(n))

sfigure(1);
plot(bins_list,time_search,'xr')
hold on
plot(bins_list,time_histcn,'xb')
hold off
xlabel('bins to histogram (n)')
ylabel('evaluation time (s)')
legend('my sort based histogram','histcn')
title(sprintf('bins=$10^{%.1f}$',log10(bins)))
set(gca,'XScale','log','YScale','log')
pause(1e-3)
end


%%
evaluations=1e6;
dimensions=4;
lin_eval=round(nthroot(evaluations,dimensions));
nmax=3e5;
bmax=nthroot(1e9,dimensions);
num_counts_vec=unique(round(logspace(1,round(log10(nmax)),lin_eval)));
num_edges_vec=unique(round(logspace(1,round(log10(bmax)),lin_eval)));
[num_counts_mesh,num_edges_mesh] = meshgrid(num_counts_vec,num_edges_vec);
num_counts_vec=num_counts_mesh(:);
num_edges_vec=num_edges_mesh(:);
rand_order=randperm(numel(num_edges_vec));
num_counts_vec=num_counts_vec(rand_order);
num_edges_vec=num_edges_vec(rand_order);
iimax=numel(num_counts_vec);



time_inbuilt=nan*num_counts_vec;
time_sort=time_inbuilt;
order=randperm(numel(time_sort));
surface_every=5;
for ii=1:iimax

bins=num_edges_vec(ii)-1;   
num_counts=num_counts_vec(ii);
%nthroot(counts,dimensions)
data=normrnd(0,0.5,[num_counts,dimensions]);
edges={linspace(-1,1,bins)'};
edges=repmat(edges,[1,dimensions]);
tic
histcn(data, edges{:});
time_inbuilt(ii)=toc;
tic
histcn_search(data,edges{:});
time_sort(ii)=toc;
fprintf('bins %03.1e, num %03.1e, time inbuilt %05.2f, mine(sort) %05.2f, ratio %.2f \n',...
    bins,num_counts,time_inbuilt(ii),time_sort(ii),...
    time_inbuilt(ii)/time_sort(ii))

sfigure(1);

plot3(num_edges_vec-1,num_counts_vec,time_inbuilt,'ro')
hold on
plot3(num_edges_vec-1,num_counts_vec,time_sort,'bo')

if ii>surface_every
    
    time_inbuilt_interp = griddata(num_edges_vec-1,num_counts_vec,time_inbuilt,num_edges_mesh-1,num_counts_mesh);
    time_sort_interp = griddata(num_edges_vec-1,num_counts_vec,time_sort,num_edges_mesh-1,num_counts_mesh);
    
    mesh(num_edges_mesh,num_counts_mesh,time_inbuilt_interp)
    mesh(num_edges_mesh,num_counts_mesh,time_sort_interp)
end
hold off

xlabel('Bins (b)')
ylabel('Counts (n)')
set(gca, 'Zdir', 'reverse')
set(gca,'XScale','log','YScale','log','ZScale','log')
xlim([1,bmax])
ylim([1,nmax])
zlabel('evaluation time (s)')
legend('inbuilt','mine')
view(135,25)
pause(1e-3) 
    
end


%%
plot(bins_list,time_search)
hold on
plot(bins_list,time_histcn)
hold off
xlabel('counts to histogram (n)')
ylabel('evaluation time (s)')
legend('my sort based histogram','histcn')




%%
%%

evaluations=1e3;
dimensions=4;
lin_eval=round(nthroot(evaluations,dimensions));
nmax=3e5;
bmax=nthroot(1e9,dimensions);
update_interval=5;

lin_eval=round(sqrt(evaluations));
evaluations=lin_eval.^2     ;
num_counts_vec=unique(round(logspace(1,round(log10(nmax)),lin_eval)));
num_edges_vec=unique(round(logspace(1,round(log10(bmax)),lin_eval)));
[num_counts_mesh,num_edges_mesh] = meshgrid(num_counts_vec,num_edges_vec);
num_counts_vec=num_counts_mesh(:);
num_edges_vec=num_edges_mesh(:);
rand_order=randperm(numel(num_edges_vec));
num_counts_vec=num_counts_vec(rand_order);
num_edges_vec=num_edges_vec(rand_order);

num_counts_query=num_counts_mesh;
num_edges_query=num_edges_mesh;

iimax=numel(num_counts_mesh);
%sort,inbuilt,bin_search,counts_search
runtimes=nan(iimax,4);

last_update=posixtime(datetime('now')); %time for updating plots every few seconds

sfigure(2);
clf
set(gcf,'color','w')
set(gcf, 'Units', 'pixels', 'Position', [100, 100, 1600, 900])

surface_colors= prism(5);
surface_colors= surface_colors([1,4],:);

fprintf('  \n%04u:%04u',iimax,0) 
for ii=1:iimax
    fprintf('\b\b\b\b%04u',ii)
    bins=num_edges_vec(ii)-1;   
    num_counts=num_counts_vec(ii);
    %nthroot(counts,dimensions)
    data=normrnd(0,0.5,[num_counts,dimensions]);
    edges={linspace(-1,1,bins)'};
    edges=repmat(edges,[1,dimensions]);
    
    tic
    histcn(data, edges{:});
    runtimes(ii,1)=toc;
    tic
    histcn_search(data,edges{:});
    runtimes(ii,2)=toc;
    

    ptime=posixtime(datetime('now'));
    if ptime-last_update>update_interval && ii>30 || ii==iimax
        %TODO: clean this up, so much repeated code
        %matlab inbuilt histcounts(edges)
        f_interp= scatteredInterpolant(num_counts_vec(1:ii),...
            num_edges_vec(1:ii),runtimes(1:ii,1));
        time_histcn =f_interp(num_counts_query,num_edges_query);
        %matlab inbuilt histcounts(nbins)
        f_interp= scatteredInterpolant(num_counts_vec(1:ii),...
            num_edges_vec(1:ii),runtimes(1:ii,2));
        time_search =f_interp(num_counts_query,num_edges_query);
        surface_alpha=0.8;
        sfigure(1);
        surf(num_counts_query,num_edges_query,time_histcn,'FaceAlpha',surface_alpha,'FaceColor', surface_colors(1,:))
        hold on
        surf(num_counts_query,num_edges_query,time_search,'FaceAlpha',surface_alpha,'FaceColor', surface_colors(2,:))
        
        hold off
        legend('histcn','search')
        set(gca,'XScale','log','YScale','log','ZScale','log')
        set(gca, 'Zdir', 'reverse')
        xlabel('num data n')
        ylabel('num bins m')
        zlabel('runtime (s)')
        view(135,25)
        pause(1e-6)
        last_update=ptime;
        fprintf('\n%04u',0) 
    end
end
figure(1)
fprintf('\n') 

saveas(gcf,fullfile('nd_hist_scaling_comparison_raw.png'))

%%
query_points=1e2;
num_counts_query_vec=unique(round(logspace(1,round(log10(nmax)),query_points)));
num_edges_query_vec=unique(round(logspace(1,round(log10(bmax)),query_points)));
[num_counts_query_mesh,num_edges_query_mesh] = meshgrid(num_counts_query_vec,num_edges_query_vec);
%num_counts_query_vec=num_counts_query_mesh(:);
%num_edges_query_vec=num_edges_query_mesh(:);

Smoothness = 0.001;
%GridFit with bicubic interpolation. 
time_histcn = RegularizeData3D(...
                        log10(num_counts_vec),...
                        log10(num_edges_vec),...
                        log10(runtimes(1:ii,1)),...
                        log10(num_counts_query_vec),...
                        log10(num_edges_query_vec),...
                        'interp', 'bicubic', 'smoothness', Smoothness);
time_histcn=10.^(time_histcn);


time_search = RegularizeData3D(...
                        log10(num_counts_vec),...
                        log10(num_edges_vec),...
                        log10(runtimes(1:ii,2)),...
                        log10(num_counts_query_vec),...
                        log10(num_edges_query_vec),...
                        'interp', 'bicubic', 'smoothness', Smoothness);
time_search=10.^(time_search);


sfigure(3);
clf
set(gcf,'color','w')
set(gcf, 'Units', 'pixels', 'Position', [100, 100, 1600, 900])
hold on
alpha=1;
surf(num_counts_query_mesh,num_edges_query_mesh,time_histcn,'FaceAlpha',alpha,'FaceColor', surface_colors(1,:))

surf(num_counts_query_mesh,num_edges_query_mesh,time_search,'FaceAlpha',alpha,'FaceColor', surface_colors(2,:))
%scatter3(num_counts_vec,num_edges_vec,runtimes(:,2), 'xr');
%scatter3(num_counts_vec,num_edges_vec,runtimes(:,3), 'xg');
%scatter3(num_counts_vec,num_edges_vec,runtimes(:,3)+runtimes(:,1), 'xb');
%scatter3(num_counts_vec,num_edges_vec,runtimes(:,4)+runtimes(:,1), 'xm');
hold off
legend('histcn','search')
set(gca,'XScale','log','YScale','log','ZScale','log')
set(gca, 'Zdir', 'reverse')
xlabel('num data n')
ylabel('num bins m')
zlabel('runtime (s)')
view(135,25)
pause(1e-6)

%saveas(gcf,fullfile('figs','scaling_comparison_smooth.png'))
