% Read images from different dirrectories
function image = ReadDirectory(path,imagetype,framenumber)
% path = Directory of images to read
% imagetype = Type of images in that directory
% framenumber = frame number to be readed in the directory 

imgs = dir([path, imagetype]);
filename = imgs(framenumber).name;
filename = filename(1:end);
image = imread([path filename]);
