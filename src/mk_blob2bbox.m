function bb = mk_blob2bbox(currBlob,thr)
% cluster the foreground region using connect components labelling
% input:
% currBlob: blob matrix
% output:
% bb: bounding boxes to each cluster label

% [labeledBlob nObj] = bwlabel(currBlob,8);
CC = bwconncomp(currBlob,8);
nObj = CC.NumObjects;

bb = zeros(nObj,4);
for i=1:nObj
    [indr,indc]=ind2sub(CC.ImageSize,CC.PixelIdxList{i});
    bb(i,:)=[min(indc) min(indr) max(indc)-min(indc)+1 max(indr)-min(indr)+1];
end
bb(bb(:,3).*bb(:,4)<thr,:)=[];


end