% Created by Xikang Zhang, 04/20/2013
% monkey main function, version 0.5
% implementation using class MK
% load detection log and plot
% perform data association

function mk_main5

addpath(genpath('C:\zxk\toolbox'));
addpath(genpath('C:\zxk\Research\code3.0.0'));

% fileName="";
inputFileDir1='C:\zxk\Research\monkeyData\Camera1_extractedVideos\_extracted_100';
inputFileDir2='.\cam2_320x240_jpg';
inputFileDir3='.\cam3_320x240_jpg';
inputFileDir4='C:\zxk\Research\monkeyData\Camera4_extractedVideos\_extracted_100';
inputFileDir = inputFileDir1;
inputFileType='.png'; % modify file type name if necessary
outputFileDir='';

% Load annotation from disk (in .txt format):
fid = fopen([inputFileDir '\' 'detection.txt']);
A = fscanf(fid,'%f',[5 inf]);
fclose(fid);
dbb = A';
dbb(:,1) = dbb(:,1)+1; % c++ frame number start at 0

scale = 0.5;
thres = 0.5;

firstFrame = 121668;
lastFrame = 122068;
for frameNo=firstFrame:lastFrame
    % read input frame
    inputFileName=['Temp1-' num2str(frameNo) inputFileType];
    if exist([inputFileDir '\' inputFileName],'file')
        currFrame=imread([inputFileDir '\' inputFileName]);
    end
    currFrame = imresize(currFrame,scale);
    
    % initialization
    if frameNo==firstFrame
        %         frameInit();
        mk=MK(currFrame,[],frameNo);
        mk.bb = dbb(dbb(:,1)==frameNo-firstFrame+1,2:5);
        mk.bb_pre = mk.bb;
        continue;
    end
    % process frames
    %     mk=mk.frameProcess2(currFrame,A.objLists{frameNo-firstFrame+1});
    mk.currFrame=currFrame;
    mk.frameNo=frameNo;
    mk.bb = dbb(dbb(:,1)==frameNo-firstFrame+1,2:5);
    mk.isTrgt = false(size(mk.bb,1),1);
    for i=1:size(mk.bb,1)
        for j=1:size(mk.bb_pre,1)
            if isOverlapped(mk.bb(i,:), mk.bb_pre(j,:),thres)
                mk.isTrgt(i) = true;
                break;
            end
        end
    end
    % Display frames
    mk.disp2();
    
    
    %         pause;
    % M(frameNo-firstFrame)=getframe;
end
end

function isOvlp = isOverlapped(bb1,bb2,th)

x = min(bb1(1)+bb1(3),bb2(1)+bb2(3)) - max(bb1(1),bb2(1));
y = min(bb1(2)+bb1(4),bb2(2)+bb2(4)) - max(bb1(2),bb2(2));

overlapArea = max(0,x)*max(0,y);
area1 = bb1(3)*bb1(4);
area2 = bb2(3)*bb2(4);

if overlapArea/area1>th || overlapArea/area2>th ||...
        2*overlapArea/(area1+area2)>th
    isOvlp = true;
else
    isOvlp = false;
end

end
