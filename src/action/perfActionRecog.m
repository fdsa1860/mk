% the performance of action recognition
% perfActionRecog

% videoPath = 'C:\zxk\Research\monkeyData\20121011_cam1_ex009';
% video = dir(fullfile(videoPath,'ex009*'));
% nObj = 6;

videoPath = 'C:\zxk\Research\monkeyData\cam2-127389';
video = dir(fullfile(videoPath,'cam2*'));
nObj = 4;

gtPath = fullfile(videoPath,'GroundTruth');
trajFile = dir(fullfile(gtPath,'traj_*.mat'));
assert(length(trajFile)==length(video));

actionFile = dir(fullfile(gtPath,'action_*.txt'));
assert(length(actionFile)==length(video));


nMaxSeg = 100;
counter = 0;
allGtLabel = zeros(nObj,nMaxSeg);
allActionLabel = zeros(size(allGtLabel));
for vi = 1:length(video)

load(fullfile(gtPath,trajFile(vi).name));

chaseLabel = detectChasing2(traj);
avoidLabel = detectAvoiding(traj);
locomotionLabel = detectLocomotion(traj);

% load('chaseMat.mat');
% load('avoidMat.mat');
% load('locomotionMat.mat');

nObjs = size(traj,3);
actionLabel = zeros(nObjs,1);
for i = 1:nObjs
    if chaseLabel(i) == 1
        actionLabel(i) = 3; % chase
    elseif chaseLabel(i) == -1
        actionLabel(i) = -2; % flee merged to avoid
    elseif avoidLabel(i) == -1
        actionLabel(i) = -2; % avoid
    elseif avoidLabel(i) == 1
        actionLabel(i) = 1; % locomotion
    elseif locomotionLabel(i) == 1
        actionLabel(i) = 1; % locomotion
    elseif locomotionLabel(i) == -1
        actionLabel(i) = -1; % stationary
    elseif locomotionLabel(i) == 0
        actionLabel(i) = 0; % occluded
    else
        error('no matching labels');
    end
end

allActionLabel(:,vi) = actionLabel;

fid = fopen(fullfile(gtPath,actionFile(vi).name));
A = textscan(fid,'%s');
fclose(fid);

gtLabel = strLabel2numLabel(A{1});
allGtLabel(:,vi) = gtLabel;

% actionLabel
% gtLabel
% nnz(actionLabel == gtLabel)/length(gtLabel)

counter = counter + 1;

end
allActionLabel(:,counter+1:end) = [];
allGtLabel(:,counter+1:end) = [];

allActionLabel
allGtLabel
nnz(allActionLabel == allGtLabel)/numel(allGtLabel)

fprintf('\t\t\tGT\t\tDT\t\tTP\t\tFP\t\tFN\n');
fprintf('Chasing \t%d\t\t%d\t\t%d\t\t%d\t\t%d\n',nnz(allGtLabel==3),...
    nnz(allActionLabel==3),nnz(allGtLabel==3 & allActionLabel==3),...
    nnz(allGtLabel~=3 & allActionLabel==3),...
    nnz(allGtLabel==3 & allActionLabel~=3));
fprintf('Avoiding \t%d\t\t%d\t\t%d\t\t%d\t\t%d\n',nnz(allGtLabel==-2),...
    nnz(allActionLabel==-2),nnz(allGtLabel==-2 & allActionLabel==-2),...
    nnz(allGtLabel~=-2 & allActionLabel==-2),...
    nnz(allGtLabel==-2 & allActionLabel~=-2));
fprintf('Locomotion \t%d\t\t%d\t\t%d\t\t%d\t\t%d\n',nnz(allGtLabel==1),...
    nnz(allActionLabel==1),nnz(allGtLabel==1 & allActionLabel==1),...
    nnz(allGtLabel~=1 & allActionLabel==1),...
    nnz(allGtLabel==1 & allActionLabel~=1));
fprintf('Stationary \t%d\t\t%d\t\t%d\t\t%d\t\t%d\n',nnz(allGtLabel==-1),...
    nnz(allActionLabel==-1),nnz(allGtLabel==-1 & allActionLabel==-1),...
    nnz(allGtLabel~=-1 & allActionLabel==-1),...
    nnz(allGtLabel==-1 & allActionLabel~=-1));
fprintf('Occluded \t%d\t\t%d\t\t%d\t\t%d\t\t%d\n',nnz(allGtLabel==0),...
    nnz(allActionLabel==0),nnz(allGtLabel==0 & allActionLabel==0),...
    nnz(allGtLabel~=0 & allActionLabel==0),...
    nnz(allGtLabel==0 & allActionLabel~=0));


