%
function [model errorRate] = mk_adaboost

addpath(genpath('C:\zxk\Research\zz_adaboost'));

addpath(genpath('C:\zxk\Research\zz_libsvm-3.11\matlab'));
% [lb, H] = libsvmread('C:\zxk\Research\monkey\monkey_MatlabPrj\hog.txt');
[lb, H] = libsvmread('C:\zxk\Research\monkey\monkey_cppPrj\testHOG\hog.txt');

[classestimate,model]=adaboost('train',H,lb,50);

myLabel=adaboost('apply',H,model);

errorRate = nnz(myLabel-lb)/length(lb);

errorRate

% crossIdx=crossvalind('Kfold',size(H,1),5);
% for k=1:5
% 
%  % Use Adaboost to make a classifier
%  [classestimate,model]=adaboost('train',H(crossIdx~=k,:),lb(crossIdx~=k),50);
%  
%   % Classify the testdata with the trained model
%   myLabel=adaboost('apply',H(crossIdx==k,:),model);
%   errorRate = nnz(myLabel-lb(crossIdx==k))/length(myLabel);
%   errorRate
% %   
% % end
% 
% end