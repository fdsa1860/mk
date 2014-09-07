function displayFrame

inputFileDir = 'C:\zxk\Research\monkeyData\20121011_cam1_ex009\ex009_00005';
% inputFileDir = 'C:\zxk\Research\monkeyData\cam2-127389\cam2-127389';
inputFileType='.png';
scale = 0.5;

% if ~isempty(inputFileDir)
%     if isdir(inputFileDir)
%         files=dir([inputFileDir '\*' inputFileType]);
%     else
%         error('input directory does not exist!');
%     end
% end

% firstFrame = 122500;
% lastFrame = 123000;
% firstFrame = 86400;
% lastFrame = 87400;
chasing1 = 309260:309330; % green -> yellow
displacement1 = 309580:309640; % red -> yellow
displacement2 = 310310:310385; % red ->yellow
proximity1 = 310554:310610; % yellow -> blue
proximity2 = 310650:310815; % yellow -> red

% firstFrame = 127389;
% lastFrame = firstFrame+99;
firstFrame = 322999;
lastFrame = firstFrame+49;

% for frameNo=1:length(files)
% for frameNo = proximity1
for frameNo = firstFrame:lastFrame
    % read input frame
    inputFileName=['cam1-' num2str(frameNo) inputFileType];
    if exist([inputFileDir '\' inputFileName],'file')
        currFrame=imread([inputFileDir '\' inputFileName]);
    end
%     currFrame=imread([inputFileDir '\' files(frameNo).name]);
    currFrame = imresize(currFrame,scale);
    figure(1);
    imshow(currFrame);
    title(['Frame ' num2str(frameNo)]);
    drawnow;
end