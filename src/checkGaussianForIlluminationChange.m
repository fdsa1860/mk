% monkey main function
% Xikang Zhang, 10/08/2012

addpath(genpath('C:\zxk\toolbox'));

% fileName="";
inputFileDir1='C:\zxk\Research\monkeyData\illumination1';


inputFileDir=inputFileDir1;
inputFileType='.jpeg'; % TODO: modify file type name
% inputFileType='.png';
outputFileDir='';

% if ~isempty(inputFileDir)
%     if isdir(inputFileDir)
%         files=dir([inputFileDir '\*' inputFileType]);
%     else
%         error('input directory does not exist!');
%     end
% end
% if ~isempty(outputFileDir)
%     if ~isdir(outputFileDir)
%         mkdir(outputFileDir);
%     end
% end


firstFrame = 1500;
lastFrame = 2500;
pixels = zeros(lastFrame-firstFrame+1,1);
x = 600;
y = 400;
for frameNo=firstFrame:lastFrame
    % read input frame
    inputFileName=['illumination' num2str(frameNo,'%04d') inputFileType];
    if exist([inputFileDir1 '\' inputFileName],'file')
        currFrame=imread([inputFileDir1 '\' inputFileName]);
    end
    
%     % initialization
%     if frameNo==firstFrame
%         %         frameInit();       
%         continue;
%     end

    % process frames
    fprintf('processing frame %d\n',frameNo);
    gray=rgb2gray(currFrame);
    pixels(frameNo-firstFrame+1)=gray(y,x);   
    
    % Display frames6
    h1=figure(1);
    imshow(currFrame);
    hold on;
    plot(x,y,'r');
    title(['Cam 1, frame ' num2str(frameNo)]);
    hold off;
    
    
    %     pause;
    
end
plot(pixels);


