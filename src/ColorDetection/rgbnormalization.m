% Normalize the frames
function normalized_image = rgbnormalization(image,mask)
% image is the color image that we want to normalize
%flag is one for ceiling camera and 0 for other cameras
%mask is the mask for camera ceiling
    r = image(:,:,1);
    g = image(:,:,2);
    b = image(:,:,3);

    if nargin <2
        r = histeq(r);
        g = histeq(g);
        b = histeq(b);
    else     
    r(mask) = histeq(r(mask)); r(~mask) = 0 ;
    g(mask) = histeq(g(mask)); g(~mask) = 0 ;
    b(mask) = histeq(b(mask)); b(~mask) = 0 ;
    end
    
    
    normalized_image(:,:,1) = r;
    normalized_image(:,:,2) = g;
    normalized_image(:,:,3) = b;
    
   imshow(normalized_image);