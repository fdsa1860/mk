
% testHarris

inputFileDir1='.\cam1_320x240_jpg';
inputFileDir2='.\cam2_320x240_jpg';
inputFileDir3='.\cam3_320x240_jpg';
inputFileDir4='.\cam4_320x240_jpg';

inputFileDir=inputFileDir2;
inputFileType='.jpg'; % TODO: modify file type name
outputFileDir='';

firstFrame = 134700;
lastFrame = 134800;

for frameNo=firstFrame:lastFrame
    % read input frame
    inputFileName=['Temp1-' num2str(frameNo) inputFileType];
    if exist([inputFileDir '\' inputFileName],'file')
        currFrame=imread([inputFileDir '\' inputFileName]);
    end
    minNumOfCorners = 50;
    maxNumOfCorners = 100;
    corners = harris(currFrame,minNumOfCorners,maxNumOfCorners);
    figure(1);
    imshow(currFrame);
    hold on;
    plot(corners(:,2),corners(:,1),'*');
    hold off;

end