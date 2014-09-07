% test Monkey detector
% Created by Xikang Zhang, 06/24/2013

function testMonkeyDetector

clear all;close all;clc;

addpath(genpath('..\xml_io_tools'));

% posInputDir = 'C:\zxk\Research\monkeyData\Camera1_labeledVideos_Patch_Pos';
% negInputDir = 'C:\zxk\Research\monkeyData\Camera1_labeledVideos_Patch_Neg';
posInputDir = 'C:\zxk\Research\monkeyData\cam2\pos';
negInputDir = 'C:\zxk\Research\monkeyData\cam2\neg';
modelName = 'hog_cam2_model.xml';

parameters.scaleX = [0.5000 1];
parameters.scaleY = [0.5000 1];
parameters.winW_orig = 80;
parameters.winH_orig = 80;
parameters.winStepX = 10;
parameters.winStepY = 10;
parameters.nlevels = 5;
parameters.svm_thres = 0.0;
parameters.scaleStep = 1.1000;
parameters.merge_thres = 0.0;
parameters.mergeEnable = 0;
parameters.c = 0.01;
parameters.winSize = [60 60];
parameters.blockSize = [20 20];
% parameters.blockSize = [10 10];
parameters.blockStride = [10 10];
% parameters.blockStride = [5 5];
parameters.cellSize = [10 10];
% parameters.cellSize = [5 5];

xml_write(modelName, parameters, 'opencv_storage');
hogDetect('train', posInputDir, negInputDir, modelName);


% I = imread('cam1_sample2.png');
% I1 = imresize(I, 0.5);
% [bbox, conf]=hogDetect('detect',modelName,I1);
% imshow(I1);
% hold on;
% for i = 1:size(bbox,1)
%     rectangle('Position',bbox(i,:),'EdgeColor','r');
% end
% hold off;

end