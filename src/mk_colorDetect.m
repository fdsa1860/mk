% test HOG detection

addpath(genpath('C:\zxk\Research\zz_libsvm-3.11\matlab'));
load model_color20130321;
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
img_hsv = rgb2hsv_fast(img);
I = img_hsv(:,:,1);


for sh = scale
    for sw = scale
        winHgt = round(winHgtOrig*sh);
        winWid = round(winWidOrig*sw);
        for i=1:step:imgHgt-winHgt
            for j=1:step:imgWid-winWid
                rect = [j i winWid winHgt];
                patch = I(rect(2):rect(2)+rect(4),rect(1):rect(1)+rect(3));
                histo = histc(patch(:),0:4:256);
                f = histo'/sum(histo);
                [predicted_label, accuracy, decision_values] = svmpredict(testing_label_vector, f, model);
                %                 if decision_values>1.4
                decision_values
                if decision_values>0
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