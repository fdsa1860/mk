
function mk_bgSubtraction

close all;
addpath(genpath('ColorDetection'));
bg_img = imread('./data/bg_img4.png');

inputFileDir1='C:\zxk\Research\monkeyData\Camera1_extractedVideos\_extracted_277';
inputFileDir2='C:\zxk\Research\monkeyData\Camera2_labeledVideos\_extracted_277';
inputFileDir3='C:\zxk\Research\monkeyData\Camera3_labeledVideos\_extracted_277';
inputFileDir4='C:\zxk\Research\monkeyData\Camera4_labeledVideos\_extracted_277';
inputFileDir = inputFileDir4;
inputFileType='.png'; % modify file type name if necessary

scale = 0.5;
pattSiz = 5;
difTH = 30;

firstFrame = 98051;
lastFrame = 98263;
% offset = 60;
offset = 77; % cam4
% offset = 71; % cam3
for frameNo=firstFrame+offset:lastFrame
    % read input frame
    inputFileName=['Temp1-' num2str(frameNo) inputFileType];
    if exist([inputFileDir '\' inputFileName],'file')
        currFrame=imread([inputFileDir '\' inputFileName]);
    end
    %     currFrame = imresize(currFrame,scale);
    
%     % Normalization
%     bg_img=rgbnormalization(bg_img);
%     currFrame=rgbnormalization(currFrame);
    % Get raw foreground
    dif =abs(double(rgb2gray(bg_img))-double(rgb2gray(currFrame)));
    I1=uint8(255*(dif>difTH)); % you may modify this 150
    %     imshow(I1);
    % Morphology
    se=strel('ball',pattSiz,pattSiz); % you may modify this 15
    I2 = imdilate(I1,se);
    I2=imerode(I2,se);
    %     imshow(I2);
    % Combine img with blob
    I = bsxfun(@times,currFrame,I2/uint8(255));
    figure(1);imshow(I);
    I = imresize(I,scale);
    save temp I;
%     dif = abs(double(rgb2gray(bg_img))-double(rgb2gray(currFrame)));
%     I2 = uint8(255*(dif>difTH));
%     I = bsxfun(@times,currFrame,I2/uint8(255));
%     figure(1);imshow(I);
    
    %     pause(1);
    keyboard;
end

end