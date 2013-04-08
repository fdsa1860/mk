
function drawRect(img,rect,confidence)

imshow(img);
assert(size(rect,1)==length(confidence));
for i = 1:size(rect,1)
    rectangle('Position',rect(i,:),'EdgeColor','r');
    text(rect(i,1),rect(i,2)-5,sprintf('%.4f',confidence(i)),'Color','g');
end
end