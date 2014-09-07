% convert [left top right bottom] to [left top width height]
function w = rec2w(rec)
w = [rec(:,1),rec(:,1)+rec(:,3),rec(:,2),rec(:,2)+rec(:,4)];
end