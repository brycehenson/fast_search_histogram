%comparing scaling of matlabs inbuilt histogram to a sort based method

%% get the basic case working
data=rand(1e5,1)*2-1; %centered at zero, interval=2)
edges=linspace(-2,2,1e2);
bin_counts=histcounts(data,edges);
bin_centers=(edges(2:end)+edges(1:end-1))*0.5;

plot(bin_centers,bin_counts)
xlabel('bin center')
ylabel('counts')

%% investigate the scaling of the matlab inbuilt with the aomount of data

num_counts_vec=round(logspace(1,7,400));
edges=linspace(0,1,1e3);
bin_centers=(edges(2:end)+edges(1:end-1))*0.5;
iimax=numel(num_counts_vec);
runtime=nan(iimax,3);
last_update=posixtime(datetime('now')); %time for updating plots every few seconds

sfigure(1);
clf
set(gcf,'color','w')
set(gcf, 'Units', 'pixels', 'Position', [100, 100, 1600, 900])

fprintf('  \n%03u',0) 
for ii=1:iimax
fprintf('\b\b\b%03u',ii)  
data=rand(num_counts_vec(ii),1); %centered at zero, interval=2)
tic
bin_counts=histcounts(data,edges);
runtime(ii)=toc;
ptime=posixtime(datetime('now'));

if ptime-last_update>2 || ii==iimax
    sfigure(1);
    loglog(num_counts_vec,runtime,'k') 
    xlabel('num data (n)')
    ylabel('runtime (s)')
    title(sprintf('Scaling with 10^{%.1f} bins',log10(numel(edges)-1)))
    pause(1e-6)
    last_update=ptime;
end

end
figure(1)
fprintf('\n') 

saveas(gcf,fullfile('dev','matlab_inbuilt_ndata_scaling.png'))



%%

num_edges_vec=round(logspace(1,7,400));
data=rand(1e6,1); %centered at zero, interval=2)


iimax=numel(num_edges_vec);
runtime=nan(iimax,3);
last_update=posixtime(datetime('now')); %time for updating plots every few seconds

sfigure(1);
clf
set(gcf,'color','w')
set(gcf, 'Units', 'pixels', 'Position', [100, 100, 1600, 900])

fprintf('  \n%03u',0) 
for ii=1:iimax
fprintf('\b\b\b%03u',ii)  
edges=linspace(0,1,num_edges_vec(ii));

tic
bin_counts=histcounts(data,edges);
%bin_centers=(edges(2:end)+edges(1:end-1))*0.5; %no need to compute

runtime(ii)=toc;
ptime=posixtime(datetime('now'));

if ptime-last_update>2 || ii==iimax
    sfigure(1);
    loglog(num_edges_vec-1,runtime,'k') 
    xlabel('num bins (m)')
    ylabel('runtime (s)')
     title(sprintf('Scaling with 10^{%.1f} data pts',log10(numel(data))))
    pause(1e-6)
    last_update=ptime;
end

end
figure(1)
fprintf('\n') 

saveas(gcf,fullfile('dev','matlab_inbuilt_mbins_scaling.png'))


%%
sfigure(2)
plot(num_edges_vec,runtime) 

%% ok so it looks like matlab does things a pretty brutish way and has O(n�m) scaling
% we can beat that !!
% there are two algorithms that can be employed
% 1. Bin search O( n log(m) )
%    - for each count do a binary search for the apropriate bin
% 2. Count search O( n�log(n)+m�log(n) ) 
%    - sort the data
%    - for each bin edge find the nearest data point, use the difference in
%    indicies to give the bin count
% bin search seems better in most cases as there is not the sort overhead

%% bin search basic test
edges=linspace(1,10,10)';
data=[1.0]';
fprintf('edges   %s\n',sprintf('%.1f  ',edges))
out_full=bin_search_hist(data,edges);
fprintf('out1  %s\n',sprintf('%d    ',out1'))
out1_cut=out_full(2:end-1)';
out2=histcounts(data,edges);
fprintf('out2       %s\n',sprintf('%d    ',out2))
logic_str={'FAIL','pass'};
fprintf('equality testing : %s\n',logic_str{isequal(out1_cut,out2)+1})


%% count search basic

edges=linspace(1,10,10)';
%data=[linspace(2.2,2.8,5),linspace(1.1,1.2,3)]';
data=[3.9,6,7]';
iscolumn(data)
data=sort(data);
fprintf('edges    %s\n',sprintf('%.1f   ',edges))
out_full=count_search_hist(data,edges);
fprintf('out1  %s\n',sprintf('%02d    ',out_full'))
out1_cut=out_full(2:end-1)';
out2=histcounts(data,edges);
fprintf('out2        %s\n',sprintf('%02d    ',out2))
logic_str={'FAIL','pass'};
fprintf('equality testing : %s\n',logic_str{isequal(out1_cut,out2)+1})



%% randomized equality testing

data=rand(1e5,1);
data=sort(data);
edges=linspace(0.1,1.1,1e6)';
tic
out_full=bin_search_hist(data,edges);
time_bin_search=toc;
fprintf('time bin search hist = %.2fms\n',time_bin_search*1e3)
out1_cut=out_full(2:end-1)';

tic
out_full=count_search_hist(data,edges);
time_count_search=toc;
fprintf('time count search hist = %.2fms\n',time_count_search*1e3)
out2_cut=out_full(2:end-1)';

tic
out3=histcounts(data,edges);
time_inbuilt=toc;
fprintf('time  inbuilt        = %.2fms\n',time_inbuilt*1e3)
fprintf('speedup matlab/bin_search= %.1f \n',time_inbuilt/time_bin_search)
fprintf('speedup matlab/count_search= %.1f \n',time_inbuilt/time_count_search)
logic_str={'FAIL','pass'};
fprintf('equality testing matlab=bin_search   : %s\n',logic_str{isequal(out1_cut,out3)+1})
fprintf('equality testing matlab=count_search : %s\n',logic_str{isequal(out2_cut,out3)+1})
fprintf('Speedup test   bin_search            : %s \n',logic_str{(time_bin_search<time_inbuilt)+1})
fprintf('Speedup test   count_search          : %s \n',logic_str{(time_count_search<time_inbuilt)+1})


%%
evaluations=5e3;
update_interval=10; %seconds between plot updates

lin_eval=round(sqrt(evaluations));
evaluations=lin_eval.^2
num_counts_vec=round(logspace(1,7,lin_eval));
num_edges_vec=round(logspace(1,7,lin_eval));
[num_counts_mesh,num_edges_mesh] = meshgrid(num_counts_vec,num_edges_vec);
num_counts_vec=num_counts_mesh(:);
num_edges_vec=num_edges_mesh(:);

%where to query
num_counts_query_vec=logspace(log10(min(num_counts_vec)),log10(max(num_counts_vec)),100);
num_edges_query_vec=logspace(log10(min(num_counts_vec)),log10(max(num_counts_vec)),100);
[num_counts_query,num_edges_query] = meshgrid(...
    num_counts_query_vec,...
    num_edges_query_vec);

rand_order=randperm(numel(num_edges_vec));
num_counts_vec=num_counts_vec(rand_order);
num_edges_vec=num_edges_vec(rand_order);

iimax=numel(num_counts_mesh);
%sort,inbuilt,bin_search,counts_search
runtimes=nan(iimax,4);

last_update=posixtime(datetime('now')); %time for updating plots every few seconds

sfigure(1);
clf
set(gcf,'color','w')
set(gcf, 'Units', 'pixels', 'Position', [100, 100, 1600, 900])

fprintf('  \n%04u:%04u',iimax,0) 
for ii=1:iimax
    fprintf('\b\b\b\b%04u',ii)
    data=rand(num_counts_vec(ii),1);
    tic
    data=sort(data);
    temp_time=toc;
    runtimes(ii,1)=temp_time;
    
    edges=linspace(0,1,num_edges_vec(ii))';
    tic
    out3=histcounts(data,edges);
    temp_time=toc;
    runtimes(ii,2)=temp_time;

    tic
    out_full=bin_search_hist(data,edges);
    temp_time=toc;
    runtimes(ii,3)=temp_time;
    out1_cut=out_full(2:end-1)';

    tic
    out_full=count_search_hist(data,edges);
    temp_time=toc;
    runtimes(ii,4)=temp_time;
    out2_cut=out_full(2:end-1)';

    ptime=posixtime(datetime('now'));
    if ptime-last_update>update_interval || ii==iimax
        f= scatteredInterpolant(num_counts_vec(1:ii),...
            num_edges_vec(1:ii),runtimes(1:ii,2));
        time_inbuilt_interp =f(num_counts_query,num_edges_query);
        %search method with ordered data
        f= scatteredInterpolant(num_counts_vec(1:ii),...
            num_edges_vec(1:ii),runtimes(1:ii,4));
        time_ocsearch_interp=f(num_counts_query,num_edges_query);
        %search method with unordered data
        f= scatteredInterpolant(num_counts_vec(1:ii),...
            num_edges_vec(1:ii),runtimes(1:ii,4)+runtimes(1:ii,1));
        time_ucsearch_interp=f(num_counts_query,num_edges_query);
        f = scatteredInterpolant(num_counts_vec(1:ii),...
            num_edges_vec(1:ii),runtimes(1:ii,3));
        time_bsearch_interp=f(num_counts_query,num_edges_query);
        
        sfigure(1);
        surf(num_counts_query,num_edges_query,time_inbuilt_interp,'FaceAlpha',0.5,'FaceColor','r')
        hold on
        surf(num_counts_query,num_edges_query,time_ocsearch_interp,'FaceAlpha',0.5,'FaceColor','g')
        surf(num_counts_query,num_edges_query,time_ucsearch_interp,'FaceAlpha',0.5,'FaceColor','b')
        surf(num_counts_query,num_edges_query,time_bsearch_interp,'FaceAlpha',0.5,'FaceColor','m')
        hold off
        legend('inbuilt','ordered count search','unordered count search','bin search')
        set(gca,'XScale','log','YScale','log','ZScale','log')
        set(gca, 'Zdir', 'reverse')
        xlabel('num data n')
        ylabel('num bins m')
        zlabel('runtime (s)')
        pause(1e-6)
        last_update=ptime;
        fprintf('\n%04u',0) 
    end
end
figure(1)
fprintf('\n') 

saveas(gcf,fullfile('dev','matlab_inbuilt_mbins_scaling.png'))


%%
Smoothness = 0.0004;
%GridFit with bicubic interpolation. 
time_inbuilt_interp = RegularizeData3D(...
                        log10(num_counts_vec),...
                        log10(num_edges_vec),...
                        log10(runtimes(1:ii,2)),...
                        log10(num_counts_query_vec),...
                        log10(num_edges_query_vec),...
                        'interp', 'bicubic', 'smoothness', Smoothness);
time_inbuilt_interp=10.^(time_inbuilt_interp);
%search method with ordered data
time_ocsearch_interp = RegularizeData3D(...
                        log10(num_counts_vec),...
                        log10(num_edges_vec),...
                        log10(runtimes(1:ii,4)),...
                        log10(num_counts_query_vec),...
                        log10(num_edges_query_vec),...
                        'interp', 'bicubic', 'smoothness', Smoothness);
time_ocsearch_interp=10.^(time_ocsearch_interp);                    
%search method with unordered data
time_ucsearch_interp = RegularizeData3D(...
                        log10(num_counts_vec),...
                        log10(num_edges_vec),...
                        log10(runtimes(1:ii,4)+runtimes(1:ii,1)),...
                        log10(num_counts_query_vec),...
                        log10(num_edges_query_vec),...
                        'interp', 'bicubic', 'smoothness', Smoothness);
time_ucsearch_interp=10.^(time_ucsearch_interp);                    
time_bsearch_interp = RegularizeData3D(...
                        log10(num_counts_vec),...
                        log10(num_edges_vec),...
                        log10(runtimes(1:ii,3)),...
                        log10(num_counts_query_vec),...
                        log10(num_edges_query_vec),...
                        'interp', 'bicubic', 'smoothness', Smoothness);
time_bsearch_interp=10.^(time_bsearch_interp);                    
sfigure(3);
hold on
surf(num_counts_query,num_edges_query,time_inbuilt_interp,'FaceAlpha',0.5,'FaceColor','r')
surf(num_counts_query,num_edges_query,time_ocsearch_interp,'FaceAlpha',0.5,'FaceColor','g')
surf(num_counts_query,num_edges_query,time_ucsearch_interp,'FaceAlpha',0.5,'FaceColor','b')
surf(num_counts_query,num_edges_query,time_bsearch_interp,'FaceAlpha',0.5,'FaceColor','m')
scatter3(num_counts_vec,num_edges_vec,runtimes(:,2), 'xr');
scatter3(num_counts_vec,num_edges_vec,runtimes(:,3), 'xg');
scatter3(num_counts_vec,num_edges_vec,runtimes(:,3)+runtimes(:,1), 'xb');
scatter3(num_counts_vec,num_edges_vec,runtimes(:,4)+runtimes(:,1), 'xm');
hold off
legend('inbuilt','ordered count search','unordered count search','bin search')
set(gca,'XScale','log','YScale','log','ZScale','log')
set(gca, 'Zdir', 'reverse')
xlabel('num data n')
ylabel('num bins m')
zlabel('runtime (s)')
pause(1e-6)
last_update=ptime;



%% speedup plots
sfigure(4);
set(gcf,'color','w')
set(gcf, 'Units', 'pixels', 'Position', [100, 100, 1500, 500])
subplot(1,4,1)
was_one_of_mine_faster=min(cat(3,time_ocsearch_interp,time_bsearch_interp),[],3)<time_inbuilt_interp;
imagesc(num_counts_vec,num_edges_vec,was_one_of_mine_faster)
title('any search method  better?')
colormap('gray')
set(gca,'YDir','normal')
ylabel('num edges m')
xlabel('num counts n')

subplot(1,4,2);
model=@(n) real(sqrt((4e6).^2 -(n.^2)));
%was count search faster
was_ucsearch_faster=time_ucsearch_interp<time_inbuilt_interp;
imagesc(num_counts_vec,num_edges_vec,was_ucsearch_faster)
hold on
plot(num_counts_vec,model(num_counts_vec),'rx')
title('sort+ordered count search better?')
colormap('gray')
set(gca,'YDir','normal')
xlabel('num counts n')

subplot(1,4,3);
%was count search faster
was_ocsearch_faster=time_ocsearch_interp<time_inbuilt_interp;
imagesc(num_counts_vec,num_edges_vec,was_ocsearch_faster)
title('ordered count search better?')
colormap('gray')
set(gca,'YDir','normal')
xlabel('num counts n')

subplot(1,4,4);
was_bsearch_faster=time_bsearch_interp<time_inbuilt_interp;
imagesc(num_counts_vec,num_edges_vec,was_bsearch_faster)
title('bin search better?')
colormap('gray')
set(gca,'YDir','normal')
xlabel('num counts n')
%%
sfigure(5);
min_seach_methods=min(cat(3,time_ocsearch_interp,time_ucsearch_interp,...
    time_bsearch_interp),[],3);
speedup_factor=time_inbuilt_interp./min_seach_methods;
colormap(viridis())
surf(num_counts_query,num_edges_query,speedup_factor,'FaceAlpha',0.5) %,'FaceColor','r'

set(gca,'XScale','log','YScale','log','ZScale','log')
%set(gca, 'Zdir', 'reverse')
title('speedup relative to inbuilt')
xlabel('num data n')
ylabel('num bins m')
zlabel('speedup ')
pause(1e-6)


%%
hold on
%surf(,,'FaceAlpha',0.5,'FaceColor','r')
%surf(num_counts_query,num_edges_query,10.^(),'FaceAlpha',0.5,'FaceColor','g')
surf(num_counts_query,num_edges_query,10.^(time_ucsearch_interp),'FaceAlpha',0.5,'FaceColor','b')
surf(num_counts_query,num_edges_query,10.^(time_bsearch_interp),'FaceAlpha',0.5,'FaceColor','m')
scatter3(num_counts_vec,num_edges_vec,runtimes(1:ii,2), 'xr');
scatter3(num_counts_vec,num_edges_vec,runtimes(1:ii,3), 'xg');
scatter3(num_counts_vec,num_edges_vec,runtimes(1:ii,3)+runtimes(1:ii,1), 'xb');
scatter3(num_counts_vec,num_edges_vec,runtimes(1:ii,4)+runtimes(1:ii,1), 'xm');
hold off
legend('inbuilt','ordered count search','unordered count search','bin search')
set(gca,'XScale','log','YScale','log','ZScale','log')
set(gca, 'Zdir', 'reverse')
xlabel('num data n')
ylabel('num bins m')
zlabel('runtime (s)')
pause(1e-6)
last_update=ptime;





