

%% single dimension histogram
%%
dimensions=1;
num_counts=1e5;
bins=1e2;

%nthroot(counts,dimensions)
data=normrnd(0,0.5,[num_counts,dimensions]);
edges=linspace(-1,1,bins);
edges=repmat(edges,[dimensions,1]);
cout=histcn(data, edges(1,:)');
sum(cout(:))
plot(sum(cout,3))

%% with the search algo
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
%% try with the search algo
clear('count');
cout_sorted=histcn_search(data, edges(1,:)',edges(2,:)' );
cout_sorted=cout_sorted(2:end-1,2:end-1);
imagesc(sum(cout_sorted,3))
sum(cout_sorted(:))

%% hist_sortn
clear('count');
cout_sorted=hist_sortn(data, edges(1,:)',edges(2,:)' );
imagesc(sum(cout_sorted,3))
sum(cout_sorted(:))


%% difference
imagesc(sum(cout_sorted-cout_normal,3))
% does the search algo give the same answer
isequal(cout_sorted,cout_normal)





%%
%count scaling

% as expected for 1d my algo outperforms when counts<<bins and then has the same scaling as histcn at higher
% bin numbers with some constant factor offset
% similar performance at higher dimensions

tic
dimensions=3;
num_bins=nthroot(1e3,dimensions);
evaluations=1e2;
counts_min=1e5;
counts_max=1e8;
num_counts_list=unique(round(logspace(round(log10(counts_min)),round(log10(counts_max)),evaluations)));
order=randperm(numel(num_counts_list));
num_counts_list=num_counts_list(order);
time_search=num_counts_list*nan;
time_histcn=num_counts_list*nan;
sfigure(1)
set(gcf,'color','w')
for ii=1:numel(num_counts_list)
data=normrnd(0,0.5,[num_counts_list(ii),dimensions]);
% make sure the upp and lower inf is inculded
edges={[-inf,linspace(-1,1,num_bins+1),inf]'};
edges=repmat(edges,[1,dimensions]);
out_histcn=zeros(repmat(bins+2,[1,dimensions]));
out_histcn_search=out_histcn;
pause(0.1)
tic
out_histcn=histcn(data, edges{:});
time_histcn(ii)=toc;
edges={linspace(-1,1,num_bins+1)'};
edges=repmat(edges,[1,dimensions]);
pause(0.1)
tic
%out_histcn_search=histcn_search(data, edges{:});
out_histcn_search=hist_sortn(data, edges{:});
time_search(ii)=toc;

% if ~(isequal(out_histcn,out_histcn_search))
%     error('outputs not equal')
% end

fprintf('bins %03.1e time inbuilt %05.2f ms, mine(sort) %05.2f ms, ratio %.2f \n',...
    num_counts_list(ii),time_histcn(ii)*1e3,time_search(ii)*1e3,...
    time_histcn(ii)/time_search(ii))


sfigure(1);
plot(num_counts_list,time_search,'xr')
hold on
plot(num_counts_list,time_histcn,'xb')
hold off
xlabel('counts to histogram (n)')
ylabel('evaluation time (s)')
legend('my sort based histogram','histcn')
title(sprintf('bins=$10^{%.1f}$',log10(num_bins)))
set(gca,'XScale','log','YScale','log')
pause(1e-3)
end




%% bin scaling

%for 1d this is what i expect, a linear scaling of histcn and a sublinear for the search algo
% for higher dim they converge to the execution time of creating the output array with accumarray 


tic
dimensions=3;
num_counts=1e2;
evaluations=1e2;
bmax=nthroot(5e6,dimensions);
num_bins_list=unique(round(logspace(round(log10(5)),round(log10(bmax)),evaluations)));
order=randperm(numel(num_bins_list));
num_bins_list=num_bins_list(order);
time_search=num_bins_list*nan;
time_histcn=num_bins_list*nan;
sfigure(1)
clf
set(gcf,'color','w')
for ii=1:numel(num_bins_list)
bins=num_bins_list(ii);   
data=normrnd(0,0.5,[num_counts,dimensions]);
% make sure the upp and lower inf is inculded
clear out_histcn
clear out_histcn_search


edges={[-inf,linspace(-1,1,bins+1),inf]'};
edges=repmat(edges,[1,dimensions]);
pause(0.1)
tic
out_histcn=histcn(data, edges{:});
tmp=toc;
time_histcn(ii)=tmp;
edges={linspace(-1,1,bins+1)'};
edges=repmat(edges,[1,dimensions]);
pause(0.1)
tic
out_histcn_search=histcn_search(data, edges{:});
tmp=toc;
time_search(ii)=tmp;

if ~isequal(size(out_histcn),size(out_histcn_search)) || ~isequal(out_histcn,out_histcn_search)
    error('outputs not equal')
end

fprintf('bins %03.1e time inbuilt %05.2f ms, mine(sort) %05.2f ms, ratio %.2f \n',...
    num_bins_list(ii),time_histcn(ii)*1e3,time_search(ii)*1e3,...
    time_histcn(ii)/time_search(ii))

sfigure(1);
plot(num_bins_list,time_search,'xr')
hold on
plot(num_bins_list,time_histcn,'xb')
hold off
xlabel('bins to histogram (n)')
ylabel('evaluation time (s)')
legend('my search based histogram','histcn')
title(sprintf('counts=$10^{%.1f}$',log10(num_counts)))
set(gca,'XScale','log','YScale','log')
%set(gca,'XScale','linear','YScale','linear')
pause(1e-3)
end

%% code scrap for diagnosing xover
bins=4e4;   
num_counts=1e2;
dimensions=4;
data=normrnd(0,0.5,[num_counts,dimensions]);
% make sure the upp and lower inf is inculded
edges={[-inf,linspace(-1,1,bins+1),inf]'};
edges=repmat(edges,[1,dimensions]);
pause(0.1)

tic
out_histcn=histcn(data, edges{:});
toc;
edges={linspace(-1,1,bins+1)'};
edges=repmat(edges,[1,dimensions]);
pause(0.1)
tic
out_histcn_search=histcn_search(data, edges{:});
toc;

if ~isequal(size(out_histcn),size(out_histcn_search)) || ~isequal(out_histcn,out_histcn_search)
    error('outputs not equal')
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
plot(num_counts_list,time_search)
hold on
plot(num_counts_list,time_histcn)
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
