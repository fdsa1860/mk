function gtLog = vbb2mat(fileName)

addpath(genpath('C:\zxk\toolbox'));
addpath(genpath('C:\zxk\Research\code3.0.0'));

% fileName="";
inputFileDir1='C:\zxk\Research\monkeyData\Camera1_extractedVideos\_extracted_277';
inputFileDir2='C:\zxk\Research\monkeyData\Camera2_labeledVideos\_extracted_277';
inputFileDir3='C:\zxk\Research\monkeyData\Camera3_labeledVideos\_extracted_277';
inputFileDir4='C:\zxk\Research\monkeyData\Camera4_labeledVideos\_extracted_277';
inputFileDir = inputFileDir4;

if nargin==0
    fileName = fullfile(inputFileDir,'_extracted_277.txt');
end

% Load ground truth labels
A = vbb('vbbLoadTxt', fileName);

scale = 0.5;

gtLog = [];

firstFrame = 98051;
lastFrame = 98156;
offset = 60;
for frameNo=firstFrame+offset:lastFrame
    currObj = A.objLists{frameNo-firstFrame+1};
    for i=1:length(currObj)
        if currObj(i).occl==1
            continue;
        end
        gtLog = [gtLog;[frameNo-firstFrame+1 scale*currObj(i).pos currObj(i).id]];
    end
end

end

