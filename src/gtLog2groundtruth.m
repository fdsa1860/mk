
function [groundtruth, tracesfull] = gtLog2groundtruth(gtLog)

frameNum = unique(gtLog(:, 1));
firstFrame = min(frameNum);
lastFrame = max(frameNum);
numFrame = lastFrame - firstFrame + 1;

objId = unique(gtLog(:, 6));
numObj = length(objId);

groundtruth = zeros(numFrame, 4, numObj);

for i = 1:numObj
    isObj = gtLog(:,6)==objId(i);
    frameInd = gtLog(isObj, 1);
    groundtruth(frameInd-firstFrame+1, :, i) = gtLog(isObj, 2:5);
end

tracesfull = zeros(numFrame, 2, numObj);
tracesfull(:,1,:) = groundtruth(:,1,:) + groundtruth(:,3,:) / 2;
tracesfull(:,2,:) = groundtruth(:,2,:) + groundtruth(:,4,:) / 2;

end
