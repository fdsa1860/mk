% monkey main function, version 0.4
% implementation using class MK
% manually construct background, substract background
% segment foreground with connected component labelling
% crop the foreground and save as training samples

% Created by Xikang Zhang, 10/08/2012
% Modified by Xikang Zhang, 10/24/2012
% Modified by Xikang Zhang, 02/11/2012

addpath(genpath('C:\zxk\toolbox'));

% fileName="";
inputFileDir1='C:\zxk\Research\monkeyData\Camera1_extractedVideos\_extracted_277';
inputFileDir2='C:\zxk\Research\monkeyData\Camera2_labeledVideos\_extracted_277';
inputFileDir3='C:\zxk\Research\monkeyData\Camera3_labeledVideos\_extracted_277';
inputFileDir4='C:\zxk\Research\monkeyData\Camera4_labeledVideos\_extracted_277';
inputFileDir=inputFileDir3;
inputFileType='.png'; % TODO: modify file type name
outputFileDir='';
load detectionLog_cam3_277_nonMaxSup;

% if ~isempty(inputFileDir)
%     if isdir(inputFileDir)
%         files=dir([inputFileDir '\' inputFileType]);
%     else
%         error('input directory does not exist!');
%     end
% end
% if ~isempty(outputFileDir)
%     if ~isdir(outputFileDir)
%         mkdir(outputFileDir);
%     end
% end

scale = 0.5;

% load ('./data/files');
% load ('./data/bb_saved');
% load ('./data/ind');
% load ('./data/ind2');
% load ('./data/xcyc_cleaned');
bg_img = imread('./data/bg_img3.png');
bg_img = imresize(bg_img, scale);

% numframes = length(files);
% firstFrame = 121668;
% lastFrame = 122068;
% firstFrame = 96202;
% lastFrame = 96236;
% firstFrame = 96299;
% lastFrame = 96445;
% firstFrame = 97511;
% lastFrame = 97527;
% firstFrame = 97590;
% lastFrame = 97754;
% firstFrame = 99429;
% lastFrame = 99570;
firstFrame = 98051;
lastFrame = 98263;
for frameNo=firstFrame:lastFrame
        % read input frame
    inputFileName=['Temp1-' num2str(frameNo) inputFileType];
    if exist([inputFileDir '\' inputFileName],'file')
        currFrame=imread([inputFileDir '\' inputFileName]);
    end
    currFrame = imresize(currFrame, scale);
    % initialization
    if frameNo==firstFrame
        %         frameInit();        
        mk=MK(currFrame,bg_img,frameNo);
%         bb_saved=cell(lastFrame-firstFrame,1);
%         ind=zeros(lastFrame-firstFrame,1);

        continue;
    end
    % process frames
    mk=mk.frameProcess(currFrame);
%     bb_saved{frameNo-firstFrame}=mk.bb;
%     mk.currFrame=currFrame;
    mk.bb = detectionLog(detectionLog(:,1)==frameNo-firstFrame+1,2:5);
    mk.isTrgt = ones(size(mk.bb,1),1);

    % Display frames
    mk.disp();


% figure(1);imshow(currFrame);delay(1);

    
%     hold on;
%     if ind(frameNo-firstFrame)~=0
%         rectangle('Position',bb_saved{frameNo-firstFrame}(ind(frameNo-firstFrame),:),'EdgeColor','r' );
%             bb1=bb_saved{frameNo-firstFrame}(ind(frameNo-firstFrame),:);    
%     xc1(frameNo-firstFrame)=round(bb1(1)+bb1(3)/2);
%     yc1(frameNo-firstFrame)=round(bb1(2)+bb1(4)/2);
%     end
%     if ind2(frameNo-firstFrame)~=0
%         rectangle('Position',bb_saved{frameNo-firstFrame}(ind2(frameNo-firstFrame),:),'EdgeColor','g' );
%             bb2=bb_saved{frameNo-firstFrame}(ind2(frameNo-firstFrame),:);
%     xc2(frameNo-firstFrame)=round(bb2(1)+bb2(3)/2);
%     yc2(frameNo-firstFrame)=round(bb2(2)+bb2(4)/2);
%     end 
% 
% 
% 
%     hold off;

%         pause;
% M(frameNo-firstFrame)=getframe;
end




