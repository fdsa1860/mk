% activity heuristics

function chaseLabel = detectChasing(traj)

nFrames = size(traj,1);
nObjs = size(traj,3);
frSegSize = 50;

chaseVecValTH = -50;
chaseVecPercentTH = 0.2;

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
            dx1 = diff(x1);
            dy1 = diff(y1);
            
%             x2 = u(id2,startFrame:endFrame);
%             y2 = v(id2,startFrame:endFrame);
            x2 = traj(startFrame:endFrame,1,id2);
            y2 = traj(startFrame:endFrame,2,id2);
            dx2 = diff(x2);
            dy2 = diff(y2);
            
            % if object is occluded, continue
            if ~any(x1) || ~any(y1) || ~any(x2) || ~any(y2)
                continue;
            end
            
            rx12 = x2 - x1;
            ry12 = y2 - y1;
            rx21 = x1 - x2;
            ry21 = y1 - y2;
            
            r12abs = (rx12.^2 + ry12.^2).^0.5;
            r21abs = (rx21.^2 + ry21.^2).^0.5;
            chaseVec1 = (dx1.*rx12(2:end) + dy1.*ry12(2:end)) ./ r12abs(2:end);
            chaseVec2 = (dx2.*rx21(2:end) + dy2.*ry21(2:end)) ./ r21abs(2:end);
            
            %             figure(1);
            %             plot(chaseVec1,'*');
            %             % figure(2);
            %             hold on;
            %             plot(chaseVec2,'go');
            %             hold off;
            
            chaseVec = chaseVec1 .* chaseVec2;
            ind = find(chaseVec < chaseVecValTH);
            if nnz(ind)/frSegSize > chaseVecPercentTH
                if chaseVec1(ind(1)) > 0
                    chaseMat(id1,id2,fi) = -1;
                    chaseMat(id2,id1,fi) = 1;
                else
                    chaseMat(id1,id2,fi) = 1;
                    chaseMat(id2,id1,fi) = -1;
                end
                
            end
            
        end
    end
    
end

chaseLabel = sum(chaseMat);
chaseLabel(chaseLabel>0) = 1;
chaseLabel(chaseLabel<0) = -1;

end