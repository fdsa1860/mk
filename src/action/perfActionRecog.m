% the performance of action recognition
% perfActionRecog

% videoPath = 'C:\zxk\Research\monkeyData\20121011_cam1_ex009';
% video = dir(fullfile(videoPath,'ex009*'));
% nObj = 6;

if ispc
    videoPath = 'C:\zxk\Research\monkeyData\cam1-127389';
elseif ismac
    videoPath = fullfile('~','research','data','monkey','cam1-127389');
end
video = dir(fullfile(videoPath,'cam1*'));
nObj = 4;
nVideo = length(video);

gtPath = fullfile(videoPath,'GroundTruth');
gtActionFile = dir(fullfile(gtPath,'action_*.txt'));
assert(length(gtActionFile)==nVideo);

dtPath = fullfile(videoPath,'ActivityRecognition');
dtActionFile = dir(fullfile(dtPath,'dt_action_*.txt'));
assert(length(dtActionFile)==nVideo);

allGtLabel = zeros(nObj,nVideo);
allDtLabel = zeros(size(allGtLabel));
for vi = 1:nVideo

fid = fopen(fullfile(dtPath,dtActionFile(vi).name));
A = textscan(fid,'%s');
fclose(fid);

dtLabel = strLabel2numLabel(A{1});
allDtLabel(:,vi) = dtLabel;

fid = fopen(fullfile(gtPath,gtActionFile(vi).name));
A = textscan(fid,'%s');
fclose(fid);

gtLabel = strLabel2numLabel(A{1});
allGtLabel(:,vi) = gtLabel;

end

allDtLabel
allGtLabel
nnz(allDtLabel == allGtLabel)/numel(allGtLabel)

fprintf('\t\tGT\t\tDT\t\tTP\t\tFP\t\tFN\n');
fprintf('Chasing \t%d\t\t%d\t\t%d\t\t%d\t\t%d\n',nnz(allGtLabel==3),...
    nnz(allDtLabel==3),nnz(allGtLabel==3 & allDtLabel==3),...
    nnz(allGtLabel~=3 & allDtLabel==3),...
    nnz(allGtLabel==3 & allDtLabel~=3));
fprintf('Avoiding \t%d\t\t%d\t\t%d\t\t%d\t\t%d\n',nnz(allGtLabel==-2),...
    nnz(allDtLabel==-2),nnz(allGtLabel==-2 & allDtLabel==-2),...
    nnz(allGtLabel~=-2 & allDtLabel==-2),...
    nnz(allGtLabel==-2 & allDtLabel~=-2));
fprintf('Locomotion \t%d\t\t%d\t\t%d\t\t%d\t\t%d\n',nnz(allGtLabel==1),...
    nnz(allDtLabel==1),nnz(allGtLabel==1 & allDtLabel==1),...
    nnz(allGtLabel~=1 & allDtLabel==1),...
    nnz(allGtLabel==1 & allDtLabel~=1));
fprintf('Stationary \t%d\t\t%d\t\t%d\t\t%d\t\t%d\n',nnz(allGtLabel==-1),...
    nnz(allDtLabel==-1),nnz(allGtLabel==-1 & allDtLabel==-1),...
    nnz(allGtLabel~=-1 & allDtLabel==-1),...
    nnz(allGtLabel==-1 & allDtLabel~=-1));
fprintf('Occluded \t%d\t\t%d\t\t%d\t\t%d\t\t%d\n',nnz(allGtLabel==0),...
    nnz(allDtLabel==0),nnz(allGtLabel==0 & allDtLabel==0),...
    nnz(allGtLabel~=0 & allDtLabel==0),...
    nnz(allGtLabel==0 & allDtLabel~=0));


