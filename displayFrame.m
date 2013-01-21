function displayFrame

% inputFileDir1='.\cam1_320x240_jpg';
% inputFileDir2='.\cam2_320x240_jpg';
% inputFileDir3='.\cam3_320x240_jpg';
% inputFileDir4='.\cam4_320x240_jpg';
inputFileDir = 'C:\zxk\monkey\extractedVideo\cam1_320x240_jpg_extracted_1';
inputFileType='.jpg'; 

if ~isempty(inputFileDir)
    if isdir(inputFileDir)
        files=dir([inputFileDir '\*' inputFileType]);
    else
        error('input directory does not exist!');
    end
end

% firstFrame = 122500;
% lastFrame = 123000;
% firstFrame = 86400;
% lastFrame = 87400;

for frameNo=1:length(files)
    % read input frame
    currFrame=imread([inputFileDir '\' files(frameNo).name]);
    figure(1);
    imshow(currFrame);
    title(['Frame ' num2str(frameNo)]);
end