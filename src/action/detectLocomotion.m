% activity heuristics

function locomotionLabel = detectLocomotion(traj)

nFrames = size(traj,1);
nObjs = size(traj,3);
% locomotionMat = -ones(nObjs, nFrames);

v_thres = 5;
LocomotionPercentTH = 0.15;

% vx = diff(u,1,2);
% vy = diff(v,1,2);
v = diff(traj);

% v_abs = (vx.^2 + vy.^2).^0.5;
v_abs = sum(v.^2,2);

locomotionLabel = zeros(nObjs,1);
for i = 1:nObjs
    if ~any(traj(:,:,i))
        locomotionLabel(i) = 0;
    elseif nnz(v_abs(:,:,i)>v_thres)/nFrames > LocomotionPercentTH
        locomotionLabel(i) = 1;
    else
        locomotionLabel(i) = -1;
    end
end

% locomotionMat(:,2:end) = 2 * (v_abs < v_thres) - 1;

% sum(locomotionMat<0,2)/size(locomotionMat,2) < LocomotionPercentTH


end