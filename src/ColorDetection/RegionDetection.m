% Region Detection
function  [centroids n] = RegionDetection(image,Pixels,Concomp,min_area)
    BW = imfill(image,'holes');
    BW = bwareaopen(BW,Pixels,Concomp);
    
    cc = bwconncomp(BW);
    stats = regionprops(cc, 'Area');
    idx = find(min_area<= [stats.Area] );
    BW = ismember(labelmatrix(cc), idx);
    
    subplot(1,2,1),imshow(BW);
    subplot(1,2,2),imshow(image);
    
    s  = regionprops(BW, 'centroid');
    centroids = cat(1, s.Centroid);
    n = size(centroids,1);
    %centers = zeros(n,2);
%     if (centroids)
%         centers(1:n,1:2) = round(centroids);
%     end
%     
    
   