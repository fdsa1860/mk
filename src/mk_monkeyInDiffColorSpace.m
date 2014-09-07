% show color features

function mk_monkeyInDiffColorSpace

clc;clear all;close all;

currFrame=imread('C:\zxk\Research\monkeyData\Camera1_extractedVideos\_extracted_100\Temp1-121668.png');

figure;imshow(currFrame);colormap(jet);title('Original');

figure;imshow(currFrame(:,:,1));colormap(jet);title('RGB_R');
figure;imshow(currFrame(:,:,2));colormap(jet);title('RGB_G');
figure;imshow(currFrame(:,:,3));colormap(jet);title('RGB_B');

imghsv = rgb2hsv(currFrame);
figure;imshow(imghsv(:,:,1));colormap(jet);title('HSV_H');
figure;imshow(imghsv(:,:,2));colormap(jet);title('HSV_S');
figure;imshow(imghsv(:,:,3));colormap(jet);title('HSV_V');

lab = rgb2lab(currFrame);
figure;imshow(lab(:,:,1)/100);colormap(jet);title('LAB_L');
figure;imshow((lab(:,:,2)+110)/220);colormap(jet);title('LAB_A');
figure;imshow((lab(:,:,3)+110)/220);colormap(jet);title('LAB_B');

imgYCbCr = rgb2ycbcr(currFrame);
figure;imshow(imgYCbCr(:,:,1));colormap(jet);title('YCbCr_Y');
figure;imshow(imgYCbCr(:,:,2));colormap(jet);title('YCbCr_Cb');
figure;imshow(imgYCbCr(:,:,3));colormap(jet);title('YCbCr_Cr');

end