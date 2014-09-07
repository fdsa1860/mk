
%
function [RLearners RWeights errorRate] = mk_GML_adaboost

addpath(genpath('C:\zxk\Research\monkey\monkey_MatlabPrj\GML_AdaBoost_Matlab_Toolbox_0.3'));

addpath(genpath('C:\zxk\Research\zz_libsvm-3.11\matlab'));
[lb, H] = libsvmread('C:\zxk\Research\monkey\monkey_MatlabPrj\hog.txt');
H = H';
lb = lb';
weak_learner = tree_node_w(1);

% [classestimate,model]=adaboost('train',H,lb,50);

[RLearners RWeights] = GentleAdaBoost(weak_learner, H, lb,50);

% myLabel=adaboost('apply',H,model);
ResultR = sign(Classify(RLearners, RWeights, H));

errorRate = nnz(ResultR-lb)/length(lb);

errorRate

% crossIdx=crossvalind('Kfold',size(feat,1),5);
% for k=1:5
% 
%  % Use Adaboost to make a classifier
%  [classestimate,model]=adaboost('train',feat(crossIdx~=k,:),lb(crossIdx~=k),50);
%  
%   % Classify the testdata with the trained model
%   myLabel=adaboost('apply',feat(crossIdx==k,:),model);
%   errorRate = nnz(myLabel-lb(crossIdx==k))/nnz(myLabel);
%   errorRate
%   
% end

end