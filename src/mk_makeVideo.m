function mk_makeVideo

% inputFileDir =
% 'C:\zxk\Research\monkeyData\Camera3_extractedVideos\_extracted_170';
inputFileDir = 'C:\zxk\Research\iccv13code\video152codeModified_start1end60order5epsilon005';
inputFileType='.jpeg';
scale = 0.5;

if ~isempty(inputFileDir)
    if isdir(inputFileDir)
        files=dir([inputFileDir '\*' inputFileType]);
    else
        error('input directory does not exist!');
    end
end

aviObj = avifile('result_video152cam1_frame1to60.avi','quality',100);

for frameNo=1:length(files)
    % read input frame
    if exist([inputFileDir '\frame' num2str(frameNo) inputFileType],'file')
        currFrame=imread([inputFileDir '\frame' num2str(frameNo) inputFileType]);
    end
    currFrame = imresize(currFrame,scale);
    figure(1);
    imshow(currFrame);
    title(['Frame ' num2str(frameNo)]);
    aviObj = addFrame(aviObj,currFrame);
    pause(0.05);
end

aviObj = close(aviObj);

% firstFrame = 121668;
% lastFrame = 122068;
% firstFrame = 98051;
% lastFrame = 98156;
% offset = 0;
% for frameNo = firstFrame+offset:lastFrame
%     % read input frame
%     inputFileName = ['Temp1-' num2str(frameNo) inputFileType];
%     if exist([inputFileDir '\' inputFileName],'file')
%         currFrame=imread([inputFileDir '\' inputFileName]);
%     end
%     currFrame = imresize(currFrame,scale);
%     figure(1);
%     imshow(currFrame);
%     title(['Frame ' num2str(frameNo)]);
%     pause(0.05);
% end

end