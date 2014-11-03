% label activities

close all;

% labelPath = 'C:\zxk\Research\monkeyData\20121011_cam1_output2';
% load(fullfile(labelPath,'u009.mat'));
% load(fullfile(labelPath,'v009.mat'));
if ispc
    filePath = 'C:\zxk\Research\monkeyData\cam2-127389\cam2-128139';
    labelPath = 'C:\zxk\Research\monkeyData\cam2-127389\GroundTruth';
elseif ismac
    filePath = '~/research/data/monkey/cam1-127389/cam1-128039';
    labelPath = '~/research/data/monkey/cam1-127389/GroundTruth';
end

frames = dir(fullfile(filePath,'*.png'));
labelFileName = 'traj_cam1_128039.mat';
load(fullfile(labelPath,labelFileName));
for i = 1:length(frames)
    currFrame = imread(fullfile(filePath,frames(i).name));
    currFrame = imresize(currFrame,0.5);
    imshow(currFrame);
    hold on;
    for j = 1:size(traj,3)
        plot(traj(i,1,j),traj(i,2,j),'+');
        text(traj(i,1,j),traj(i,2,j),sprintf('monkey %d',j));
    end
    title(sprintf('Frame number %d',i));
    hold off;
    pause(0.1);
end



% numFrames = size(u,2);
% segSize = 50;
% numSegs = floor(numFrames/segSize);
% numMonkeys = 6;
% numCoordinate = 2;

% for i = 1:numSegs
%     traj = zeros(segSize,numCoordinate,numMonkeys);
%     for j = 1:numMonkeys
%         traj(:,1,j) = u(j,(i-1)*segSize+1:i*segSize)';
%         traj(:,2,j) = v(j,(i-1)*segSize+1:i*segSize)';
%     end
%     trajFile = sprintf('traj_%05d',i);
%     save(trajFile,'traj');
% end