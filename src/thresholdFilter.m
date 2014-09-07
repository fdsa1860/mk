% Filter out the bounding boxes with low weights
% Written by Xikang Zhang, 06/21/2013

function [bbox weights]= thresholdFilter(bbox, weights, weightThres)
bbox = bbox(weights>weightThres,:);
weights = weights(weights>weightThres,:);
end