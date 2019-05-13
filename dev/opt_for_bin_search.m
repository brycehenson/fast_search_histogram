% - try basic search reduction in Bin Search
%    - compare count with last value to search only edges above or below that.
%    - NO improvement for counts in the middle log2(n)/(log2(n/2)+1) =~1 
%    - because for uniform dist there is an equal chance of a n(1-x) or nx counts then the weighted evaluation time 1/2 ((Log[numc*x] + 1) + (Log[numc*(1 - x)] + 1)) whcih must be integerated over the distrubution
%    - trying to evaluate that expresison is fucked

unit_hat=@(x) double(x<1 & x>0);
dist_un=@(x) unit_hat(x);
dist_un=@(x) exp(-((x-0.5)./0.25).^2);
dist_un(0.2)
sumdist=integral(dist_un,-inf,inf,'RelTol',1e-4)
dist=@(x) dist_un(x)/sumdist;
dist(0.2)
intup=@(x) arrayfun(@(y) integral(dist,y,inf,'RelTol',1e-4,'AbsTol',1e-6),x);
intdown=@(x) arrayfun(@(y) integral(dist,-inf,y,'RelTol',1e-4,'AbsTol',1e-6),x);
intup(0.5)
intdown(0.5)
plot(dist(linspace(0,1,1e3)));

%%
ncounts=1e3;
rel_eval_time=@(x) dist(x).*0.5.*((log2(ncounts.*intup(x))+1)+(log2(ncounts.*intdown(x))+1))./log2(ncounts);
%rel_eval_time(0.9999)
dx=1e-3;
integral(rel_eval_time,dx,1-dx,'ArrayValued',0)

