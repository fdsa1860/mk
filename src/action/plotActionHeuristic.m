% Color Code

%( Node x)    vs    (Unique color of All the arrows emanating from node x)

% 1       yellow
% 2       magenta
% 3       cyan
% 4       red
% 5       green
% 6       blue
% 7       white
% 8       black
% 9       (saddle) brown
% 10      dark green

clearvars;close all
% load('chaseMat.mat');
% load('avoidMat.mat');
load('actionMat');

videoPath = 'C:\zxk\Research\monkeyData\video20121011_cam1_extracted\_extracted_009';
load('u009.mat');load('v009.mat');load('im_name009.mat');n1=501;n2=1000;

width =4;
k_mat = [1 4 7;2 5 8;3 6 9];
step=1;

color = [1 1 0;1 0 1;0 1 1;1 0 0; 0 1 0;0 0 1;1 1 1;0 0 0; 0.5430 0.2695 0.0742;0 0.3906 0];

for i=n1:n2
    
%     ConnectionStr = chaseMat(:,:,ceil(i/frSegSize));
%     ConnectionStr = avoidMat(:,:,ceil(i/frSegSize));
    ConnectionStr = actionMat(:,:,i);
    
    h = figure(1);
    im = imread(fullfile(videoPath,im_name{i}));
    imshow(im);
    hold on
    for k=1:size(u,1)
        
        %rectangle('Position',[u(k,i) v(k,i)-40 10 10],'Curvature',[1 1],'LineWidth',width,'FaceColor',color(k,:))
        index = find(ConnectionStr(:,k)==2);
        for j=1:length(index)
            % quiver(u(k,i),v(k,i)+randi(10),u(index(j),i)-u(k,i),v(index(j),i)-v(k,i),'LineWidth',width,'Color',color(k,:));
            quiver(u(index(j),i),v(index(j),i)+randi(10),-u(index(j),i)+u(k,i),-v(index(j),i)+v(k,i),'LineWidth',width,'Color',color(k,:));
%             text(u(k,i)+20,v(k,i)+20,'FLEE','Color','g');
            text(u(k,i)+20,v(k,i)+20,'AVOID','Color','m');
        end
        index = find(ConnectionStr(:,k)==-2);
        for j=1:length(index)
            % quiver(u(k,i),v(k,i)+randi(10),u(index(j),i)-u(k,i),v(index(j),i)-v(k,i),'LineWidth',width,'Color',color(k,:));
            quiver(u(k,i),v(k,i)+randi(10),u(index(j),i)-u(k,i),v(index(j),i)-v(k,i),'LineWidth',width,'Color',color(k,:));
%             text(u(k,i)+20,v(k,i)-20,'CHASE','Color','g');
            text(u(k,i)+20,v(k,i)-20,'LOCOMOTION','Color','m');
        end
        index = find(ConnectionStr(:,k)==3);
        for j=1:length(index)
            % quiver(u(k,i),v(k,i)+randi(10),u(index(j),i)-u(k,i),v(index(j),i)-v(k,i),'LineWidth',width,'Color',color(k,:));
            quiver(u(index(j),i),v(index(j),i)+randi(10),-u(index(j),i)+u(k,i),-v(index(j),i)+v(k,i),'LineWidth',width,'Color',color(k,:));
            text(u(k,i)+20,v(k,i)+20,'FLEE','Color','r');
%             text(u(k,i)+20,v(k,i)+20,'AVOID','Color','g');
        end
        index = find(ConnectionStr(:,k)==-3);
        for j=1:length(index)
            % quiver(u(k,i),v(k,i)+randi(10),u(index(j),i)-u(k,i),v(index(j),i)-v(k,i),'LineWidth',width,'Color',color(k,:));
            quiver(u(k,i),v(k,i)+randi(10),u(index(j),i)-u(k,i),v(index(j),i)-v(k,i),'LineWidth',width,'Color',color(k,:));
            text(u(k,i)+20,v(k,i)-20,'CHASE','Color','r');
%             text(u(k,i)+20,v(k,i)-20,'LOCOMOTION','Color','g');
        end
        index = find(ConnectionStr(:,k)==1);
        for j=1:length(index)
            % quiver(u(k,i),v(k,i)+randi(10),u(index(j),i)-u(k,i),v(index(j),i)-v(k,i),'LineWidth',width,'Color',color(k,:));
%             quiver(u(index(j),i),v(index(j),i)+randi(10),-u(index(j),i)+u(k,i),-v(index(j),i)+v(k,i),'LineWidth',width,'Color',color(k,:));
            text(u(k,i)+20,v(k,i)+20,'STATIONARY','Color','g');
%             text(u(k,i)+20,v(k,i)+20,'AVOID','Color','g');
        end
        index = find(ConnectionStr(:,k)==-1);
        for j=1:length(index)
            % quiver(u(k,i),v(k,i)+randi(10),u(index(j),i)-u(k,i),v(index(j),i)-v(k,i),'LineWidth',width,'Color',color(k,:));
%             quiver(u(k,i),v(k,i)+randi(10),u(index(j),i)-u(k,i),v(index(j),i)-v(k,i),'LineWidth',width,'Color',color(k,:));
            text(u(k,i)+20,v(k,i)-20,'LOCOMOTION','Color','g');
%             text(u(k,i)+20,v(k,i)-20,'LOCOMOTION','Color','g');
        end
        %        text(u(k,step*(i-1)+1),v(k,step*(i-1)+1),sprintf('#
        %        %g',k),'BackgroundColor',[.7 .9 .7]);
        text(u(k,step*(i-1)+1),v(k,step*(i-1)+1),sprintf('monkey %g',k));
    end
    hold off;
    %      pause(1)
    print(h,'-djpeg',sprintf('./output/frame%04d.jpeg',i));
end