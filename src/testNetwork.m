
% function testNetwork
clear;
addpath(genpath('C:\zxk\Research\CDC_2011_NETWORK_ID_CODES'));

Wmonkey = convertVbbData;
first = 1;
last = 100;
Wmonkey = Wmonkey(first:last,1:5);
Wmonkeyxy = [Wmonkey(1:2:end,:);Wmonkey(2:2:end,:)];
n = size(Wmonkey,1);
% Wmonkeyx = Wmonkey(1:2:end,:);
% Wmonkeyy = Wmonkey(2:2:end,:);
% n = size(Wmonkey,1)/2;
% lambda = [0.5 1 3 5 10];
% epsilon = [0.4 0.5 0.6 0.8 1];
lambda = 30000;
epsilon = 0.5;
order = 2;
for li = 1:length(lambda)
    for ei = 1:length(epsilon)
        [WW_xy(:,:,li,ei) W_est_xy(:,:,li,ei) Wud_xy(:,:,li,ei) ConnectionStr(:,:,li,ei) A]=...
            sum_of_regressors_distributed_x_v2inf(Wmonkeyxy,n,lambda(li),epsilon(ei));
%         [WW_x(:,:,li,ei) W_est_x(:,:,li,ei) Wud_x(:,:,li,ei) ConnectionStrx(:,:,li,ei)]=...
%             sum_of_regressors_distributed_x_v2inf(Wmonkeyx,n,lambda(li),epsilon(ei));
%         [WW_y(:,:,li,ei) W_est_y(:,:,li,ei) Wud_y(:,:,li,ei) ConnectionStry(:,:,li,ei)]=...
%             sum_of_regressors_distributed_x_v2inf(Wmonkeyy,n,lambda(li),epsilon(ei));
    end
end
% WW_est_xy = W_est_xy+Wud_xy;
WW_est_xy = W_est_xy;
WW_est = [];
step = (last-first+1)/2;
for i=1:step-order
    WW_est = [WW_est; WW_est_xy(i:step:end,:,1,1)];
end

% Wmonkey(1:2:end)=Wmonkey(1:2:end)+160;
% Wmonkey(2:2:end)=Wmonkey(2:2:end)+120;
% WW_est(1:2:end)=WW_est(1:2:end)+160;
% WW_est(2:2:end)=WW_est(2:2:end)+120;

% ConnectionStr = (ConnectionStr>0.5);
% dispNetwork;

% end