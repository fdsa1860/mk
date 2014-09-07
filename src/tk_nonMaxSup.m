function img = tk_nonMaxSup(img)

img = double(img);
imgDown = img - circshift(img,1);
imgUp = img - circshift(img,-1);
imgLeft = img - circshift(img,[0 1]);
imgRight = img - circshift(img,[0 -1]);
img(imgDown<0 | imgUp<0 | imgLeft<0 | imgRight<0) = 0;


end