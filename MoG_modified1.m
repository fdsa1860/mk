function [mu bg_bw fg]=MoG
% This m-file implements the mixture of Gaussians algorithm for background
% subtraction.  It may be used free of charge for any purpose (commercial
% or otherwise), as long as the author (Seth Benton) is acknowledged.


% clear all
close all; clc

% source = aviread('C:\Video\Source\traffic\san_fran_traffic_30sec_QVGA');
% source = aviread('..\test_video\san_fran_traffic_30sec_QVGA_Cinepak');

% -----------------------  frame size variables -----------------------

% fr = source(1).cdata;           % read in 1st frame as background frame
% [srcdirI filenamesI] = rfdatabase(datadir(3, 'kthdata2'), 'clip');
% load([srcdirI filenamesI{1}])

clear;close all;
addpath(genpath('c:/zxk/toolbox'));



% fileName="";
inputFileDir='C:\zxk\Dropbox\monkey\extractedVideo\_extracted_001';
outputFileDir='';

if ~isempty(inputFileDir)
    if isdir(inputFileDir)
        files=dir([inputFileDir '\*.jpg']); % TODO: modify file type name
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

fr=imread([inputFileDir '\' files(1).name]);

% fr = I(:, :, 1);
fr_bw = rgb2gray(fr);     % convert background to greyscale
% fr_bw = fr;
fr_size = size(fr);             
width = fr_size(2);
height = fr_size(1);
fg = zeros(height, width);
bg_bw = zeros(height, width);

% --------------------- mog variables -----------------------------------

C = 5;                                  % number of gaussian components (typically 3-5)
M = 3;                                  % number of background components
D = 2.5;                                % positive deviation threshold
alpha = 0.01;                           % learning rate (between 0 and 1) (from paper 0.01)
thresh = 0.25;                          % foreground threshold (0.25 or 0.75 in paper)
sd_init = 2;                            % initial standard deviation (for new components) var = 36 in paper
w = zeros(height,width,C);              % initialize weights array
mean = zeros(height,width,C);           % pixel means
sd = zeros(height,width,C);             % pixel standard deviations
u_diff = zeros(height,width,C);         % difference of each pixel from mean
p = alpha/(1/C);                        % initial p variable (used to update mean and sd)
rank = zeros(1,C);                      % rank of components (w/sd)
h = fspecial('gaussian', [5 5]);

x = 96; y = 143;mu=[];

% --------------------- initialize component means and weights -----------
mean = zeros(height,width,C);
w = 1/C*ones(height,width,C);
sd = sd_init*ones(height,width,C);

%--------------------- process frames -----------------------------------

% for n = 1:length(source)
% for n = 1:size(I, 3)
for frameNo=firstFrame:1:lastFrame

%     fr = source(n).cdata;       % read in frame
%     fr = I(:, :, n);
    fr=imread([inputFileDir '\' files(frameNo).name]);
    fr_bw = rgb2gray(fr);       % convert frame to grayscale
%     fr_bw = fr;
%     fr_bw = imfilter(fr_bw, h);
    
    % calculate difference of pixel values from mean
    u_diff = abs(repmat(double(fr_bw),[1 1 C]) - double(mean));    
     
    % update gaussian components for each pixel
    for i=1:height
        for j=1:width
            
            match = 0;
            for k=1:C                       
                if abs(u_diff(i,j,k))<=D*sd(i,j,k) && match==0      % pixel matches component
                    
                    match = 1;                          % variable to signal component match
                    
                    % update weights, mean, sd, p
                    w(i,j,k) = (1-alpha)*w(i,j,k) + alpha;
                    p = alpha/w(i,j,k);                  
                    mean(i,j,k) = (1-p)*mean(i,j,k) + p*double(fr_bw(i,j));
                    sd(i,j,k) =   sqrt((1-p)*(sd(i,j,k)^2) + p*((double(fr_bw(i,j)) - mean(i,j,k)))^2);
                else                                    % pixel doesn't match component
                    w(i,j,k) = (1-alpha)*w(i,j,k);      % weight slighly decreases
                    
                end
            end
            
%             w_sum = sum(w(i,j,:));
%             w(i,j,:) = w(i,j,:)./w_sum;
            w_sum = 0;
            for k=1:C
                w_sum = w_sum + w(i,j,k);
            end
            for k=1:C
                w(i,j,k) = w(i,j,k)/w_sum;
            end
            
            bg_bw(i,j)=0;
            for k=1:C
                bg_bw(i,j) = bg_bw(i,j)+ mean(i,j,k)*w(i,j,k);
            end
            
            
            % if no components match, create new component
            if (match == 0)
                [min_w, min_w_index] = min(w(i,j,:));  
                mean(i,j,min_w_index) = double(fr_bw(i,j));
                sd(i,j,min_w_index) = sd_init;
            end         
            
            for k=1:C
                rank(k) = w(i,j,k)/sd(i,j,k);
            end
            [rank rank_ind]= sort(rank,'descend');
            
            % calculate foreground
            match = 0;
            k=1;
            
            fg(i,j) = 0;
            while ((match == 0)&&(k<=M))

                if (w(i,j,rank_ind(k)) >= thresh)
                    if (abs(u_diff(i,j,rank_ind(k))) <= D*sd(i,j,rank_ind(k)))
                        fg(i,j) = 0;
                        match = 1;
                    else
                        fg(i,j) = fr_bw(i,j);     
                    end
                end
                k = k+1;
            end
        end
    end
    fg = medfilt2(fg, [5 5]);
    
    for cnt=1:size(mean,3)
        mu(cnt,frameNo) = mean(y,x,cnt);
    end
    mu(cnt+1,frameNo) = fr_bw(y,x);
    mu
    
    figure(1),subplot(3,1,1),imshow(fr);
    title(['Frame ' num2str(frameNo)]);
    hold on; plot(x,y,'r.'); hold off;
    subplot(3,1,2),imshow(uint8(bg_bw));
    hold on; plot(x,y,'r.'); hold off;
    subplot(3,1,3),imshow(uint8(fg));
    hold on; plot(x,y,'r.'); hold off;
    
%     Mov1(frameNo)  = im2frame(uint8(fg),gray);           % put frames into movie
%     Mov2(frameNo)  = im2frame(uint8(bg_bw),gray);           % put frames into movie
    
end
      
% movie2avi(Mov1,'mixture_of_gaussians_output','fps',30);           % save movie as avi 
% movie2avi(Mov2,'mixture_of_gaussians_background','fps',30);           % save movie as avi 

