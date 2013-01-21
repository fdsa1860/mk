% MK class definition

classdef MK
    properties
        currFrame;
        previousFrame;
        nRows;
        nCols;
        currBlob;
        currFG;
        bg_img;
        bb;
        frameNo;
        nDiffPixels;
        histo;
        previousHisto;
        K;
        brightnessValue;
        brightnessValuePt;
    end
    methods
        %----------------------------------------------
        % constructor
        function obj=MK(currFrame,bg_img,frameNo)
            obj.currFrame=currFrame;
            obj.previousFrame=currFrame;
            obj.nRows=size(currFrame,1);
            obj.nCols=size(currFrame,2);
            obj.currBlob=zeros(size(currFrame),'uint8');
            obj.currFG=zeros(size(currFrame),'uint8');
            obj.bg_img=bg_img;
            obj.bb=[];
            obj.frameNo=frameNo;
            obj.nDiffPixels=0;
            obj.histo=[];
            obj.previousHisto=[];
            obj.K=[];
            obj.currFrame=currFrame;            
            obj = obj.getBlob(10);
            obj = obj.blob2bbox(100);
            obj.currBlob = repmat(obj.currBlob,[1 1 3]);
            obj.currFG = obj.currBlob.*currFrame;
            obj = obj.getHist();
            obj.previousHisto = obj.histo;
            obj.brightnessValue = 0;
            obj.brightnessValuePt = 0;
        end
        %----------------------------------------------
        % differiential neighbor frames
        function y=frameDiff(obj,thr)
            A=abs(double(obj.currFrame)-double(obj.previousFrame));
            y=nnz(A>thr);
        end
        %----------------------------------------------
        % Get blobs
        function obj=getBlob(obj,thr)
            grayFrame = rgb2gray(obj.currFrame);
            grayBG = rgb2gray(obj.bg_img);
            fg = im2double(grayFrame)-im2double(grayBG);
            fg = medfilt2(fg, [5 5]);
            fgBlob = zeros(size(fg),'uint8');
            fgBlob(abs(fg*255)>thr)=1;
            obj.currBlob=fgBlob;
        end
        %----------------------------------------------
        % Get bounding boxes from blobs
        function obj=blob2bbox(obj,thr)
            CC = bwconncomp(obj.currBlob,8);
            nObj = CC.NumObjects;
            obj.bb = zeros(nObj,4);
            for i=1:nObj
                [indr,indc]=ind2sub(CC.ImageSize,CC.PixelIdxList{i});
                obj.bb(i,:)=[min(indc) min(indr) max(indc)-min(indc)+1 max(indr)-min(indr)+1];
            end
            obj.bb(obj.bb(:,3).*obj.bb(:,4)<thr,:)=[];
        end
        %-----------------------------------------------
        % process frame
        function obj=frameProcess(obj,currFrame)
            obj.currFrame=currFrame;            
            obj = obj.getBlob(10);
            obj = obj.blob2bbox(100);
            obj.currBlob = repmat(obj.currBlob,[1 1 3]);
            obj.currFG = obj.currBlob.*currFrame;
            obj = obj.getHist();
            obj.K = kernel(obj.histo',obj.previousHisto');
            obj.nDiffPixels = obj.frameDiff(10);
            obj.previousFrame = obj.currFrame;            
            obj.previousHisto = obj.histo;            
            obj.frameNo = obj.frameNo + 1;
        end
        %-----------------------------------------------
        % process frame
        function obj=frameProcess2(obj,currFrame,objLists)
            obj.currFrame=currFrame;
            for i=1:length([objLists.id])
                obj.bb(i,:) = objLists(i).pos;
            end
        end
        %-----------------------------------------------
        % process frame
        % convert to hsv and check illumination value v
        function obj=frameProcess3(obj,currFrame)
            obj.currFrame=currFrame;
            hsvFrame = rgb2hsv_fast(currFrame);
            obj.brightnessValue = mean2(hsvFrame(:,:,3));
            obj.brightnessValuePt = hsvFrame(100,100,3);
        end
        %-----------------------------------------------
        % Get histogram
        function obj=getHist(obj)
            obj.histo=[];
            FG=obj.currFG;
            b=obj.bb;
            for i=1:size(b,1)
                fg = FG(b(i,2):b(i,2)+b(i,4)-1,b(i,1):b(i,1)+b(i,3)-1,:);
                fg = rgb2hsv_fast(fg,'','H');
                fg = fg(:);
                fg = fg(fg~=0);
                fg = im2uint8(fg);
                obj.histo(i,:)=hist(fg,0:255);
            end

        end
        %-----------------------------------------------
        % display frame
        function disp(obj)
            figure(1);
            subplot(1,2,1);
            imshow(obj.currFrame);
            title(['frame ' num2str(obj.frameNo)]);
            subplot(1,2,2);
            imshow(obj.currFG);
            hold on;
            for i=1:size(obj.bb,1)
                rectangle('Position',obj.bb(i,:),'EdgeColor','b');
            end
            hold off;
        end
        %-----------------------------------------------
        % display frame
        function disp1(obj)
            figure(1);
            subplot(1,2,1);
            imshow(obj.currFrame);
            title(['frame ' num2str(obj.frameNo)]);
            subplot(1,2,2);
            imshow(obj.currFG);
            hold on;
            for i=1:size(obj.bb,1)
                rectangle('Position',obj.bb(i,:),'EdgeColor','b');
            end
            hold off;
        end
        %-----------------------------------------------
        % display frame
        function disp3(obj)
            figure(1);
            subplot(2,2,1);
            imshow(obj.currFrame);
            title(['frame ' num2str(obj.frameNo)]);
            subplot(2,2,2);
            imshow(obj.currFG);
%             hold on;
%             for i=1:size(obj.bb,1)
%                 rectangle('Position',obj.bb(i,:),'EdgeColor','b');
%             end
%             hold off;

        end
        %-----------------------------------------------
    end
end