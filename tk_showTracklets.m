% To show the tracklets

function tk_showTracklets()

if nargin==0    
    inputFileDir='C:\zxk\Research\monkeyData\Camera1_extractedVideos\_extracted_100';
    fileName = [inputFileDir '\' 'detection.txt'];
end

% [tracklet, indexMat] = mk_getTracklet(fileName);
load tracklet20130424;
inputFileType = '.png';
scale = 0.5;

firstFrame = 121668;
lastFrame = 122068;
for frameNo=firstFrame:lastFrame
    fprintf('Processing frame %d ...\n',frameNo-firstFrame+1);
    % read input frame
    inputFileName=['Temp1-' num2str(frameNo) inputFileType];
    if exist([inputFileDir '\' inputFileName],'file')
        currFrame=imread([inputFileDir '\' inputFileName]);
    end
    currFrame = imresize(currFrame,scale);
    
    ind = find(indexMat(:,frameNo-firstFrame+1));
    
    figure(1);
    imshow(currFrame);
    hold on;
    for i=1:length(ind)
        indind = ([tracklet(ind(i)).node.fr]==frameNo-firstFrame+1);
        rect = tracklet(ind(i)).node(indind).bb;
        rectangle('Position',rect,'EdgeColor',tracklet(ind(i)).color);
    end
    hold off;
    pause;


end