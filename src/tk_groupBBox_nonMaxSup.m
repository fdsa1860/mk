
function logMat = tk_groupBBox_nonMaxSup(fileName)
% Created by Xikang Zhang, 05/07/2013
% merge overlaping bounding boxes

if nargin==0    
    inputFileDir='C:\zxk\Research\monkeyData\Camera3_labeledVideos\_extracted_277';
    fileName = [inputFileDir '\' 'detectionWithWeight.txt'];
end

% Load annotation from disk (in .txt format):
fid = fopen(fileName);
A = fscanf(fid,'%f',[6 inf]);
fclose(fid);
dbb = A';
dbb(:,1) = dbb(:,1)+1; % c++ frame number start at 0
dbb(:,2:3) = dbb(:,2:3)+1; % c++ row and column number start at 0

logMat = [];
winSiz = 30;

firstFrame = dbb(1,1);
lastFrame = dbb(end,1);
for frameNo=firstFrame:lastFrame    
    fprintf('Processing Frame %d ...\n',frameNo);    
    currbb = dbb(dbb(:,1)==frameNo,2:5);
    currWeights = dbb(dbb(:,1)==frameNo,6);
    valid = true(size(currWeights));
    for i=1:length(valid)
        if ~valid(i)
            continue;
        end
        isNeighbor = abs(currbb(:,1)-currbb(i,1))<=winSiz & abs(currbb(:,2)-currbb(i,2))<=winSiz & valid;
        isNeighbor(i) = false;
        valid(isNeighbor & currWeights<currWeights(i)) = false;
    end

    dataline = [frameNo*ones(nnz(valid),1) currbb(valid,:) currWeights(valid)];
    logMat = [logMat;dataline];
    
end

end