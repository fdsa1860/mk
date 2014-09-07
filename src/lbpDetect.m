% use sliding window to detect objects

function [bbox,prob] = lbpDetect(I,model)

if nargin == 0
    load lbp_model_temp;
    I = imread('cam1_sample2.png');
    %     I = imresize(I,0.5);
end

% profile on;
addpath('C:\zxk\Research\zz_fdtool_release');

try
    Nx                                 = 60;
    Ny                                 = 60;
    options.N                          = [8 , 4];
    options.R                          = [1 , 1];
    options.map                        = zeros(2^max(options.N) , length(options.N));
    mapping                            = getmapping(options.N(1),'u2');
    options.map(1:2^options.N(1) , 1)  = mapping.table';
    options.map(1:2^options.N(2) , 2)  = (0:2^options.N(2)-1)';
    options.shiftbox                   = cat(3 , [Ny , Nx ; 1 , 1] , [16 , 16 ; 4 , 4]);
    
    img = rgb2gray(I);
    [imgH,imgW] = size(img);
    winSize = 60;
    winStep = 10;
    numIterX = floor((imgW-winSize)/winStep+1);
    numIterY = floor((imgH-winSize)/winStep+1);
    numIter = numIterX*numIterY;
    bboxAll = zeros(numIter,4);
    lbpAll = zeros(numIter,2363,'uint32');
    s = 1;
    for x=1:winStep:(imgW-winSize+1)
        for y=1:winStep:(imgH-winSize+1)
            currPatch = img(y:y+winSize-1,x:x+winSize-1);
            lbp = chlbp(currPatch , options);
            lbpAll(s,:) = lbp';
            bboxAll(s,:) = [x y winSize winSize];
            s = s + 1;
        end
    end
    lbpAll = double(lbpAll);
    [label, accuracy, prob_estimates] = svmpredict(ones(size(lbpAll,1),1),lbpAll,model);
    bbox = bboxAll(label==1,:);
    prob = prob_estimates(label==1,:);
    
    % display
    figure(1);clf;
    imshow(I);
    hold on;
    for i=1:size(bbox,1)
        rectangle('Position',bbox(i,:),'EdgeColor','r');
    end
    hold off;
    rmpath('C:\zxk\Research\zz_fdtool_release');
catch me
    rmpath('C:\zxk\Research\zz_fdtool_release');
end


% profile viewer