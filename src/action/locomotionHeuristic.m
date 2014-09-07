% activity heuristics

clearvars;close all;clc;

load u009.mat;load v009.mat;

nFrames = size(u,2);
nObjs = size(u,1);
locomotionMat = -ones(nObjs, nFrames);

v_thres = 5;
LocomotionPercentTH = 0.1;

vx = diff(u,1,2);
vy = diff(v,1,2);

v_abs = (vx.^2 + vy.^2).^0.5;

locomotionMat(:,2:end) = 2 * (v_abs < v_thres) - 1;

save locomotionMat locomotionMat;