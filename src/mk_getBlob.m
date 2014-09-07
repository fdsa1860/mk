function fgBlob=mk_getBlob(currFrame,thr)
% get blob of foreground

load './data/bg_img';
grayFrame = rgb2gray(currFrame);
grayBG = rgb2gray(bg_img);
fg = im2double(grayFrame)-im2double(grayBG);
fg = medfilt2(fg, [5 5]);
fgBlob = zeros(size(fg),'uint8');
fgBlob(abs(fg*255)>thr)=1;



end