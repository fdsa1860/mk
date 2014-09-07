% group bounding boxes using non-maximum surpression
% Written by Xikang Zhang, 06/21/2013

function [bb, weights] = groupBBox_nonMaxSup(bb,weights,winSiz)

if nargin<3
    winSiz = 30;
end
assert(size(bb,1)==length(weights));
valid = true(size(weights));
xc = bb(:,1)+bb(:,3)/2;
yc = bb(:,2)+bb(:,4)/2;
for i=1:length(valid)
    if ~valid(i)
        continue;
    end
    isNeighbor = abs(xc(:)-xc(i))<=winSiz & abs(yc(:)-yc(i))<=winSiz & valid;
    isNeighbor(i) = false;
    valid(isNeighbor & weights<weights(i)) = false;
end
bb = bb(valid,:);
weights = weights(valid);

end