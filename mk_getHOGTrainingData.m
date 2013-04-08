
posFolder = 'C:\\zxk\\Research\\monkeyData\\Camera1_extractedVideos_Patch_Pos';
negFolder = 'C:\\zxk\\Research\\monkeyData\\Camera1_extractedVideos_Patch_Neg';
imgFmt = 'png';

posFiles = dir([posFolder '//' '*.' imgFmt]);
negFiles = dir([negFolder '//' '*.' imgFmt]);

numPosFiles = length(posFiles);
numNegFiles = length(negFiles);

hogSize = 81;
H = zeros(hogSize,1);

fid = fopen('hog.txt','w');

for i=1:numPosFiles
    img = imread([posFolder '\\' posFiles(i).name]);
    I = rgb2gray(img);
    H = HOG(I);
    fprintf(fid,'+1');
    for k=1:hogSize
        fprintf(fid,' %d:%f',k,H(k));
    end
    fprintf(fid,'\n');
    fprintf('Processing positive %d\n',i);
end

for i=1:numNegFiles
    img = imread([negFolder '\\' negFiles(i).name]);
    I = rgb2gray(img);
    H = HOG(I);
    fprintf(fid,'-1');
    for k=1:hogSize
        fprintf(fid,' %d:%f',k,H(k));
    end
    fprintf(fid,'\n');
    fprintf('Processing negative %d\n',i);
end

fclose(fid);