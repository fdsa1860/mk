clear;close all;
addpath(genpath('c:/zxk/toolbox'));

% Frame 77100 (Temp1-89934.png): no monkeys on bench, take right half
% Frame 8900 (Temp1-108899.png): no monkeys on left half, take left half
% Frame 77100: take a patch to fix the monkey at the corner of frame 8900
inputFileDir='G:\OctaviaCamps_NEU\Camera1';
outputFileDir='./data';
frame77100=imread([inputFileDir '\' 'Temp1-89934.png']);
bg_img1 = zeros(size(frame77100),'uint8');
bg_img1(:,1:542,:)=frame77100(:,1:542,:);
frame8900=imread([inputFileDir '\' 'Temp1-108899.png']);
bg_img1(:,543:end,:)=frame8900(:,543:end,:);
bg_img1(346:450,580:677,:)=frame77100(346:450,580:677,:);
figure;
imshow(bg_img1);
outputFileName=[outputFileDir '/' 'bg_img1'];
save  (outputFileName, 'bg_img1');
imwrite(bg_img1,[outputFileDir '/' 'bg_img1.png']);

% Frame 77100 (Temp1-89934.png): no monkeys on bench, take right half
% Frame 8900 (Temp1-108899.png): no monkeys on left half, take left half
inputFileDir='G:\OctaviaCamps_NEU\Camera2';
outputFileDir='./data';
frame77100=imread([inputFileDir '\' 'Temp1-89934.png']);
bg_img2 = zeros(size(frame77100),'uint8');
bg_img2(:,535:end,:)=frame77100(:,535:end,:);
frame8900=imread([inputFileDir '\' 'Temp1-108899.png']);
bg_img2(:,1:536,:)=frame8900(:,1:536,:);
figure;
imshow(bg_img2);
outputFileName=[outputFileDir '/' 'bg_img2'];
save  (outputFileName, 'bg_img2');
imwrite(bg_img2,[outputFileDir '/' 'bg_img2.png']);

% Frame 77100 (Temp1-89934.png): no monkeys on bench, take right half
% Frame 8900 (Temp1-108899.png): no monkeys on left half, take left half
% Frame 33000 (Temp1-132999.png): no object at the left botton corner
inputFileDir='G:\OctaviaCamps_NEU\Camera3';
outputFileDir='./data';
frame77100=imread([inputFileDir '\' 'Temp1-89934.png']);
bg_img3 = zeros(size(frame77100),'uint8');
bg_img3(:,661:end,:)=frame77100(:,661:end,:);
frame8900=imread([inputFileDir '\' 'Temp1-108899.png']);
bg_img3(:,1:660,:)=frame8900(:,1:660,:);
frame33000=imread([inputFileDir '\' 'Temp1-132999.png']);
bg_img3(800:1000,1:640,:)=frame33000(800:1000,1:640,:);
figure;
imshow(bg_img3);
outputFileName=[outputFileDir '/' 'bg_img3'];
save  (outputFileName, 'bg_img3');
imwrite(bg_img3,[outputFileDir '/' 'bg_img3.png']);

% Frame 77100 (Temp1-89934.png): no monkeys on bench, take right half
inputFileDir='G:\OctaviaCamps_NEU\Camera4';
outputFileDir='./data';
frame77100=imread([inputFileDir '\' 'Temp1-89934.png']);
bg_img4 = frame77100;
figure;
imshow(bg_img4);
outputFileName=[outputFileDir '/' 'bg_img4'];
save  (outputFileName, 'bg_img4');
imwrite(bg_img4,[outputFileDir '/' 'bg_img4.png']);



