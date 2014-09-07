
function [mn files]= mk_testGradVar

% filePath = 'C:\zxk\Research\monkey\monkey_cppPrj\testHOG\FPpatches';
filePath = 'C:\zxk\Research\monkeyData\Camera3_labeledVideos_Patch_Neg';
files = dir([filePath '\*.png']);

hy = fspecial('sobel');
hx = hy';
mn = zeros(length(files),1);
for i=1:length(files)
    I = imread([filePath '\' files(i).name]);
    gray = double(rgb2gray(I));
    Ix = imfilter(gray, hx, 'replicate');
    Iy = imfilter(gray, hy, 'replicate');
    Ig = 0.5*abs(Ix)+0.5*abs(Iy);
    mn(i) = mean2(Ig);
    fprintf('image %d mean is: %f\n',i,mn(i));
end

plot(mn);

end