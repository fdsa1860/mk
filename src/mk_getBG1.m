clear;close all;
addpath(genpath('c:/zxk/toolbox'));

% fileName="";
inputFileDir='.\monkey_cam3_QuartSampled';
outputFileDir='';

if ~isempty(inputFileDir)
    if isdir(inputFileDir)
        files=dir([inputFileDir '\*.png']); % TODO: modify file type name
    else
        error('input directory does not exist!');
    end
end
if ~isempty(outputFileDir)
    if ~isdir(outputFileDir)
        mkdir(outputFileDir);
    end
end

numframes = length(files);
firstFrame = 1;
lastFrame = numframes;

for frameNo=firstFrame:lastFrame
    % read input frame
    img=imread([inputFileDir '\' files(frameNo).name]);
    % initialization
    if frameNo==firstFrame
        %         frameInit();
        [numrows, numcols dim]=size(img);
        % initialize background subtraction
        h=mexCvBSLib(img);%Initialize
        mexCvBSLib(img,h,[0.0001 5*5 0 0.5]);%set parameters
%         mat = uint8(zeros(numrows, numcols ,dim, lastFrame-firstFrame+1));
    end
    % process
    %     frameProcess();    
    fgMask=mexCvBSLib(img,h);
%     mat(:, :, :, frameNo) = img;
% M(frameNo)=im2frame(img);
    
    % show frame
    %     frameDisplay();
    figure(1);
    subplot(1,2,1);imshow(img);
    subplot(1,2,2);imshow(fgMask);
    title(sprintf('Frame:%d',frameNo));
%     imshow(img);
end

mexCvBSLib(h);



