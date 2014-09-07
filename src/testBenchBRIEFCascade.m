
function testBenchBRIEFCascade

clear;close all;clc;

% posPath = 'C:\zxk\Research\monkeyData\Camera1_labeledVideos_Patch_Pos';
% negPath = 'C:\zxk\Research\monkeyData\Camera1_labeledVideos_Patch_Neg';
% posFiles = dir([posPath '\*.png']);
% negFiles = dir([negPath '\*.png']);
% 
% % G = fspecial('average',[3 3]);
% 
% for i=1:length(posFiles)
%     I = imread([posPath '\' posFiles(i).name]);
%     %     X(:,:,i) = imfilter(rgb2gray(I),G);
%     Xp(:,:,i) = rgb2gray(I);
% end
% % offset = length(posFiles);
% for i=1:length(negFiles)
%     I = imread([negPath '\' negFiles(i).name]);
%     %     X(:,:,i+offset) = imfilter(rgb2gray(I),G);
%     Xn(:,:,i) = rgb2gray(I);
% end
% X = cat(3,Xp,Xn);
% y = [ones(1,length(posFiles)) -ones(1,length(negFiles))];
% % Ny                                 = size(I,1);
% % Nx                                 = size(I,2);

load trainingData_cam1

% data                               = chlbp(X , options);
% labels                             = double(y');
% data = double(data);

model = [];
model.left = [];
model.right = [];
model.sign = [];
X1 = reshape(X,[size(X,1)*size(X,2),size(X,3)]);
dataLength = length(y);
mask = true(size(y));
TH = 0.1;
acc = 0;
i=1;
j=2;
while acc<TH && i~=3600
    l = X1(i,:)>X1(j,:);
    l = l*2-1;
    ll = l(mask);
    yy = y(mask);
    p1 = nnz(ll(yy==1)==1)/nnz(yy==1);
    p2 = nnz(ll(yy==-1)==-1)/nnz(yy==-1);
    if p1==1 && p2>0
        model.left = i;
        model.right = j;
        model.sign = 1;
        acc = acc + p2;
        newMaskInd = (l(y==-1)==-1);
        mask(newMaskInd) = false;        
    end
    if j==dataLength
        i = i + 1;
        j = 1;
    else
        j = j + 1;
    end
    [i j]
end
data = X1(indices(1:N),:)>X1(indices(N+1:2*N),:);
data = double(data);
labels = double(y');

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

end