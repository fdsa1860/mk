
posFolder = 'C:\\zxk\\Research\\monkeyData\\Camera1_extractedVideos_Patch_Pos';
negFolder = 'C:\\zxk\\Research\\monkeyData\\Camera1_extractedVideos_Patch_Neg';
imgFmt = 'png';

posFiles = dir([posFolder '//' '*.' imgFmt]);
negFiles = dir([negFolder '//' '*.' imgFmt]);

numPosFiles = length(posFiles);
numNegFiles = length(negFiles);

ColorSize = 65;
f = zeros(ColorSize,1);

fid = fopen('color.txt','w');

for i=1:numPosFiles
    img = imread([posFolder '\\' posFiles(i).name]);
    
    I = rgb2hsv_fast(img,'single','H');    
    histo = histc(I(:),0:4/255:256/255);
    f = histo/sum(histo);
    
    fprintf(fid,'+1');
    for k=1:ColorSize
        fprintf(fid,' %d:%f',k,f(k));
    end
    fprintf(fid,'\n');
    fprintf('Processing positive %d\n',i);
end

for i=1:numNegFiles
    img = imread([negFolder '\\' negFiles(i).name]);
        
    I = rgb2hsv_fast(img,'single','H');    
    histo = histc(I(:),0:4/255:256/255);
    f = histo/sum(histo);
    
    fprintf(fid,'-1');
    for k=1:ColorSize
        fprintf(fid,' %d:%f',k,f(k));
    end
    fprintf(fid,'\n');
    fprintf('Processing negative %d\n',i);
end

fclose(fid);