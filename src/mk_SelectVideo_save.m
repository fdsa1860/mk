function mk_SelectVideo_save

tic

inputFileDir1='.\cam1_320x240_jpg';
inputFileDir2='.\cam2_320x240_jpg';
inputFileDir3='.\cam3_320x240_jpg';
inputFileDir4='.\cam4_320x240_jpg';
inputFileType='.jpg';

outputFileDir='.\extractedVideo';
if exist(outputFileDir,'dir')
    rmdir(outputFileDir,'s');
end
mkdir(outputFileDir);

load '.\data\histo086400to173400.mat';
thres = 0.01;
isNew = false;
extractionCount=0;
minFrames = 15;
numFramesBeforeNew = 60;
currFolder = [];
currCounter = 0;


% firstFrame = 134700;
% lastFrame = 135000;
% firstFrame = 122500;
% lastFrame = 123000;
firstFrame = 86401;
lastFrame = 173400;
InitialFrameNo = 86401;

for frameNo=firstFrame:lastFrame
    if histo(frameNo-InitialFrameNo+1) > thres
        if isNew == true
            isNew = false;
            extractionCount = extractionCount + 1;
            currFolder=[outputFileDir '\' inputFileDir1(3:end) ...
                sprintf('_extracted_%d',extractionCount)];
            assert(~exist(currFolder,'dir'));
            mkdir(currFolder);
        end
        inputFileName=['Temp1-' num2str(frameNo) inputFileType];
        if exist([inputFileDir1 '\' inputFileName],'file')
            copyfile([inputFileDir1 '\' inputFileName],currFolder);
        end
        currCounter = 0;
    elseif currCounter <= numFramesBeforeNew
        inputFileName=['Temp1-' num2str(frameNo) inputFileType];
        if exist([inputFileDir1 '\' inputFileName],'file') && ...
            exist(currFolder,'dir')
            copyfile([inputFileDir1 '\' inputFileName],currFolder);
        end
        currCounter = currCounter + 1;
    else
        isNew = true;
        % if the extracted frames are too few, throw them away
        if exist(currFolder,'dir')
            tempList = dir(currFolder);
            if length(tempList)-2 < minFrames
                rmdir(currFolder,'s');
                extractionCount = extractionCount - 1;
            end
        end
    end
    
    
    % read input frame
    
    %     if exist([inputFileDir2 '\' inputFileName],'file')
    %         currFrame2=imread([inputFileDir2 '\' inputFileName]);
    %     end
    %     if exist([inputFileDir3 '\' inputFileName],'file')
    %         currFrame3=imread([inputFileDir3 '\' inputFileName]);
    %     end
    %     if exist([inputFileDir4 '\' inputFileName],'file')
    %         currFrame4=imread([inputFileDir4 '\' inputFileName]);
    %     end
    
    
    
end

toc

end