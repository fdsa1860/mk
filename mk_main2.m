% monkey main function, version 0.3
% implementation using class MK
% use vbb to manually label object of interest
% load trajectory files and plot trajectories
% save as video if possible

% Created by Xikang Zhang, 11/26/2012


addpath(genpath('C:\zxk\toolbox'));
addpath(genpath('C:\zxk\code3.0.0'));

% fileName="";
inputFileDir1='.\cam1_320x240_jpg';
inputFileDir2='.\cam2_320x240_jpg';
inputFileDir3='.\cam3_320x240_jpg';
inputFileDir4='.\cam4_320x240_jpg';
inputFileDir=inputFileDir4;
inputFileType='.jpg'; % TODO: modify file type name
outputFileDir='';

% % Load annotation from disk (in .txt format):
% A = vbb('vbbLoadTxt', './data/Temp1-134700.txt' );
brightness = [];
brightnessPt = [];

% firstFrame = 134700;
% lastFrame = 134900;
% firstFrame = 89934;
% lastFrame = 90034;
% firstFrame = 108899;
% lastFrame = 109000;
firstFrame = 86400;
lastFrame = 173400;

for frameNo=firstFrame:lastFrame
    % read input frame
    inputFileName=['Temp1-' num2str(frameNo) inputFileType];
    if exist([inputFileDir '\' inputFileName],'file')
        currFrame=imread([inputFileDir '\' inputFileName]);
    end
    
    % initialization
    if frameNo==firstFrame
        %         frameInit();
        load './data/bg_img4';
        mk=MK(currFrame,bg_img4,frameNo);
%         histo=zeros(lastFrame-firstFrame,1);
%         xc1=zeros(lastFrame-firstFrame,1);
%         yc1=zeros(lastFrame-firstFrame,1);
%         xc2=zeros(lastFrame-firstFrame,1);
%         yc2=zeros(lastFrame-firstFrame,1);
%         bb_saved=cell(lastFrame-firstFrame,1);
%         ind=zeros(lastFrame-firstFrame,1);

        continue;
    end
    % process frames
%     mk=mk.frameProcess2(currFrame,A.objLists{frameNo-firstFrame+1});
%     mk=mk.frameProcess(currFrame);
mk = mk.frameProcess3(currFrame);
brightness = [brightness mk.brightnessValue];
brightnessPt = [brightnessPt mk.brightnessValuePt];
%     histo(frameNo-firstFrame)=mk.nDiffPixels;
%     bb_saved{frameNo-firstFrame}=mk.bb;


    % Display frames
%     mk.disp();
mk.disp3();
figure(1);
subplot(2,2,3);
hold on;
plot(brightness,'.');
hold off;
subplot(2,2,4);
hold on;
plot(brightnessPt,'.');
hold off;
            
            

    
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
    
%     if any(xc1) && any(yc1)
%         plot(xc1(xc1~=0 & yc1~=0), yc1(xc1~=0 & yc1~=0),'r+');
%     end
%     if any(xc2) && any(yc2)
%         plot(xc2(xc2~=0 & yc2~=0), yc2(xc2~=0 & yc2~=0),'g+');
%     end

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

