% sift detector test bench
% Created by Xikang Zhang, 09/13/2013
% modified by Xikang Zhang, 06/08/2014

% function testBenchSIFTDetector

clear all;close all;clc;

% addpath(genpath('.\xml_io_tools'));
run('..\3rdParty\vlfeat-0.9.18\toolbox\vl_setup');
addpath(genpath('..\3rdParty\libsvm-3.18\matlab'));

posInputDir = 'C:\zxk\Research\monkeyData\Camera1_labeledVideos_Patch_Pos';
negInputDir = 'C:\zxk\Research\monkeyData\Camera1_labeledVideos_Patch_Neg';
% posInputDir = 'C:\zxk\Research\monkeyData\camera1_temp_pos';
% negInputDir = 'C:\zxk\Research\monkeyData\camera1_temp_neg';

pfiles = dir([posInputDir '\*.png']);
nfiles = dir([negInputDir '\*.png']);
numFiles = length(pfiles) + length(nfiles);
maxNum = 100000;
featPool = zeros(128,maxNum);
counter = 0;
for i=1:length(pfiles)
% for i=1:200
    I = imread([posInputDir '\' pfiles(i).name]);
    [f,d] = vl_sift(im2single(rgb2gray(I)));
    featPool(:,counter+1:counter+size(d,2)) = double(d);
    counter = counter + size(d,2);
end
display('Positive data complete.')
for i=1:length(nfiles)
% for i=1:200
    I = imread([negInputDir '\' nfiles(i).name]);
    [f,d] = vl_sift(im2single(rgb2gray(I)));
    featPool(:,counter+1:counter+size(d,2)) = double(d);
    counter = counter + size(d,2);
end
display('Negative data complete.')
featPool(:,counter+1:maxNum) = [];

numClusters = 16;
[means, covariances, priors] = vl_gmm(featPool, numClusters);
clear featPool;
% [centers, assignments] = vl_kmeans(featPool,numClusters);
% clear featPool;
% kdtree = vl_kdtreebuild(centers);

fFeat = zeros(2*numClusters*128,numFiles);
% kFeat = zeros(numClusters,numFiles);
labels = zeros(1,numFiles);

% pfiles = dir([posInputDir '\*.png']);
% nfiles = dir([negInputDir '\*.png']);
for i=1:length(pfiles)
% for i=1:200
    I = imread([posInputDir '\' pfiles(i).name]);
    [f,d] = vl_sift(im2single(rgb2gray(I)));
    fisherHist = vl_fisher(double(d),means, covariances, priors);
    fFeat(:,i) = fisherHist;
%     [index, distance] = vl_kdtreequery(kdtree, centers, double(d));
%     kmeansHist = hist(index,1:numClusters);
%     kmeansHist = kmeansHist/sum(kmeansHist);
%     kFeat(:,i) = kmeansHist;
    labels(i) = 1;
end
display('Positive data complete.')
for i=1:length(nfiles)
% for i=1:200
    I = imread([negInputDir '\' nfiles(i).name]);
    [f,d] = vl_sift(im2single(rgb2gray(I)));
    fisherHist = vl_fisher(double(d),means, covariances, priors);
    fFeat(:,length(pfiles)+i) = fisherHist;
%     [index, distance] = vl_kdtreequery(kdtree, centers, double(d));
%     kmeansHist = hist(index,1:numClusters);
%     kmeansHist = kmeansHist/sum(kmeansHist);
%     kFeat(:,i) = kmeansHist;
    labels(length(pfiles)+i) = -1;
end
display('Negative data complete.')

nFolds = 5;
finalAccuracy = zeros(nFolds,1);
ind = crossvalind('Kfold',length(labels),nFolds);
for j=1:nFolds
    trainData = fFeat(:,ind~=j);
%     trainData = kFeat(:,ind~=j);
    trainLabel = labels(ind~=j);
    testData = fFeat(:,ind==j);
%     testData = kFeat(:,ind==j);
    testLabel = labels(ind==j);
    model = svmtrain(trainLabel',trainData','-t 0 -s 0 -c 100');
    [predict_label, accuracy, prob_estimates] = svmpredict(testLabel', testData', model);
%     accuracy(1)
    finalAccuracy(j) = accuracy(1);
end
fprintf('Final accuracy is %f\n',mean(finalAccuracy));
rmpath(genpath('..\3rdParty\libsvm-3.18\matlab'));
55