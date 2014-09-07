% detect monkey using lbpDetect, save false positive into folder
function mk_main8
load lbp_model_temp;
I = imread('cam1_sample2.png');
bbox = lbpDetect(I,model);


fpInd = find( (labels==-1 & predict_label==1) );
for i=1:length(fpInd)
    j = fpInd(i)-offset;
    [negPath '\' negFiles(i).name]
end
end

function isOvlp = isOverlapped(bb1,bb2,th)

x = min(bb1(1)+bb1(3),bb2(1)+bb2(3)) - max(bb1(1),bb2(1));
y = min(bb1(2)+bb1(4),bb2(2)+bb2(4)) - max(bb1(2),bb2(2));

overlapArea = max(0,x)*max(0,y);
area1 = bb1(3)*bb1(4);
area2 = bb2(3)*bb2(4);

if overlapArea/area1>th || overlapArea/area2>th ||...
        2*overlapArea/(area1+area2)>th
    isOvlp = true;
else
    isOvlp = false;
end

end