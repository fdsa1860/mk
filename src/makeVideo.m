function makeVideo

inputFileDir = 'C:\zxk\Research\monkeyData\Camera1_extractedVideos\_extracted_152';
% inputFileType='.png';
% inputFileDir = 'C:\zxk\Research\iccv13code\video009codeModified_start1end1500order10epsilon005';
% inputFileDir = 'C:\zxk\Research\iccv13code\video009_avoidHeuristic_start1end500';
% inputFileDir = 'C:\zxk\Research\iccv13code\output';
% inputFileDir = 'C:\zxk\Research\monkey\monkey_MatlabPrj\2DTrackingNNColorKalman\output';
% inputFileDir = 'C:\zxk\Research\monkeyData\cam2-127388\cam2-127889';
% inputFileType='.jpeg';
% inputFileDir = 'C:\zxk\Research\monkeyData\video20121011_cam1_extracted\_extracted_002';
inputFileType = '.png';

% scale = 0.5;
scale = 1;

if ~isempty(inputFileDir)
    if isdir(inputFileDir)
        files=dir([inputFileDir '\*' inputFileType]);
    else
        error('input directory does not exist!');
    end
end

a = {files.name};
[b,c]=sort(a);
files = files(c);

writerObj = VideoWriter('cam1_extracted_152');
writerObj.FrameRate = 10;
open(writerObj);

for frameNo=1:length(files)
% for frameNo=1:500
    % read input frame
    if exist([inputFileDir '\' files(frameNo).name],'file')
        currFrame=imread([inputFileDir '\' files(frameNo).name]);
    end
    currFrame = imresize(currFrame,scale);
    figure(1);
    imshow(currFrame);
    title(['Frame ' num2str(frameNo)]);
%     videoObj.frames(frameNo) = im2frame(currFrame);
%     videoObj.times(frameNo) = frameNo/25;
    writeVideo(writerObj,currFrame);
    pause(0.05);
end
% videoObj.width=size(videoObj.frames(1).cdata,2);
% videoObj.height=size(videoObj.frames(1).cdata,1);

% mmwrite('result_newVideo_cam2_frame97290to97389.wmv',videoObj);
close(writerObj);

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