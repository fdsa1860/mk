% display vbb data

% Wmonkey = convertVbbData;

inputFileDir1=fullfile('~','research','data','monkey','cam1-127388','cam1-127389');
inputFileType='.png'; 

firstFrame = 127389;
lastFrame = 127488;

for frameNo=firstFrame:lastFrame
    inputFileName=['cam1-' num2str(frameNo) inputFileType];
    inputFile = fullfile(inputFileDir1, inputFileName);
    if exist(inputFile,'file')
        currFrame=imread(inputFile);
    end
    % read input frame
    figure(1);
    imshow(currFrame);
    title(['Frame ' num2str(frameNo)]);
end