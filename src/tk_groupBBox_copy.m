
function logMat = tk_groupBBox_copy(fileName)
% Created by Xikang Zhang, 06/04/2013
% convert bounding boxes from txt files to mat files

if nargin==0    
    inputFileDir='C:\zxk\Research\monkeyData\Camera1_labeledVideos\_extracted_277';
    fileName = [inputFileDir '\' 'detection.txt'];
end

% Load annotation from disk (in .txt format):
fid = fopen(fileName);
A = fscanf(fid,'%f',[5 inf]);
fclose(fid);
logMat = A';
logMat(:,1) = logMat(:,1)+1; % c++ frame number start at 0
logMat(:,2:3) = logMat(:,2:3)+1; % c++ row and column number start at 0

end