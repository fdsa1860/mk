function tk_showSingleTracklet

load tracklet20130424;

[tracklet, indexMat]= tk_filterTracklet(10);

for index = 1:length(tracklet)

frames = [tracklet(index).node.fr];
rect = cat(1,tracklet(index).node.bb);
xc = rect(:,1)+rect(:,3)/2;
yc = rect(:,2)+rect(:,4)/2;
figure(1);
plot3(frames,xc,yc,'-+');
grid on;
pause;
end

end