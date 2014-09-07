% Created by Xikang Zhang
% 06/03/2013
% Compare detection and ground truth data
% plot precision-recall curve

function mk_main3

addpath(genpath('C:\zxk\toolbox'));
addpath(genpath('C:\zxk\Research\code3.0.0'));

% fileName="";
inputFileDir1='C:\zxk\Research\monkeyData\Camera1_extractedVideos\_extracted_277';
inputFileDir2='C:\zxk\Research\monkeyData\Camera2_labeledVideos\_extracted_277';
inputFileDir3='C:\zxk\Research\monkeyData\Camera3_labeledVideos\_extracted_277';
inputFileDir4='C:\zxk\Research\monkeyData\Camera4_labeledVideos\_extracted_277';
inputFileDir = inputFileDir1;
inputFileType='.png'; % modify file type name if necessary
outputFileDir='';

% % Load detection
% fid = fopen([inputFileDir '\' 'detection.txt']);
% A = fscanf(fid,'%f',[5 inf]);
% fclose(fid);
% dbb = A';
% dbb(:,1) = dbb(:,1)+1; % c++ frame number start at 0

% fileName = [inputFileDir '\' 'detectionWithWeight.txt'];
% logMat = tk_groupBBox_nonMaxSup(fileName);
load detectLogWithWeight;

% Load ground truth labels
A = vbb('vbbLoadTxt', [inputFileDir '\' '_extracted_277.txt'] );


scale = 0.5;
ovTH = 0.5;

weightTH = 0:0.1:2;
hitCounter = zeros(size(weightTH));
fpCounter = zeros(size(weightTH));
fnCounter = zeros(size(weightTH));
precision = zeros(size(weightTH));
recall = zeros(size(weightTH));

firstFrame = 98051;
lastFrame = 98156;
offset = 0;

for k=1:length(weightTH)
    dbb = logMat(logMat(:,6)>weightTH(k),1:5);
    
    for frameNo=firstFrame+offset:lastFrame
        % read input frame
        inputFileName=['Temp1-' num2str(frameNo) inputFileType];
        if exist([inputFileDir '\' inputFileName],'file')
            currFrame=imread([inputFileDir '\' inputFileName]);
        end
        currFrame = imresize(currFrame,scale);
        
        % initialization
        if frameNo==firstFrame+offset
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
        
%                 load temp;
%                 imshow(I);
        
%         mk.disp();
        
        bb_gt = [];
        currObj = A.objLists{frameNo-firstFrame+1};
        for i=1:length(currObj)
            if currObj(i).occl==1
                continue;
            end
            bb_gt = [bb_gt;scale*currObj(i).pos];
        end
        
%         figure(1);
%         for i=1:size(bb_gt,1)
%             hold on; rectangle('Position',bb_gt(i,:),'EdgeColor','g'); hold off;
%         end
        
        %         keyboard;
        % Compare detection and ground truth
        gtMatched = false(size(bb_gt,1),1);
        dtMatched = false(size(mk.bb,1),1);
        for i=1:size(bb_gt,1)
            for j=1:size(mk.bb,1)
                if ~dtMatched(j) && isOverlapped(bb_gt(i,:),mk.bb(j,:),ovTH)
                    dtMatched(j) = true;
                    gtMatched(i) = true;
                    break;
                end
            end
        end
        assert(nnz(dtMatched)==nnz(gtMatched));
        hitCounter(k) = hitCounter(k) + nnz(gtMatched);
        fpCounter(k) = fpCounter(k) + nnz(dtMatched==false);
        fnCounter(k) = fnCounter(k) + nnz(gtMatched==false);

       
    end
    
    [hitCounter; fpCounter; fnCounter]
    
end

precision = hitCounter./(hitCounter+fpCounter);
recall = hitCounter./(hitCounter+fnCounter);
figure(2);
plot(recall,precision);
save precisionCurve1 weightTH precision recall hitCounter fpCounter fnCounter;

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