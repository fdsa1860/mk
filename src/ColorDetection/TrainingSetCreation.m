% Creating color dataset for different collars
Training_B = 'F:\CSLftp\Projects\Image\MonkeyBehavior\Data\Processed\20120810\TrainingSet_DifferentColorsOfCollars\TrainingSet_GreenCollar\';


for i = 1: 305
    img0_cam1 = ReadDirectory(Training_B,'*.jpg',i);
    nimg0_cam1 = rgbnormalization(img0_cam1,mask);
    imwrite(nimg0_cam1,['G', num2str(i) , '.png']);
end

%%
Red = getHSVColorFromDirectory('F:\CSLftp\Projects\Image\MonkeyBehavior\Data\Processed\20120810\TrainingCollars\R');
Purple = getHSVColorFromDirectory('F:\CSLftp\Projects\Image\MonkeyBehavior\Data\Processed\20120810\TrainingCollars\P');
Brown = getHSVColorFromDirectory('F:\CSLftp\Projects\Image\MonkeyBehavior\Data\Processed\20120810\TrainingCollars\BR');
Green = getHSVColorFromDirectory('F:\CSLftp\Projects\Image\MonkeyBehavior\Data\Processed\20120810\TrainingCollars\G');
Yellow = getHSVColorFromDirectory('F:\CSLftp\Projects\Image\MonkeyBehavior\Data\Processed\20120810\TrainingCollars\Y');
Blue = getHSVColorFromDirectory('F:\CSLftp\Projects\Image\MonkeyBehavior\Data\Processed\20120810\TrainingCollars\B');

save ('normalizedcolors.mat' , 'Red', 'Purple', 'Brown','Green','Yellow','Blue');

%%
R = (mean(Red) + median(Red))/2;
P = (mean(Purple) + median(Purple))/2;
BR = (mean(Brown) + median(Brown))/2;
G = (mean(Green) + median(Green))/2;
Y = (mean(Yellow) + median(Yellow))/2;
B = (mean(Blue) + median(Blue))/2;

%%
WR = max(Red) - min(Red);
WP = max(Purple) - min(Purple);
WBR = max(Brown) - min(Brown);
WG = max(Green) - min(Green);
WY = max(Yellow) - min(Yellow);
WB = max(Blue) - min(Blue);

%%
tol_red = (1/sum(R))*(WR./R);
tol_blue = (1/sum(B))*(WB./B);
tol_green = (1/sum(G))*(WG./G);
tol_brown = (1/sum(BR))*(WBR./BR);
tol_purple = (1/sum(P))*(WP./P);
tol_yellow = (1/sum(Y))*(WY./Y);
     
%%
save ('tolerance.mat' , 'tol_red', 'tol_blue' , 'tol_green' , 'tol_brown' ,'tol_brown' ,'tol_purple','tol_yellow' );

%%
tol_red = [.2*R(1),.2*R(2),.2*R(3)];
tol_blue = [.2*B(1),.3*B(2),.3*B(3)];
tol_green = [.2*G(1),.3*G(2),.3*G(3)];
tol_yellow = [.2*Y(1),.2*Y(2),.2*Y(3)];
tol_brown = [.2*BR(1),.3*BR(2),.3*BR(3)];
tol_purple = [.2*P(1),.2*P(2),.2*P(3)];