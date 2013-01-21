clear;close all;
addpath(genpath('c:/zxk/toolbox'));

% fileName="";
inputFileDir='.\cam3_320x240_jpg';
outputFileDir='./data';

% Frame 77100 (Temp1-89934.jpg): no monkeys on bench, take right half
% Frame 8900 (Temp1-108899.jpg): no monkeys on left half, take left half
% Frame 33000 (Temp1-132999.jpg): no object at the left botton corner

frame77100=imread([inputFileDir '\' 'Temp1-89934.jpg']);
bg_img3 = zeros(size(frame77100),'uint8');
bg_img3(:,161:end,:)=frame77100(:,161:end,:);
frame8900=imread([inputFileDir '\' 'Temp1-108899.jpg']);
bg_img3(:,1:160,:)=frame8900(:,1:160,:);
frame33000=imread([inputFileDir '\' 'Temp1-132999.jpg']);
bg_img3(200:240,1:160,:)=frame33000(200:240,1:160,:);
figure;
imshow(bg_img3);
outputFileName=[outputFileDir '/' 'bg_img3'];
save  (outputFileName, 'bg_img3');
imwrite(bg_img3,[outputFileDir '/' 'bg_img3.jpg']);

inputFileDir='.\cam1_320x240_jpg';
outputFileDir='./data';

% Frame 77100 (Temp1-89934.jpg): no monkeys on bench, take right half
% Frame 8900 (Temp1-108899.jpg): no monkeys on left half, take left half
frame77100=imread([inputFileDir '\' 'Temp1-89934.jpg']);
bg_img1 = zeros(size(frame77100),'uint8');
bg_img1(:,1:133,:)=frame77100(:,1:133,:);
frame8900=imread([inputFileDir '\' 'Temp1-108899.jpg']);
bg_img1(:,134:end,:)=frame8900(:,134:end,:);

figure;
imshow(bg_img1);
outputFileName=[outputFileDir '/' 'bg_img1'];
save  (outputFileName, 'bg_img1');
imwrite(bg_img1,[outputFileDir '/' 'bg_img1.jpg']);

inputFileDir='.\cam2_320x240_jpg';
outputFileDir='./data';
% Frame 77100 (Temp1-89934.jpg): no monkeys on bench, take right half
% Frame 8900 (Temp1-108899.jpg): no monkeys on left half, take left half
frame77100=imread([inputFileDir '\' 'Temp1-89934.jpg']);
bg_img2 = zeros(size(frame77100),'uint8');
bg_img2(:,128:end,:)=frame77100(:,128:end,:);
frame8900=imread([inputFileDir '\' 'Temp1-108899.jpg']);
bg_img2(:,1:127,:)=frame8900(:,1:127,:);

figure;
imshow(bg_img2);
outputFileName=[outputFileDir '/' 'bg_img2'];
save  (outputFileName, 'bg_img2');
imwrite(bg_img2,[outputFileDir '/' 'bg_img2.jpg']);

inputFileDir='.\cam4_320x240_jpg';
outputFileDir='./data';
% Frame 77100 (Temp1-89934.jpg): no monkeys on bench, take right half
frame77100=imread([inputFileDir '\' 'Temp1-89934.jpg']);
bg_img4 = frame77100;

figure;
imshow(bg_img4);
outputFileName=[outputFileDir '/' 'bg_img4'];
save  (outputFileName, 'bg_img4');
imwrite(bg_img4,[outputFileDir '/' 'bg_img4.jpg']);



