function y = frameDiff(previousFrame, currFrame, thr)

% currFrame_ = rgb2gray(currFrame);
% previousFrame_ = rgb2gray(previousFrame);

A = abs(double(currFrame) - double(previousFrame));
y=nnz(A>thr);
y = y/numel(A);