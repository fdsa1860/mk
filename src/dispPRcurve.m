% a = load('PRCurve_cam2a0c001m30w03.mat');
b = load('PRCurve_cam2a1000c001m30w03.mat');
% c = load('PRCurve_cam2a2000c001m30w03.mat');
% d = load('PRCurve_cam2a2500c001m30w03.mat');
% e = load('PRCurve_cam2a6000c001m30w03.mat');
% f = load('PRCurve_cam2a1000c01m30w03.mat');
% g = load('PRCurve_cam2a2000c01m30w03.mat');
% h = load('PRCurve_cam2a2500c01m30w03.mat');
% i = load('PRCurve_cam2a0c001m30w03g0.mat');
j = load('PRCurve_cam2a1000c001m30w03g.mat');
figure
% hold on;plot(a.recall,a.precision,'b');hold off;
hold on;plot(b.recall,b.precision,'g');hold off;
% hold on;plot(c.recall,c.precision,'r');hold off;
% hold on;plot(d.recall,d.precision,'m');hold off;
% hold on;plot(e.recall,e.precision,'k');hold off;
% hold on;plot(f.recall,f.precision,'g--');hold off;
% hold on;plot(g.recall,g.precision,'r--');hold off;
% hold on;plot(h.recall,h.precision,'m--');hold off;
% hold on;plot(i.recall,i.precision,'y');hold off;
hold on;plot(j.recall,j.precision,'y--');hold off;
legend a b c d e f g h i