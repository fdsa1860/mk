function [WW W_est Wud ConnectionStr A]=sum_of_regressors_distributed_x_v2inf_2D(Wx,n,lamda,epsilon,ConnectionStrtrue)

% % this function solves the following optimization problem
% % sum(norm(Wx(:,j),2)+lamda*norm(firsorderdiff(u),1)
% % st. norm(xd-[Xd eye(size(Xd,1))]*[ad;ud],inf)<=epsilon
% % for all xd which is a column of Wx
% % here Xd is the basis constructed using columns of Wx
% % if for example order of the assumed underlying ARs are 2
% % first 3 columns of Xd is length of the signal-3*3 hankel consttucted
% % from the first column of Wx, then the second 3 column pair is the
% % similar hankel constructed from 2nd column of Wx so on and so forth
% % ud is the optimization variable that we want to be first order
% % difference sparse, rare exogenous events 
% % here WW is the valid part of Wx means for example if the order is 3
% % first two entry of all time series are only used for initial points so
% % these are excluded
% % W_est is the estimated WW, which is for example the first column of W_est
% % is as a linear combinations of the other nodes with a time delay allowed
% % by order to approximate the first column of WW as much as possible
% % if the correctstucture is
% % supplied then positive predictive value and sensitivity are also
% % calculated written by mustafa ayazoglu-2012


W=Wx(1:n,:);
Wu=Wx(n+1:end,:);


nodes = size(W,2);
assert(mod(size(W,1),2)==0);
frames = size(W,1)/2;
order=2;

XCindex=toeplitz([2*(order+1):2:2*frames],[order+1:-1:1]);

Xindex=XCindex(:,1:end);
xindex=XCindex(:,1);

x=[];
Xr=[];
for(node=1:nodes)
    data=W(:,node);
    x=[x;data(xindex)];
    Xr=[Xr, data(Xindex)];
end


%%removing self loops
a=[];
for(node=1:nodes)
    data=W(:,node);
    xd=data(xindex);
    Xd=Xr;
    Xd(:,(node-1)*(order+1)+1:(node-1)*(order+1)+(order+1))=0;
    
    last_optval=0;
    curr_optval=10;

    a1=Xd\xd;

%case 1 term0 and term2 min term1 unknown
term0_1=norm(xd-Xd*a1,2);

regs=reshape(a1,(order+1),nodes);
term1_1=sum(norms(regs,2));

term2_1=0;

%case 2 term1 zero term0 zero term2 u becomes the node itself
term1_2=0;

term0_2=0;

term2_2=sum(sum(abs(xd(1:end-1)-xd(2:end))));

lamda1=1;%lamda;
%lamda2=(term0_1+lamda1*term1_1)/term2_2;
lamda2=lamda;%(lamda1*term1_1)/term2_2;
perc=0.5;
percent=perc;
lambdav=(1-percent)*2*lamda1;
lambda=lambdav*ones(1,nodes);
lambdavud=percent*2*lamda2;
lambdaud=lambdavud*ones(size(Xd,1)-1,1);

    
    %while(abs(last_optval-curr_optval)>=0.01) 
    for(kkk=1)
        cvx_begin;
    cvx_solver sdpt3;
    %cvx_solver sedumi;

    variable ad(nodes*(order+1),1);
    variable ud(size(Xd,1),1);

    regs=reshape(ad,(order+1),nodes);
    regnorm=0;
    
    if((order+1)>=2)
        regnorm=sum((lambda).*norms(regs,2));
    else
        regnorm=sum((lambda).*abs(regs));
    end
        
    objective=regnorm+norm(lambdaud.*(ud(1:end-1)-ud(2:end)),1);
    norm(xd-[Xd eye(size(Xd,1))]*[ad;ud],inf)<=epsilon;
    minimize(objective);
    cvx_end;
    
    
    
    if((order+1)>=2)
    regnorm=norms(regs,2);
    else
        regnorm=abs(regs);
    end
    
    lambda=(1./(regnorm+1e-2));

    %%this portion does the reweighted heuristic
    lambda=lambdav*nodes*lambda/sum(lambda);
    lambdaud=(1./(abs((ud(1:end-1)-ud(2:end)))+1e-2));
    lambdaud=lambdavud*size(Xd,1)*lambdaud/sum(lambdaud);

    last_optval=curr_optval;
    curr_optval=cvx_optval;
    
    
    end
    
    a=[a;ad]; 
    
    Wud(:,node)=ud;
    
end

X=kron(eye(nodes),Xr);

x_est=X*a;
W_est=reshape(x_est,length(xindex),nodes);
WW=reshape(x,length(xindex),nodes);


A=reshape(a,nodes*(order+1),nodes); %%systems connecting the other systems to i'th system on i'th column the ar coefficients

regs=reshape(a,(order+1),nodes*nodes);
regnorm=sqrt(sum(regs.*regs,1));

%%%ConnectionStr(i,j) shows the ith node is connected to node jth with an
%%%ar and the 2 norm of this ar coefficients are given by ConnectionStr(i,j)
ConnectionStr=reshape(regnorm,nodes,nodes); 
55;

% uncomment this if you are supplying ConnectionStrtrue
% TPu=sum(sum(((ConnectionStrtrue+ConnectionStrtrue')>0).*(((ConnectionStr>0.01)+(ConnectionStr>0.01)')>0)));
% Pesu=sum(sum(((ConnectionStrtrue+ConnectionStrtrue')>0)));
% Pgtu=sum(sum(((ConnectionStr>0.01)+(ConnectionStr>0.01)')>0));
% 
% TPd=sum(sum(((ConnectionStrtrue+ConnectionStrtrue)>0).*(((ConnectionStr>0.01)+(ConnectionStr>0.01))>0)));
% Pesd=sum(sum(((ConnectionStrtrue+ConnectionStrtrue)>0)));
% Pgtd=sum(sum(((ConnectionStr>0.01)+(ConnectionStr>0.01))>0));
% 
% PPVu=TPu/(Pgtu);
% SEu=TPu/(Pesu);
% 
% PPVd=TPd/(Pgtd);
% SEd=TPd/(Pesd);
 55;

