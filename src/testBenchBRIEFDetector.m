
function testBenchBRIEFDetector

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

% X1 = reshape(X,[size(X,1)*size(X,2),size(X,3)]);
% H = zeros(size(X1,1),256);
% for i = 1:size(X1,2)
%     subr = 1:3600;
%     subc = double(X1(:,i)');
%     ind = sub2ind(size(H),subr,subc);
%     H(ind) = H(ind) + 1;
% end
Xp1 = reshape(Xp,[size(Xp,1)*size(Xp,2),size(Xp,3)]);
Hp = zeros(size(Xp1,1),256);
for i = 1:size(Xp1,2)
    subr = 1:size(Xp1,1);
    subc = double(Xp1(:,i)');
    ind = sub2ind(size(Hp),subr,subc);
    Hp(ind) = Hp(ind) + 1;
end
Xn1 = reshape(Xn,[size(Xn,1)*size(Xn,2),size(Xn,3)]);
Hn = zeros(size(Xn1,1),256);
for i = 1:size(Xn1,2)
    subr = 1:3600;
    subc = double(Xn1(:,i)');
    ind = sub2ind(size(Hn),subr,subc);
    Hn(ind) = Hn(ind) + 1;
end

X1 = [Xp1 Xn1];
H = Hp + Hn;
H = H/size(X1,2);
entropyAll = sum(-H.*log(H+1e-6),2);

Hp = Hp/size(Hp,2);
entropyP = sum(-Hp.*log(Hp+1e-6),2);
Hn = Hn/size(Hn,2);
entropyN = sum(-Hn.*log(Hn+1e-6),2);

entropyDiff = entropyP+entropyN-entropyAll;
entropyIm = reshape(entropyDiff,size(X,1),size(X,2));
[sortedEntropy indices] = sort(entropyAll,'descend');
% indices = randperm(3600);
N = 500;
interestPointsInd = indices(1:2*N);
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