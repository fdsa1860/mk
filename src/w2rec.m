% convert [left top right bottom] to [left top width height]
function rec = w2rec(w)
rec = [w(:,1),w(:,3),w(:,2)-w(:,1),w(:,4)-w(:,3)];
end