
function logMat = tk_groupBBox_union(fileName)
% Created by Xikang Zhang, 05/07/2013
% merge overlaping bounding boxes

if nargin==0    
    inputFileDir='C:\zxk\Research\monkeyData\Camera2_labeledVideos\_extracted_277';
    fileName = [inputFileDir '\' 'detection2.txt'];
end

originW = 1360;
originH = 1024;
scale = 0.5;
logMat = [];

% Load annotation from disk (in .txt format):
fid = fopen(fileName);
A = fscanf(fid,'%f',[5 inf]);
fclose(fid);
dbb = A';
dbb(:,1) = dbb(:,1)+1; % c++ frame number start at 0
dbb(:,2:3) = dbb(:,2:3)+1; % c++ row and column number start at 0

firstFrame = dbb(1,1);
lastFrame = dbb(end,1);
for frameNo=firstFrame:lastFrame    
    fprintf('Processing Frame %d ...\n',frameNo);    
    currbb = dbb(dbb(:,1)==frameNo,2:5);
    img = zeros(originH*scale,originW*scale);
    for i=1:size(currbb,1)        
        img(currbb(i,2):currbb(i,2)+currbb(i,4)-1,currbb(i,1):currbb(i,1)+currbb(i,3)-1)=1;
    end
    L = bwlabel(img,4);
    numBbox = length(unique(L))-1;
    for i=1:numBbox
        [r,c]=ind2sub(size(img),find(L==i));
        dataline = [frameNo  min(c) min(r) max(c)-min(c)+1 max(r)-min(r)+1];
        logMat = [logMat;dataline];
    end
end

end