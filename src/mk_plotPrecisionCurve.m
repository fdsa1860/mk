function mk_plotPrecisionCurve

lineWidth = 2;

figure(1);
hold on;
load precisionCurve1;
plot(recall,precision,'b','LineWidth',lineWidth);
load precisionCurve4;
plot(recall,precision,'r','LineWidth',lineWidth);
load precisionCurve2;
plot(recall,precision,'g','LineWidth',lineWidth);
load precisionCurve3;
plot(recall,precision,'m','LineWidth',lineWidth);
hold off;
legend('View 1','View 2','View 3','View 4','Location','SouthWest');
xlabel('Recall (TP/(TP+FN))','FontSize',14);
ylabel('Precision (TP/(TP+FP))','FontSize',14);
title('Detection over all four views','FontSize',14);
ylim([0 1.05]);

figure(2);
hold on;
load precisionCurve1;
plot(1-precision, 1-recall,'b','LineWidth',lineWidth);
load precisionCurve4;
plot(1-precision, 1-recall,'r','LineWidth',lineWidth);
load precisionCurve2;
plot(1-precision, 1-recall,'g','LineWidth',lineWidth);
load precisionCurve3;
plot(1-precision, 1-recall,'m','LineWidth',lineWidth);
hold off;
legend('View 1','View 2','View 3','View 4');
xlabel('false positive rate (FP/(TP+FP))','FontSize',14);
ylabel('miss rate (FN/(TP+FN))','FontSize',14);
title('Detection over all four views','FontSize',14);
ylim([0 1.05]);

end