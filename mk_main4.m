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
inputFileDir1='C:\zxk\Research\monkeyData\Camera1_extractedVideos\_extracted_100';
inputFileDir2='C:\zxk\Dropbox\monkey\cam2_320x240_jpg';
inputFileDir3='C:\zxk\Dropbox\monkey\cam3_320x240_jpg';
inputFileDir4='C:\zxk\Dropbox\monkey\cam4_320x240_jpg';
inputFileDir=inputFileDir1;
inputFileType='.png'; % TODO: modify file type name
outputFileDir='';

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

% load ('./data/files');
% load ('./data/bb_saved');
% load ('./data/ind');
% load ('./data/ind2');
% load ('./data/xcyc_cleaned');

% numframes = length(files);
firstFrame = 121668;
lastFrame = 122068;
% firstFrame = 34700;
% lastFrame = 34950;


for frameNo=firstFrame:lastFrame
        % read input frame
    inputFileName=['Temp1-' num2str(frameNo) inputFileType];
    if exist([inputFileDir '\' inputFileName],'file')
        currFrame=imread([inputFileDir '\' inputFileName]);
    end    
    % initialization
%     if frameNo==firstFrame
        %         frameInit();
%         load './data/bg_img1';
%         mk=MK(currFrame,bg_img1,frameNo);
%         bb_saved=cell(lastFrame-firstFrame,1);
%         ind=zeros(lastFrame-firstFrame,1);

%         continue;
%     end
    % process frames
%     mk=mk.frameProcess(currFrame);    
%     bb_saved{frameNo-firstFrame}=mk.bb;


    % Display frames
%     mk.disp();

figure(1);imshow(currFrame);delay(1);
    
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




