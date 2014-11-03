% detect actions

% videoPath = 'C:\zxk\Research\monkeyData\20121011_cam1_ex009';
% video = dir(fullfile(videoPath,'ex009*'));
% nObj = 6;

if ispc
    videoPath = 'C:\zxk\Research\monkeyData\cam1-127389';
elseif ismac
    videoPath = fullfile('~','research','data','monkey','cam2-127389');
end
video = dir(fullfile(videoPath,'cam2*'));
nObj = 4;

gtPath = fullfile(videoPath,'GroundTruth');
trajFile = dir(fullfile(gtPath,'traj_*.mat'));
assert(length(trajFile)==length(video));

dtPath = fullfile(videoPath,'ActivityRecognition');

nMaxSeg = 100;
counter = 0;
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
    
    A = numLabel2strLabel(actionLabel);
    fid = fopen(fullfile(dtPath,sprintf('dt_action_%s.txt',video(vi).name)),'wt');
    for i = 1:length(A)
        fprintf(fid,'%s\n',A{i});
    end
    fclose(fid);
    
    counter = counter + 1;
    
end
