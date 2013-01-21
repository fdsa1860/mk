% monkey main function
% for multiple objects tracking
% Xikang Zhang, 10/28/2012

addpath('C:\zxk\toolbox');

% fileName="";
inputFileDir1='.\cam1_320x240_jpg';
inputFileDir2='.\cam2_320x240_jpg';
inputFileDir3='.\cam3_320x240_jpg';
inputFileDir4='.\cam4_320x240_jpg';
inputFileDir=inputFileDir1;
inputFileType='*.jpg'; % TODO: modify file type name
outputFileDir='';

% if ~isempty(inputFileDir)
%     if isdir(inputFileDir)
%         files=dir([inputFileDir '/' inputFileType]);
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
load ('./data/bb_saved');


numframes = length(files);
firstFrame = 37150;
lastFrame = 37244;

for frameNo=firstFrame:lastFrame
    % read input frame
    currFrame=imread([inputFileDir '\' files(frameNo).name]);
    % initialization
    if frameNo==firstFrame
        %         frameInit();
        load './data/bg_img1';
        mk=MK(currFrame,bg_img1,frameNo);        
        histo=zeros(lastFrame-firstFrame,1);
        continue;
    end
    % process
    %     frameProcess();
    mk=mk.frameProcess(currFrame);
    % show frame
    %     frameDisplay();
    figure(1);
    mk.disp1();    
    keyboard;
%     pause;
end

% display results
% resultDisplay();

