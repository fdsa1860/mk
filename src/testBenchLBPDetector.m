
function testBenchLBPDetector

clear;close all;clc;

addpath(genpath('C:\zxk\Research\zz_fdtool_release'));

posPath = 'C:\zxk\Research\monkeyData\Camera1_labeledVideos_Patch_Pos';
negPath = 'C:\zxk\Research\monkeyData\Camera1_labeledVideos_Patch_Neg';
posFiles = dir([posPath '\*.png']);
negFiles = dir([negPath '\*.png']);

% G = fspecial('average',[3 3]);
patchW = 60;
patchH = 60;
X = zeros(patchH,patchW,length(posFiles)+length(negFiles));
for i=1:length(posFiles)
    I = imread([posPath '\' posFiles(i).name]);
    %     X(:,:,i) = imfilter(rgb2gray(I),G);
    X(:,:,i) = rgb2gray(I);
end
offset = length(posFiles);
for i=1:length(negFiles)
    I = imread([negPath '\' negFiles(i).name]);
    %     X(:,:,i+offset) = imfilter(rgb2gray(I),G);
    X(:,:,i+offset) = rgb2gray(I);
end
y = [ones(1,length(posFiles)) -ones(1,length(negFiles))];
Ny                                 = size(I,1);
Nx                                 = size(I,2);

% load trainingData_cam4
% load viola_24x24
% Ny                                 = 24;
% Nx                                 = 24;

% options.N                          = [8 , 4 , 12];
% options.R                          = [1 , 1 , 2];
options.N                          = [8 , 4];
options.R                          = [1 , 1];
options.map                        = zeros(2^max(options.N) , length(options.N));

mapping                            = getmapping(options.N(1),'u2');
options.map(1:2^options.N(1) , 1)  = mapping.table';
options.map(1:2^options.N(2) , 2)  = (0:2^options.N(2)-1)';
% mapping                            = getmapping(options.N(3),'u2');
% options.map(1:2^options.N(3) , 3)  = mapping.table';

% options.shiftbox                   = cat(3 , [Ny , Nx ; 1 , 1] , [16 , 16
% ; 4 , 4] , [Ny , Nx ; 1 , 1]);
options.shiftbox                   = cat(3 , [Ny , Nx ; 1 , 1] , [16 , 16 ; 4 , 4]);

options.T                          = 50;
data                               = chlbp(X , options);
labels                             = double(y');
data = double(data);

nFolds = 5;
finalAccuracy = zeros(nFolds,1);
ind = crossvalind('Kfold',length(labels),nFolds);
for j=1:nFolds
    trainData = data(:,ind~=j);
    trainLabel = labels(ind~=j);
    testData = data(:,ind==j);
    testLabel = labels(ind==j);
    model = svmtrain(trainLabel,trainData','-t 0 -s 0 -c 0.01');
    [predict_label, accuracy, prob_estimates] = svmpredict(testLabel, testData', model);
    accuracy(1)
    finalAccuracy(j) = accuracy(1);
end
fprintf('Final accuracy is %f\n',mean(finalAccuracy));
55
% model = svmtrain(labels,data,'-t 0 -s 0 -c 0.01');
end