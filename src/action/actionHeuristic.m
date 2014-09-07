

clearvars;close all;clc;

load u009.mat;load v009.mat;

nFrames = size(u,2);
nObjs = size(u,1);

load('chaseMat.mat');
load('avoidMat.mat');
load('locomotionMat.mat');

actionMat = zeros(nObjs, nObjs, nFrames);

for i = 1:nFrames
    chaseMatInd = ceil(i/frSegSize);
    avoidMatInd = ceil(i/frSegSize);
    if chaseMatInd > size(chaseMat,3) || avoidMatInd > size(avoidMat,3)
        continue;
    end
    C = chaseMat(:,:,chaseMatInd);
%     maskC = ones(nObjs);
%     [m,n] = find(C);
%     maskC(m,:) = 0;
%     maskC(:,n) = 0;
    maskC = ~C;
    [m,n] = find(C);
    maskC(m,m) = 0;
    maskC(n,n) = 0;
    A = avoidMat(:,:,avoidMatInd);
    A = maskC.*A;
%     maskA = ones(nObjs);
%     [m,n] = find(A);
%     maskA(m,:) = 0;
%     maskA(:,n) = 0;
    maskA = ~A;
    [m,n] = find(A);
    maskA(m,m) = 0;
    maskA(n,n) = 0;
    L = diag(locomotionMat(:,i));
    L = maskC.*maskA.*L;
    actionMat(:,:,i) = 3*C + 2*A + 1*L;
end

save actionMat actionMat;