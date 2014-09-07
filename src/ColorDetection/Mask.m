% Masking the ceiling camera
function mask = Mask(image)
ROI = imshow(image);
position = [277.469854469854 124.960498960499 814.020790020791 820.407484407484];
e = imellipse(gca,position);
mask = createMask(e,ROI);