% combine monkey detector and tracker, multiple tracking
% created by Xikang Zhang, 09/12/2013

function mk_main7

addpath('C:\zxk\Research\monkey\monkey_MatlabPrj\2DMonkeyTracking');

inputFileDir1='C:\zxk\Research\monkeyData\Camera1_extractedVideos\_extracted_100';
inputFileDir2='C:\zxk\Research\monkeyData\Camera2_extractedVideos\_extracted_100';
inputFileDir3='C:\zxk\Research\monkeyData\Camera3_labeledVideos\_extracted_277';
inputFileDir4='C:\zxk\Research\monkeyData\Camera4_labeledVideos\_extracted_100';
inputFileDir = inputFileDir2;
inputFileType='.png'; % modify file type name if necessary
outputFileDir='';

scale = 0.5;
numTargets = 3;

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
    if frameNo==firstFrame+offset || isempty(mk.bb)
        %         frameInit();
        mk=MK(currFrame,[],frameNo);
        mk = mk.init5('automatic',currFrame,numTargets);
%         mk = mk.init5('manual',currFrame,numTargets);
        continue;
    end
    % process frames
    mk = mk.frameProcess4(currFrame);
%     mk = mk.frameProcess5(currFrame);
    %         mk.currFrame=currFrame;
    %         mk.frameNo=frameNo;
    
    mk.disp();
end

end