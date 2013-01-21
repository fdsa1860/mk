% sample monkey HD images
% Xikang Zhang, 10/06/2012

% fileName="";
% TODO: modify dir name and file type name
sampleRate = 4;
inputFileDir='F:/OctaviaCamps_NEU/Camera3';
inputFileType='*.png';
outputFileDir=['./cam3_S' num2str(sampleRate) '_jpg'];
outputFileType='*.jpg';

if ~isempty(inputFileDir)
    if isdir(inputFileDir)
        files=dir([inputFileDir '\' inputFileType]); 
    else
        error('input directory does not exist!');
    end
end
if ~isempty(outputFileDir)
    if ~isdir(outputFileDir)
        mkdir(outputFileDir);
    end
end


nFrames = length(files);
firstFrame = 1;
lastFrame = nFrames;

for frameNo=firstFrame:lastFrame
    %     % initialization
    %     if frameNo==firstFrame
    %         frameInit();
    %     end
    % process
    %     frameProcess();
    frame=imread([inputFileDir '\' files(frameNo).name]);
    sampledFrame=imresize(frame,1/sampleRate);
    if length(files(frameNo).name)==16
        files(frameNo).name=[files(frameNo).name(1:end-4) '.jpg'];
    elseif length(files(frameNo).name)==15
        files(frameNo).name=[files(frameNo).name(1:6) '0' files(frameNo).name(7:end-4) '.jpg'];
    else
        error('the length of file name is not right');
    end
    imwrite(sampledFrame,[outputFileDir '\' files(frameNo).name]);
    % show frame
    %     frameDisplay();
    fprintf('done with frame %d\n',frameNo);
end

% display results
% resultDisplay();

