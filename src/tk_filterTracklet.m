% filter tracklets

function [tracklet, indexMat]= tk_filterTracklet(th)

load tracklet20130424;
L = sum(indexMat,2);

ind = L>th;
tracklet = tracklet(ind);
indexMat = indexMat(ind,:);


end