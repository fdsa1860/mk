% label activities

close all;

% labelPath = 'C:\zxk\Research\monkeyData\20121011_cam1_output2';
% load(fullfile(labelPath,'u009.mat'));
% load(fullfile(labelPath,'v009.mat'));

filePath = 'C:\zxk\Research\monkeyData\cam2-127389\cam2-128139';
labelPath = 'C:\zxk\Research\monkeyData\cam2-127389\GroundTruth';
frames = dir(fullfile(filePath,'*.png'));
labelFileName = 'traj_cam2_128139.mat';
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