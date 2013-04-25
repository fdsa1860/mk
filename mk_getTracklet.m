
function trklt = mk_getTracklet
% Created by Xikang Zhang, 04/24/2013
% generate tracklets from detection bounding boxes (data association)


inputFileDir='C:\zxk\Research\monkeyData\Camera1_extractedVideos\_extracted_100';
% Load annotation from disk (in .txt format):
fid = fopen([inputFileDir '\' 'detection.txt']);
A = fscanf(fid,'%f',[5 inf]);
fclose(fid);
dbb = A';
dbb(:,1) = dbb(:,1)+1; % c++ frame number start at 0


thres = 0.5;
trklt = Tracklet.empty();
nTracklet = 0;


firstFrame = dbb(1,1);
lastFrame = dbb(end,1);
for frameNo=firstFrame:lastFrame
    
    fprintf('Processing Frame %d ...\n',frameNo);
    
    currbb = dbb(dbb(:,1)==frameNo,2:5);
    if frameNo==firstFrame
        for i=1:size(currbb,1)
            nTracklet = nTracklet + 1;
            trklt(nTracklet) = Tracklet(frameNo, currbb(i,:));
        end
        continue;
    end
    
    for i=1:size(currbb,1)
        isMatched = false;
        for j=1:nTracklet
            if trklt(j).node(end).fr ~= frameNo-1
                continue;
            end
            if isOverlapped(trklt(j).node(end).bb, currbb(i,:),thres)
                trklt(j) = trklt(j).add( frameNo, currbb(i,:) );
                isMatched = true;
                break;
            end
        end
        if ~isMatched %if not matched to any tracklet, create a new one
            nTracklet = nTracklet + 1;
            trklt(nTracklet) = Tracklet(frameNo, currbb(i,:));
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