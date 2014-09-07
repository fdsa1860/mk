% test lbp with boost in monkey detection

% function testLBPBoost

clear;close all;clc;

addpath(genpath('C:\zxk\Research\zz_fdtool_release'));

% posPath = 'C:\zxk\Research\monkeyData\Camera4_labeledVideos_Patch_Pos';
% negPath = 'C:\zxk\Research\monkeyData\Camera4_labeledVideos_Patch_Neg3';
% posFiles = dir([posPath '\*.png']);
% negFiles = dir([negPath '\*.png']);
% 
% 
% for i=1:length(posFiles)
%     I = imread([posPath '\' posFiles(i).name]);
%     X(:,:,i) = rgb2gray(I);    
% end
% offset = length(posFiles);
% for i=1:length(negFiles)
%         I = imread([negPath '\' negFiles(i).name]);
%     X(:,:,i+offset) = rgb2gray(I);
% end
% y = [ones(1,length(posFiles)) -ones(1,length(negFiles))];
% Ny                                 = size(I,1);
% Nx                                 = size(I,2);

% load viola_24x24;
load trainingData_cam4
Ny                                 = 60;
Nx                                 = 60;

% Ny                                 = 24;
% Nx                                 = 24;
options.N                          = [8, 4];
options.R                          = [1, 1];
options.map                        = zeros(2^max(options.N) , length(options.N));
mapping                            = getmapping(options.N(1),'u2');
options.map(1:2^options.N(1) , 1)  = mapping.table';
options.map(1:2^options.N(2) , 2)  = (0:2^options.N(2)-1)';

options.shiftbox     = cat(3 , [30 , 30 ; 15 , 15] , [16 , 16 ; 4 , 4]);

options.T                          = 50;
H                                  = chlbp(X , options);

y                                  = int8(y);
indp                               = find(y == 1);
indn                               = find(y ==-1);

index                              = randperm(length(y));  %shuffle data to avoid numerical discrepancies with long sequence of same label
options.param                      = chlbp_adaboost_binary_train_cascade(H(: , index) , y(index) , options);
[yest_train , fx_train]            = chlbp_adaboost_binary_predict_cascade(H , options);

tp_train                           = sum(yest_train(indp) == y(indp))/length(indp)
fp_train                           = 1 - sum(yest_train(indn) == y(indn))/length(indn)
Perf_train                         = sum(yest_train == y)/length(y)
[tpp_train , fpp_train]            = basicroc(y , fx_train);

% end

