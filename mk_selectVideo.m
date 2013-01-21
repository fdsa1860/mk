% monkey main function
% Xikang Zhang, 10/08/2012

addpath(genpath('C:\zxk\toolbox'));

% fileName="";
inputFileDir1='.\cam1_320x240_jpg';
inputFileDir2='.\cam2_320x240_jpg';
inputFileDir3='.\cam3_320x240_jpg';
inputFileDir4='.\cam4_320x240_jpg';
% inputFileDir1='F:\OctaviaCamps_NEU\Camera1';
% inputFileDir2='F:\OctaviaCamps_NEU\Camera2';
% inputFileDir3='F:\OctaviaCamps_NEU\Camera3';
% inputFileDir4='F:\OctaviaCamps_NEU\Camera4';
inputFileDir=inputFileDir3;
inputFileType='.jpg'; % TODO: modify file type name
% inputFileType='.png';
outputFileDir='';

% if ~isempty(inputFileDir)
%     if isdir(inputFileDir)
%         files=dir([inputFileDir '\*' inputFileType]);
%     else
%         error('input directory does not exist!');
%     end
% end
% if ~isempty(outputFileDir)
%     if ~isdir(outputFileDir)
%         mkdir(outputFileDir);
%     end
% end

% numframes = length(files);
% firstFrame = 86400;
% lastFrame = 173400;
% firstFrame = 88400;
% lastFrame = 89000;
% firstFrame = 134700;
% lastFrame = 135200;

% firstFrame = 86400+2000;
% lastFrame = 86400+2500;

firstFrame = 122500;
lastFrame = 123000;

for frameNo=firstFrame:lastFrame
    % read input frame
    inputFileName=['Temp1-' num2str(frameNo) inputFileType];
    if exist([inputFileDir1 '\' inputFileName],'file')
        currFrame1=imread([inputFileDir1 '\' inputFileName]);
    end
    if exist([inputFileDir2 '\' inputFileName],'file')
        currFrame2=imread([inputFileDir2 '\' inputFileName]);
    end
    if exist([inputFileDir3 '\' inputFileName],'file')
        currFrame3=imread([inputFileDir3 '\' inputFileName]);
    end
    if exist([inputFileDir4 '\' inputFileName],'file')
        currFrame4=imread([inputFileDir4 '\' inputFileName]);
    end
    % initialization
    if frameNo==firstFrame
        %         frameInit();
        previousFrame1=currFrame1;
        previousFrame2=currFrame2;
        previousFrame3=currFrame3;
        previousFrame4=currFrame4;
        histo=zeros(lastFrame-firstFrame,1);
        y1=zeros(lastFrame-firstFrame,1);
        y2=zeros(lastFrame-firstFrame,1);
        y3=zeros(lastFrame-firstFrame,1);
        y4=zeros(lastFrame-firstFrame,1);        
        continue;
    end
    % process frames
    y1(frameNo-firstFrame) = frameDiff(previousFrame1,currFrame1,10);
    y2(frameNo-firstFrame) = frameDiff(previousFrame2,currFrame2,10);
    y3(frameNo-firstFrame) = frameDiff(previousFrame3,currFrame3,10);
    y4(frameNo-firstFrame) = frameDiff(previousFrame4,currFrame4,10);
    histo=y1+y2+y3+y4;
    
    previousFrame1=currFrame1;
    previousFrame2=currFrame2;
    previousFrame3=currFrame3;
    previousFrame4=currFrame4;
    
    % Display frames    
    h1=figure(1);
    subplot(2,2,1);
    imshow(currFrame1);
    title(['Cam 1, frame ' num2str(frameNo)]);
    subplot(2,2,2);
    imshow(currFrame2);
    title(['Cam 2, frame ' num2str(frameNo)]);
    subplot(2,2,3);
    imshow(currFrame3);
    title(['Cam 3, frame ' num2str(frameNo)]);
    subplot(2,2,4);
    imshow(currFrame4);
    title(['Cam 4, frame ' num2str(frameNo)]);
    
    %     pause;
    M(frameNo-firstFrame)=getframe(h1);
end

% display results
figure(2);
plot([histo y1 y2 y3 y4]);
legend h y1 y2 y3 y4

