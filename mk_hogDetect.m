% test HOG detection

addpath(genpath('C:\zxk\Research\zz_libsvm-3.11\matlab'));
load model20130320;
img = imread('C:\\zxk\\Research\\monkeyData\\illumination1\\illumination0000.jpeg');
% [lb, H] = libsvmread('C:\zxk\Research\monkey\monkey_MatlabPrj\hog.txt');
% [predicted_label, accuracy, decision_values] = svmpredict(lb(1), H(1,:), model)

imgHgt = size(img,1);
imgWid = size(img,2);
winHgtOrig = 40;
winWidOrig = 40;
step = 10;
scale = 0.5:0.5:2;
% detection = zeros(10,4);
detection = [];
dv = [];

testing_label_vector = 1;
I = rgb2gray(img);

for sh = scale
    for sw = scale
        winHgt = round(winHgtOrig*sh);
        winWid = round(winWidOrig*sw);
        for i=1:step:imgHgt-winHgt
            for j=1:step:imgWid-winWid
                rect = [j i winWid winHgt];
                patch = I(rect(2):rect(2)+rect(4),rect(1):rect(1)+rect(3));
                h = HOG(patch)';
                [predicted_label, accuracy, decision_values] = svmpredict(testing_label_vector, h, model);
                %                 if decision_values>1.4
                if decision_values>1.8
                    detection = [detection;rect];
                    dv = [dv decision_values];
                    detection
                end
                %                 [predicted_label ]
                %                     [accuracy ]
                %                     [decision_values]
                %                 rect
            end
        end
        fprintf('scale [%f %f]\n',sh,sw);
    end
end



% save detection20130319 detection;