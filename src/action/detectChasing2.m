% activity heuristics

function chaseLabel = detectChasing2(traj)

nFrames = size(traj,1);
nObjs = size(traj,3);
frSegSize = 50;

v_thres = 10;
d_thres = 500;
chaseAngleTH_1 = pi/4;
chaseAngleTH_2 = pi/4;
chaseVecPercentTH = 0.05;

frSeg = 1:frSegSize:nFrames-frSegSize+1;
chaseMat = zeros(nObjs, nObjs,length(frSeg));
for fi = 1:length(frSeg)
    
    for id1 = 1:nObjs
        for id2 = 1:nObjs
            
            if id1==id2
                continue;
            end
            
            startFrame = frSeg(fi);
            endFrame = startFrame + frSegSize - 1;
            
%             x1 = u(id1,startFrame:endFrame);
%             y1 = v(id1,startFrame:endFrame);
            x1 = traj(startFrame:endFrame,1,id1);
            y1 = traj(startFrame:endFrame,2,id1);
            vx1 = diff(x1);
            vy1 = diff(y1);
            
%             x2 = u(id2,startFrame:endFrame);
%             y2 = v(id2,startFrame:endFrame);
            x2 = traj(startFrame:endFrame,1,id2);
            y2 = traj(startFrame:endFrame,2,id2);
            vx2 = diff(x2);
            vy2 = diff(y2);
            
            % if object is occluded, continue
            if ~any(x1) || ~any(y1) || ~any(x2) || ~any(y2)
                continue;
            end
            
            rx12 = x2(2:end) - x1(2:end);
            ry12 = y2(2:end) - y1(2:end);
            rx21 = - rx12;
            ry21 = - ry12;
            
            r12abs = (rx12.^2 + ry12.^2).^0.5;
            r21abs = r12abs; % r21abs is equal to r12abs
            v1abs = (vx1.^2 + vy1.^2).^0.5;
            v2abs = (vx2.^2 + vy2.^2).^0.5;
            
            vInd = v1abs > v_thres & v2abs > v_thres & r12abs < d_thres;
            
            angleVec1 = acos((vx1(vInd).*rx12(vInd) + vy1(vInd).*ry12(vInd)) ./ (r12abs(vInd).*v1abs(vInd)));
            angleVec2 = acos((vx2(vInd).*rx21(vInd) + vy2(vInd).*ry21(vInd)) ./ (r21abs(vInd).*v2abs(vInd)));
            
            ind = abs(angleVec1) < chaseAngleTH_1 & abs(angleVec2) > chaseAngleTH_2;
            
            if nnz(ind)/frSegSize > chaseVecPercentTH
                    chaseMat(id1,id2,fi) = -1;
                    chaseMat(id2,id1,fi) = 1;
            end
            
        end
    end
    
end

chaseLabel = sum(chaseMat);
chaseLabel(chaseLabel>0) = 1;
chaseLabel(chaseLabel<0) = -1;

end