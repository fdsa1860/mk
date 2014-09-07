% Created by Xikang Zhang, 11/26/2012
% monkey main function, version 0.3
% implementation using class MK
% use vbb to manually label object of interest
% load trajectory files and plot trajectories
% save as video if possible

% Modified by Xikang Zhang, 04/18/2013
% use original data instead of the downsampled ones
% load vbb labels and display
% enable to use RSPCA for smoothing

addpath(genpath('C:\zxk\toolbox'));
addpath(genpath('C:\zxk\Research\code3.0.0'));
addpath(genpath('.\SRPCA_clean'));

% fileName="";
inputFileDir1='C:\zxk\Research\monkeyData\video20121011_cam1_extracted\_extracted_009';
inputFileDir2='.\cam2_320x240_jpg';
inputFileDir3='.\cam3_320x240_jpg';
inputFileDir4='C:\zxk\Research\monkeyData\Camera4_extractedVideos\_extracted_100';
inputFileDir = inputFileDir1;
inputFileType='.png'; % modify file type name if necessary
outputFileDir='';

% Load annotation from disk (in .txt format):
A = vbb('vbbLoadTxt', [inputFileDir '\' '_extracted_009.vbb'] );
nMonkeys = length(A.objLbl);
traj(1:nMonkeys) = struct('bb',[],'fr',[]);
% brightness = [];
% brightnessPt = [];

% firstFrame = 134700;
% lastFrame = 134900;
% firstFrame = 89934;
% lastFrame = 90034;
% firstFrame = 108899;
% lastFrame = 109000;
% firstFrame = 121668;
% lastFrame = 122068;
firstFrame = 322799;
lastFrame = 324337;
count = 0;
for frameNo=firstFrame:lastFrame
    % read input frame
    inputFileName=['cam1-' num2str(frameNo) inputFileType];
    if exist([inputFileDir '\' inputFileName],'file')
        currFrame=imread([inputFileDir '\' inputFileName]);
    end
    
    % initialization
    if frameNo==firstFrame
        %         frameInit();
        %         load './data/bg_img4';
%         load xc1yc1_clean;
        mk=MK(currFrame,[],frameNo);
        %         histo=zeros(lastFrame-firstFrame,1);
%         xc1=zeros(lastFrame-firstFrame,1);
%         yc1=zeros(lastFrame-firstFrame,1);
%         xc2=zeros(lastFrame-firstFrame,1);
%         yc2=zeros(lastFrame-firstFrame,1);
        %         bb_saved=cell(lastFrame-firstFrame,1);
        %         ind=zeros(lastFrame-firstFrame,1);
        xc1=[];yc1=[];
        continue;
    end
    % process frames
        mk=mk.frameProcess2(currFrame,A.objLists{frameNo-firstFrame+1});
    %     mk=mk.frameProcess(currFrame);
    % mk = mk.frameProcess3(currFrame);
    % brightness = [brightness mk.brightnessValue];
    % brightnessPt = [brightnessPt mk.brightnessValuePt];
    %     histo(frameNo-firstFrame)=mk.nDiffPixels;
%     mk.currFrame=currFrame;
%     mk.frameNo=frameNo;
%     currObj = A.objLists{frameNo-firstFrame+1};
%     for i=1:length(currObj)
%         id = currObj(i).id;
%         traj(id).bb(end+1,:) = currObj(i).pos;
%         traj(id).fr(end+1) = frameNo;
%     end
    %     bb_saved{frameNo-firstFrame}=mk.bb;
    
    
    % Display frames
    mk.disp();
    % mk.disp3();
    % figure(1);
    % subplot(2,2,3);
    % hold on;
    % plot(brightness,'.');
    % hold off;
    % subplot(2,2,4);
    % hold on;
    % plot(brightnessPt,'.');
    % hold off;
    
    
    
    
    
%     if traj(2).fr(end)==frameNo
% %         rectangle('Position',bb_saved{frameNo-firstFrame}(ind(frameNo-firstFrame),:),'EdgeColor','r' );
%         bb1=traj(2).bb(end,:);        
%         xc1(end+1)=round(bb1(1)+bb1(3)/2);
%         yc1(end+1)=round(bb1(2)+bb1(4)/2);
%     end    
    %     if ind2(frameNo-firstFrame)~=0
    %         rectangle('Position',bb_saved{frameNo-firstFrame}(ind2(frameNo-firstFrame),:),'EdgeColor','g' );
    %             bb2=bb_saved{frameNo-firstFrame}(ind2(frameNo-firstFrame),:);
    %     xc2(frameNo-firstFrame)=round(bb2(1)+bb2(3)/2);
    %     yc2(frameNo-firstFrame)=round(bb2(2)+bb2(4)/2);
    %     end
    
    
    
    %     if any(xc1) && any(yc1)
    %         plot(xc1(xc1~=0 & yc1~=0), yc1(xc1~=0 & yc1~=0),'r+');
    %     end
    %     if any(xc2) && any(yc2)
    %         plot(xc2(xc2~=0 & yc2~=0), yc2(xc2~=0 & yc2~=0),'g+');
    %     end
%     hold on;
%     plot(xc1,yc1,'r+');
% %     plot(xc1_clean(1:frameNo-firstFrame),yc1_clean(1:frameNo-firstFrame),'r+');
%     hold off;
    
    % xc1_curr=xc1_cleaned(1:frameNo-firstFrame);
    % yc1_curr=yc1_cleaned(1:frameNo-firstFrame);
    % xc2_curr=xc2_cleaned(1:frameNo-firstFrame);
    % yc2_curr=yc2_cleaned(1:frameNo-firstFrame);
    %     if any(xc1_curr) && any(yc1_curr)
    %         plot(xc1_curr(xc1_curr~=0 & yc1_curr~=0), yc1_curr(xc1_curr~=0 & yc1_curr~=0),'r');
    %     end
    %     if any(xc2_curr) && any(yc2_curr)
    %         plot(xc2_curr(xc2_curr~=0 & yc2_curr~=0), yc2_curr(xc2_curr~=0 & yc2_curr~=0),'g');
    %     end
    %     hold off;
    %     [xx yy]=ginput(1);
    %     for i=1:size(mk.bb,1)
    %         if xx>=mk.bb(i,1) && xx<=(mk.bb(i,1)+mk.bb(i,3)-1) &&...
    %                 yy>=mk.bb(i,2) && yy<=(mk.bb(i,2)+mk.bb(i,4)-1)
    %             ind(frameNo-firstFrame)=i;
    %             break;
    %         end
    %     end
    %         pause;
    % M(frameNo-firstFrame)=getframe;
end

% [hopt eopt e2opt]=SRPCA_e1_e2_clean(xc1,5,1000,ones(size(xc1)));
% xc1_cleaned=SRPCA_e1_e2_clean(xc1(1:70),50,100000,ones(size(xc1(1:70))));
% xc1_cleaned=[xc1_cleaned;zeros(size(xc1,1)-70,1)];
% yc1_cleaned=SRPCA_e1_e2_clean(yc1(1:70),50,100000,ones(size(yc1(1:70))));
% yc1_cleaned=[yc1_cleaned;zeros(size(yc1,1)-70,1)];
% xc2_cleaned=SRPCA_e1_e2_clean(xc2(31:end),50,100000,ones(size(xc2(31:end))));
% xc2_cleaned=[zeros(30,1);xc2_cleaned];
% yc2_cleaned=SRPCA_e1_e2_clean(yc2(31:end),50,100000,ones(size(yc2(31:end))));
% yc2_cleaned=[zeros(30,1);yc2_cleaned];
% save ./data/xcyc_cleaned xc1_cleaned yc1_cleaned xc2_cleaned yc2_cleaned;
% movie2avi(M,'./data/mk_37150to37244.avi','COMPRESSION','None','FPS',5);

% % display results
% figure(2);
% plot(histo);

