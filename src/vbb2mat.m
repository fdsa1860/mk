function gtLog = vbb2mat(fileName)

% addpath(genpath('..\toolbox'));
addpath(genpath(fullfile('~','research','code','monkey','3rdParty')));

% fileName="";
inputFileDir1=fullfile('~','research','data','monkey','cam1-127389','GroundTruth');
inputFileDir2='C:\zxk\Research\monkeyData\Camera2_labeledVideos\_extracted_277';
inputFileDir3='C:\zxk\Research\monkeyData\Camera3_labeledVideos\_extracted_277';
inputFileDir4='C:\zxk\Research\monkeyData\Camera4_labeledVideos\_extracted_277';
inputFileDir = inputFileDir1;

if nargin==0
    fileName = fullfile(inputFileDir,'cam1-127989.vbb');
end

% Load ground truth labels
A = vbb('vbbLoadTxt', fileName);

scale = 0.5;

gtLog = [];

firstFrame = 127989;
lastFrame = 128088;
offset = 0;
for frameNo=firstFrame+offset:lastFrame
    currObj = A.objLists{frameNo-firstFrame+1};
    for i=1:length(currObj)
%         if currObj(i).occl==1
%             continue;
%         end
        gtLog = [gtLog;[frameNo scale*currObj(i).pos currObj(i).id]];
    end
end

end

