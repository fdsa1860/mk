% display vbb data

Wmonkey = convertVbbData;

inputFileDir1='.\cam1_320x240_jpg';
inputFileType='.jpg'; 

firstFrame = 122500;
lastFrame = 123000;

for frameNo=firstFrame:lastFrame
    inputFileName=['Temp1-' num2str(frameNo) inputFileType];
    if exist([inputFileDir1 '\' inputFileName],'file')
        currFrame=imread([inputFileDir1 '\' inputFileName]);
    end
    % read input frame
    figure(1);
    imshow(currFrame);
    title(['Frame ' num2str(frameNo)]);
end