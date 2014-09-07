
function [trklt indexMat] = tk_getTracklet(fileName)
% Created by Xikang Zhang, 04/24/2013
% generate tracklets from detection bounding boxes (data association)

if nargin==0    
    inputFileDir='C:\zxk\Research\monkeyData\Camera4_extractedVideos\_extracted_100';
    fileName = [inputFileDir '\' 'detection.txt'];
end

% Load annotation from disk (in .txt format):
fid = fopen(fileName);
A = fscanf(fid,'%f',[5 inf]);
fclose(fid);
dbb = A';
dbb(:,1) = dbb(:,1)+1; % c++ frame number start at 0


thres = 0.5;
trklt = Tracklet.empty();
nTracklet = 0;
nFrames = dbb(end,1)-dbb(1,1)+1;
indexMat = zeros(0,nFrames);

firstFrame = dbb(1,1);
lastFrame = dbb(end,1);
for frameNo=firstFrame:lastFrame    
    fprintf('Processing Frame %d ...\n',frameNo);    
    currbb = dbb(dbb(:,1)==frameNo,2:5);
    for i=1:size(currbb,1)
        isMatched = false;
        for j=1:nTracklet
            if trklt(j).node(end).fr ~= frameNo-1
                continue;
            end
            if isOverlapped(trklt(j).node(end).bb, currbb(i,:),thres)
                trklt(j) = trklt(j).add( frameNo, currbb(i,:), rand(3,1) );
                isMatched = true;
                indexMat(j,frameNo) = 1;
                break;
            end
        end
        if ~isMatched %if not matched to any tracklet, create a new one
            nTracklet = nTracklet + 1;
            trklt(nTracklet) = Tracklet(frameNo, currbb(i,:),rand(3,1) );
            indexMat = [indexMat; zeros(1,nFrames)];
            indexMat(end,frameNo) = 1;
        end
    end    
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