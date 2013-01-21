% function dispNetwork(Wx,ConnectionStr)

f1=figure;
%screen_size = get(0, 'ScreenSize');


%set(f1,'Position',[6   247   884   566]);

inputFileDir1='.\cam1_320x240_jpg';
inputFileDir2='.\cam2_320x240_jpg';
inputFileDir3='.\cam3_320x240_jpg';
inputFileDir4='.\cam4_320x240_jpg';
inputFileDir=inputFileDir1;
inputFileType='.jpg'; % TODO: modify file type name

figure(f1);
paramz.LineWidth=2;
paramz.Color=[0 0 0];

firstFrame = 134700;
lastFrame = 134749;
order = 2;
for frameNo=firstFrame:lastFrame
    % read input frame
    inputFileName=['Temp1-' num2str(frameNo) inputFileType];
    if exist([inputFileDir '\' inputFileName],'file')
        currFrame=imread([inputFileDir '\' inputFileName]);
    end
    figure(f1);
    imshow(currFrame,'Border','tight');drawnow;
    
    col=[1 0 0;0 1 0; 0 0 1; 0 1 1;1 1 0];
    for kk=1:5
        figure(f1);
        hold on;
        x1=Wmonkey(1:2:2*(frameNo-firstFrame+1)-1,kk);
        y1=Wmonkey(2:2:2*(frameNo-firstFrame+1),kk);
        plot(x1,y1,'-','LineWidth',2,'Color',col(kk,:));
        
%         x2=WW_est(1:2:2*(frameNo-firstFrame+1-order)-1,kk);
%         y2=WW_est(2:2:2*(frameNo-firstFrame+1-order),kk);
%         plot(x2,y2,'-','LineWidth',2,'Color',col(kk,:));
        
        paramz.Color=col(kk,:);
        %[hh, x,y]=circle([x1(end) y1(end)],10,50,paramz);
        
        %vectarrow(x1,[x1(end) y1(end)],'k-','LineWidth',2); drawnow;
        
        kkk=setdiff(1:5,kk);
        for ii=kkk
            if(ConnectionStr(ii,kk)==1)
                xxx=Wmonkey(1:2:2*(frameNo-firstFrame+1)-1,ii);
                yyy=Wmonkey(2:2:2*(frameNo-firstFrame+1),ii);
                params.LineWidth=2;
                params.Color=col(ii,:);
                
                
                %vectarrowtennis([xxx(end) yyy(end)],[x1(end)+5 y1(end)],'-',params); drawnow;
                
                
                arr=10*sign([xxx(end) yyy(end)]-[x1(end) y1(end)]);
                
                
                vectarrowtennis([xxx(end) yyy(end)],[x1(end)+arr(1) y1(end)+arr(2)],'-',params); drawnow;
            end
        end
    end
    
end

