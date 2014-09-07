% hog detector test bench
% Created by Xikang Zhang, 09/13/2013

function testBenchHogDetector

clear all;close all;clc;

addpath(genpath('.\xml_io_tools'));
run('C:\zxk\Research\zz_vlfeat-0.9.16\toolbox\vl_setup');
addpath(genpath('C:\zxk\Research\zz_libsvm-3.11\matlab'));
addpath('C:\zxk\Research\monkey\monkey_cppPrj\mexhog');

posInputDir = 'C:\zxk\Research\monkeyData\Camera1_labeledVideos_Patch_Pos';
negInputDir = 'C:\zxk\Research\monkeyData\Camera1_labeledVideos_Patch_Neg';
% posInputDir = 'C:\zxk\Research\monkeyData\camera1_temp_pos';
% negInputDir = 'C:\zxk\Research\monkeyData\camera1_temp_neg';
modelName = 'hog_cam1_model.xml';

% parameters.scaleX = [0.5000 1];
% parameters.scaleY = [0.5000 1];
% parameters.winW_orig = 80;
% parameters.winH_orig = 80;
% parameters.winStepX = 10;
% parameters.winStepY = 10;
% parameters.nlevels = 5;
% parameters.svm_thres = 0.0;
% parameters.scaleStep = 1.1000;
% parameters.merge_thres = 0.0;
% parameters.mergeEnable = 0;
% parameters.c = 0.01;
% parameters.winSize = [60 60];
% parameters.blockSize = [20 20];
% % parameters.blockSize = [10 10];
% parameters.blockStride = [10 10];
% % parameters.blockStride = [5 5];
% parameters.cellSize = [10 10];
% % parameters.cellSize = [5 5];
% 
% xml_write(modelName, parameters, 'opencv_storage');
% hogDetect('train', posInputDir, negInputDir, modelName);
% [bbox, conf]=hogDetect('detect',modelName,I1);
% imshow(I1);
% hold on;
% for i = 1:size(bbox,1)
%     rectangle('Position',bbox(i,:),'EdgeColor','r');
% end
% hold off;

data = [];

pfiles = dir([posInputDir '\*.png']);
nfiles = dir([negInputDir '\*.png']);
for i=1:length(pfiles)
    I = imread([posInputDir '\' pfiles(i).name]);
    %     hog = vl_hog(im2single(I),20,'NumOrientations',9,'BilinearOrientations','Variant','DalalTriggs');
    hog = mexhog(I);
    data = [data double(hog(:))];
    %     I = im2double(imresize(I,0.5));
    %     data = [data I(:)];
end
display('Positive data complete.')
for i=1:length(nfiles)
    I = imread([negInputDir '\' nfiles(i).name]);
    %         hog = vl_hog(im2single(I),20,'NumOrientations',9,'BilinearOrientations','Variant','DalalTriggs');
    hog = mexhog(I);
    data = [data double(hog(:))];
    %     I = im2double(imresize(I,0.5));
    %     data = [data I(:)];
end
display('Negative data complete.')
labels = [ ones(length(pfiles),1); -ones(length(nfiles),1) ];

% libsvmwrite('data.txt', labels, sparse(data'));
% dos('svm-scale -l -1 -u 1 -s range data.txt > data_scale.txt');
% [labels,data] = libsvmread('data_scale.txt');
% data = data';

nFolds = 5;
finalAccuracy = zeros(nFolds,1);
ind = crossvalind('Kfold',length(labels),nFolds);
for j=1:nFolds
    trainData = data(:,ind~=j);
    trainLabel = labels(ind~=j);
    testData = data(:,ind==j);
    testLabel = labels(ind==j);
    model = svmtrain(trainLabel,trainData','-c 8 -g 0.0078125');
    [predict_label, accuracy, prob_estimates] = svmpredict(testLabel, testData', model);
    accuracy(1)
    finalAccuracy(j) = accuracy(1);
end
fprintf('Final accuracy is %f\n',mean(finalAccuracy));
55