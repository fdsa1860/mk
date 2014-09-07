% Created by Xikang Zhang
% 07/01/2013
% Compare detection and ground truth data


function mk_main6

addpath(genpath('C:\zxk\toolbox'));
addpath(genpath('C:\zxk\Research\code3.0.0'));

% fileName="";
inputFileDir1='C:\zxk\Research\monkeyData\Camera1_extractedVideos\_extracted_100';
inputFileDir2='C:\zxk\Research\monkeyData\Camera2_labeledVideos\_extracted_100';
inputFileDir3='C:\zxk\Research\monkeyData\Camera3_labeledVideos\_extracted_277';
inputFileDir4='C:\zxk\Research\monkeyData\Camera4_labeledVideos\_extracted_100';
inputFileDir = inputFileDir1;
inputFileType='.png'; % modify file type name if necessary
outputFileDir='';

% Load ground truth labels
enableLoadGT = true;
if enableLoadGT
    A = vbb('vbbLoadTxt', [inputFileDir '\' '_extracted_100.txt'] );
end

scale = 0.5;
ovTH = 0.1;
enableSaveFP = true;

fpCounter2 = 0;
logMat = [];

firstFrame = 121668;
lastFrame = 122068;
% firstFrame = 98051;
% lastFrame = 98156;
% firstFrame = 139925;
% lastFrame = 140228;
offset = 0;

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
        mk.bb = [];
        mk.bb_pre = mk.bb;
        continue;
    end
    % process frames
    %     mk=mk.frameProcess2(currFrame,A.objLists{frameNo-firstFrame+1});
    mk = mk.frameProcess4('hog_detect',currFrame);
    %         mk.currFrame=currFrame;
    %         mk.frameNo=frameNo;
    
    mk.disp();
    
    if enableLoadGT
        bb_gt = [];
        currObj = A.objLists{frameNo-firstFrame+1};
        for i=1:length(currObj)
            %             if currObj(i).occl==1
            %                 continue;
            %             end
            bb_gt = [bb_gt;scale*currObj(i).pos];
        end
        
        figure(1);
        for i=1:size(bb_gt,1)
            hold on; rectangle('Position',bb_gt(i,:),'EdgeColor','g'); hold off;
        end
        
        dtMatched = false(size(mk.bb,1),1);
        for i=1:size(bb_gt,1)
            for j=1:size(mk.bb,1)
                if ~dtMatched(j) && isOverlapped(bb_gt(i,:),mk.bb(j,:),ovTH)
                    dtMatched(j) = true;
                end
            end
        end
        
        % save the false positives
        if enableSaveFP
            unmatchedBB = mk.bb(~dtMatched,:);
            fpCounter2 = saveFPpatch(currFrame,unmatchedBB,fpCounter2);
        end
    end
    
    logMat = [logMat; [(frameNo-firstFrame+1)*ones(size(mk.bb,1),1) mk.bb mk.wgt]];
    
end
save detectLogWithWeight logMat;

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

function fpCounter2 = saveFPpatch(currFrame,unmatchedBB,fpCounter2)
for m=1:size(unmatchedBB)
    ROI = currFrame(unmatchedBB(m,2):unmatchedBB(m,2)+unmatchedBB(m,4)-1, ...
        unmatchedBB(m,1):unmatchedBB(m,1)+unmatchedBB(m,3)-1,:);
    ROI = imresize(ROI,[60 60]);
    imwrite(ROI,['.\FPpatch\' sprintf('FP_%06d.png',fpCounter2)]);
    fpCounter2 = fpCounter2 + 1;
end
end
