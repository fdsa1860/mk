% monkey main function
% for multiple objects tracking
% Xikang Zhang, 10/28/2012
function mk_main

addpath('C:\zxk\toolbox');


inputFileDir1='C:\zxk\Research\monkeyData\Camera1_extractedVideos\_extracted_100';
inputFileDir2='C:\zxk\Research\monkeyData\20121011\camera2';
inputFileDir3='C:\zxk\Research\monkeyData\Camera3_labeledVideos\_extracted_277';
inputFileDir4='C:\zxk\Research\monkeyData\Camera4_extractedVideos\_extracted_100';
inputFileDir=inputFileDir2;
inputFileType='.png'; % modify file type name if needed
outputFileDir='';

% if ~isempty(inputFileDir)
%     if isdir(inputFileDir)
%         files=dir([inputFileDir '/' inputFileType]);
%     else
%         error('input directory does not exist!');
%     end
% end
% if ~isempty(outputFileDir)
%     if ~isdir(outputFileDir)
%         mkdir(outputFileDir);
%     end
% end

bg_img1 = imread('C:\zxk\Research\monkeyData\20121011\Background\cam2-238059.png');

% numframes = length(files);
% firstFrame = 37150;
% lastFrame = 37244;
% for frameNo=firstFrame:lastFrame
%     % read input frame
%     currFrame=imread([inputFileDir '\' files(frameNo).name]);
scale = 1;
% firstFrame = 121668;
% lastFrame = 122068;
% firstFrame = 98051+100;
% lastFrame = 98263;
firstFrame = 307110;
lastFrame = firstFrame + 100;
for frameNo=firstFrame:lastFrame
    % read input frame
    inputFileName=['cam2-' num2str(frameNo) inputFileType];
    if exist([inputFileDir '\' inputFileName],'file')
        currFrame=imread([inputFileDir '\' inputFileName]);
    end
    currFrame = imresize(currFrame,scale);
    % initialization
    if frameNo==firstFrame
        %         frameInit();
        mk=MK(currFrame,bg_img1,frameNo);
        continue;
    end
    % process
    %     frameProcess();
    mk=mk.frameProcess(currFrame);
    % show frame
    %     frameDisplay();
    figure(1);
    mk.disp1();    
%     keyboard;
    pause;
end

% display results
% resultDisplay();
end
