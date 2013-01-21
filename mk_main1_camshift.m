% monkey main function, version 0.2
% implementation using class MK
% manually construct background, substract background
% segment foreground with connected component labelling
% manual select two monkeys of interest
% smooth trajectories with SRPCA

% Created by Xikang Zhang, 10/08/2012
% Modified by Xikang Zhang, 10/24/2012

addpath(genpath('C:\zxk\toolbox'));
addpath(genpath('C:\zxk\CAMShift'));

% fileName="";
inputFileDir1='.\cam1_320x240_jpg';
inputFileDir2='.\cam2_320x240_jpg';
inputFileDir3='.\cam3_320x240_jpg';
inputFileDir4='.\cam4_320x240_jpg';
% inputFileDir1='F:\OctaviaCamps_NEU\Camera1';
% inputFileDir2='F:\OctaviaCamps_NEU\Camera2';
% inputFileDir3='F:\OctaviaCamps_NEU\Camera3';
% inputFileDir4='F:\OctaviaCamps_NEU\Camera4';
inputFileDir=inputFileDir1;
inputFileType='*.jpg'; % TODO: modify file type name
outputFileDir='';

% if ~isempty(inputFileDir)
%     if isdir(inputFileDir)
%         files=dir([inputFileDir '\' inputFileType]);
%     else
%         error('input directory does not exist!');
%     end
% end
% if ~isempty(outputFileDir)
%     if ~isdir(outputFileDir)
%         mkdir(outputFileDir);
%     end
% end

load ('./data/files');
% load ('./data/bb_saved');
% load ('./data/ind');
% load ('./data/ind2');
% load ('./data/xcyc_cleaned');

numframes = length(files);
firstFrame = 37150;
lastFrame = 37244;
% firstFrame = 34700;
% lastFrame = 34950;


for frameNo=firstFrame:lastFrame
    % read input frame
    currFrame=imread([inputFileDir '\' files(frameNo).name]);
    
    % initialization
    if frameNo==firstFrame
        %         frameInit();
        %         load './data/bg_img1';
        %         mk=MK(currFrame,bg_img1,frameNo);
        hf = figure(1);
        imshow(currFrame);
        h = get(hf,'Children');
        [w,histo,confidence]=CAMshift_tracker_init(currFrame,h);
        
        xc1=zeros(lastFrame-firstFrame,1);
        yc1=zeros(lastFrame-firstFrame,1);
        xc2=zeros(lastFrame-firstFrame,1);
        yc2=zeros(lastFrame-firstFrame,1);
%         bb_saved=cell(lastFrame-firstFrame,1);
%         ind=zeros(lastFrame-firstFrame,1);

        continue;
    end
    % process frames
    
%     mk=mk.frameProcess(currFrame);
    [xc yc w camshift_confidence]=CAMshift_tracker(currFrame,w,histo);
%     histo(frameNo-firstFrame)=mk.nDiffPixels;
%     bb_saved{frameNo-firstFrame}=mk.bb;


    % Display frames
%     mk.disp();
figure(1);
imshow(currFrame);
title(['frame ' num2str(frameNo)]);
    
    hold on;
    plot(xc,yc,'bx');
    hold off;




%         pause;

end



