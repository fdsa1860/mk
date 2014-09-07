clearvars
close all;

base_path = 'C:\zxk\Research\monkeyData\Camera1_extractedVideos\_extracted_240\';


% frame_start = 139925; % video 170
% frame_end  = 140228;
% frame_start = 134709; % video 152
% frame_end = 135003;
frame_start = 91670; % video 240
frame_end = 92177;

step = 3;
img_files = num2str((frame_start :step:frame_end)','Temp1-%0i.png');
img_files = cellstr(img_files);



%DATA LABELING

u = [];
v = [];

%Display the first frame in the series.

for i=1:size(img_files,1)
    figure(3)
    imshow([base_path img_files{i}]);
    title(['Frame ' num2str(i)]);
    [x,y] = ginput(5);
    u = [u x];
    save u u;
    v = [v y];
    save v v;
    im_name(i) = img_files(i);
    save im_name im_name;
     i
    pause(0.06)
end