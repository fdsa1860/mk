% activity heuristics

clearvars;close all;clc;

load u009.mat;load v009.mat;

nFrames = size(u,2);
nObjs = size(u,1);

v_thres = 5;
avoidAngleTH_L = pi/10;
avoidAngleTH_H = pi/5;
avoidVecPercentTH = 0.1;

frSegSize = 50;
frSeg = 1:frSegSize:nFrames-frSegSize;
avoidMat = zeros(nObjs, nObjs,length(frSeg));
for fi = 1:length(frSeg)
    
    for id1 = 1:6;
        for id2 = 1:6;
            
            if id1==id2
                continue;
            end
            
            startFrame = frSeg(fi);
            endFrame = startFrame + frSegSize - 1;
            
            x1 = u(id1,startFrame:endFrame);
            y1 = v(id1,startFrame:endFrame);
            vx1 = diff(x1);
            vy1 = diff(y1);
            
            x2 = u(id2,startFrame:endFrame);
            y2 = v(id2,startFrame:endFrame);
            vx2 = diff(x2);
            vy2 = diff(y2);
            
            rx12 = x2(2:end) - x1(2:end);
            ry12 = y2(2:end) - y1(2:end);
            rx21 = x1(2:end) - x2(2:end);
            ry21 = y1(2:end) - y2(2:end);
            
            r12abs = (rx12.^2 + ry12.^2).^0.5;
            r21abs = (rx21.^2 + ry21.^2).^0.5;
            v1abs = (vx1.^2 + vy1.^2).^0.5;
            v2abs = (vx2.^2 + vy2.^2).^0.5;
            
            vInd = v1abs > v_thres & v2abs > v_thres;
            
            angleVec1 = acos((vx1(vInd).*rx12(vInd) + vy1(vInd).*ry12(vInd)) ./ (r12abs(vInd).*v1abs(vInd)));
            angleVec2 = acos((vx2(vInd).*rx21(vInd) + vy2(vInd).*ry21(vInd)) ./ (r21abs(vInd).*v2abs(vInd)));
            
%                         figure(1);
%                         plot(angleVec1,'*');
%                         % figure(2);
%                         hold on;
%                         plot(angleVec2,'go');
%                         hold off;

            ind = find(abs(angleVec1) < avoidAngleTH_L & abs(angleVec2) > avoidAngleTH_H);
            if nnz(ind)/frSegSize > avoidVecPercentTH
                    avoidMat(id1,id2,fi) = 1;
                    avoidMat(id2,id1,fi) = -1;
            end
            
        end
    end
    
end

save avoidMat avoidMat frSeg frSegSize;