
addpath(genpath('C:\zxk\Research\zz_libsvm-3.11\matlab'));
% [lb, H] = libsvmread('C:\zxk\Research\monkey\monkey_MatlabPrj\hog.txt');
[lb, H] = libsvmread('C:\zxk\Research\monkey\monkey_MatlabPrj\color.txt');
trainRatio = 0.8;
% matlab> model = svmtrain(training_label_vector, 
%           training_instance_matrix [, 'libsvm_options']);
% model = svmtrain(lb,H);

N = length(lb);
Ind = randperm(N);
lb = lb(Ind);
H = H(Ind,:);

trainData = H(1:round(trainRatio*N),:);
trainLabel = lb(1:round(trainRatio*N));
testData = H(round(trainRatio*N)+1:end,:);
testLabel = lb(round(trainRatio*N)+1:end);

model = svmtrain(trainLabel,trainData);
[predict_label, accuracy, prob_estimates] = svmpredict(testLabel, testData, model);
accuracy