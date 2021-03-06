% MK class definition

% Modified by Xikang Zhang, 04/18/2013
% constructor modified to accept variant inputs
% function init() created
% function disp() modified

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
        bb_pre;
        wgt;
        isTrgt;
        frameNo;
        nDiffPixels;
        histo;
        previousHisto;
        K;
        brightnessValue;
        brightnessValuePt;
        trackingModel;
    end
    methods
        %----------------------------------------------
        % Constructor
        function obj=MK(currFrame,bg_img,frameNo)
            
            if nargin<3
                obj.frameNo=0;
            else
                obj.frameNo=frameNo;
            end
            
            if nargin<2
                obj.bg_img=[];
            else
                obj.bg_img=bg_img;
            end
            
            obj.currFrame=currFrame;
            obj.previousFrame=currFrame;
            obj.nRows=size(currFrame,1);
            obj.nCols=size(currFrame,2);
            obj.currBlob=zeros(size(currFrame),'uint8');
            obj.currFG=zeros(size(currFrame),'uint8');
            obj.bb=[];
            obj.wgt=[];
            obj.bb_pre=[];
            obj.isTrgt=[];
            obj.nDiffPixels=0;
            obj.histo=[];
            obj.previousHisto=[];
            obj.K=[];
            obj.currFrame=currFrame;
            obj.previousHisto = [];
            obj.brightnessValue = 0;
            obj.brightnessValuePt = 0;
            obj.trackingModel = [];
        end
        %----------------------------------------------
        % Initialization
        function obj=init(obj)
            obj = obj.getBlob(10);
            obj = obj.blob2bbox(100);
            obj.currBlob = repmat(obj.currBlob,[1 1 3]);
            obj.currFG = obj.currBlob.*obj.currFrame;
            obj = obj.getHist();
            obj.previousHisto = obj.histo;
        end
        %----------------------------------------------
        % Initialization1
        function obj=init5(obj,initType,currFrame,numTargets)
            figure(1);clf;
            imshow(currFrame);
            switch initType
                case 'manual'
                    initModel = cell(numTargets,1);
                    for i=1:numTargets
                        rect = getrect;
                        rectangle('Position',rect,'EdgeColor','b');
                        obj.bb = [obj.bb;rect];
                        objBox = rec2w(rect); % objBox = [left,right,top,bottom];
                        initModel{i} = tkTemplateMatch_Init(currFrame, objBox);
                    end
                case'automatic'
                    obj = obj.detect(currFrame);
                    rect = obj.bb;
                    for i=1:size(rect,1)
                        objBox = rec2w(rect(i,:)); % objBox = [left,right,top,bottom];
                        initModel{i} = tkTemplateMatch_Init(currFrame, objBox);
                    end
                otherwise
            end
            obj.trackingModel = initModel;
        end
        %----------------------------------------------
        % detect
        function obj = detect(obj,currFrame)
            nonMaxSupWinSiz = 30;
            weightTH = 0.3;
            obj.currFrame = currFrame;
            modelName = 'hog_cam2_model_standard.xml';
            if ~exist(modelName,'file')
                error('model name does not exist\n');
            end
            [bbox,weights] = hogDetect('detect',modelName,currFrame);
            bbox = double(bbox);
            if ~isempty(bbox)
                [bbox,weights] = groupBBox_nonMaxSup(bbox,weights,nonMaxSupWinSiz);
                [obj.bb obj.wgt] = thresholdFilter(bbox,weights,weightTH);
            end
        end
        %----------------------------------------------
        % detect
        function obj = lbp_detect(obj,currFrame)
            nonMaxSupWinSiz = 30;
            weightTH = 0.3;
            obj.currFrame = currFrame;
            modelName = 'lbp_model_temp.mat';
            if ~exist(modelName,'file')
                error('model name does not exist\n');
            end
            load(modelName,'model');
            [bbox,weights] = lbpDetect(currFrame,model);
            bbox = double(bbox);
            if ~isempty(bbox)
                [bbox,weights] = groupBBox_nonMaxSup(bbox,weights,nonMaxSupWinSiz);
                [obj.bb obj.wgt] = thresholdFilter(bbox,weights,weightTH);
            end
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
            obj = obj.getBlob(30);
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
            obj.bb = [];
            for i=1:length(objLists)
                obj.bb(i,:) = objLists(i).pos;
            end
            obj.frameNo = obj.frameNo + 1;
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
        % process frame
        % detect
        function obj=frameProcess4(obj,processName,currFrame)
            switch processName
                case 'hog_detect'
                    obj = obj.detect(currFrame);
                case 'lbp_detect'
                    obj = obj.lbp_detect(currFrame);
                otherwise
            end
        end
        %-----------------------------------------------
        % Process frame
        % tracking
        function obj=frameProcess5(obj,currFrame)
            obj.currFrame = currFrame;
            for i=1:length(obj.trackingModel)
                [objBox, objMask] = tkTemplateMatch_Next(obj.trackingModel{i}, currFrame, rec2w(obj.bb(i,:)));
                obj.bb(i,:) = w2rec(objBox);
            end
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
        % display frame with bounding boxes
        function disp(obj)
            figure(1);
            imshow(obj.currFrame);
            hold on;
            %             title(['frame ' num2str(obj.frameNo)]);
            for i=1:size(obj.bb,1)
                rectangle('Position',obj.bb(i,:),'EdgeColor','r');
            end
            hold off;
        end
        %-----------------------------------------------
        % display frame and foreground with bounding box
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
        % display frame and bbox with data association
        function disp2(obj)
            figure(1);
            imshow(obj.currFrame);
            hold on;
            title(['frame ' num2str(obj.frameNo)]);
            for i=1:size(obj.bb,1)
                if obj.isTrgt(i)
                    color = 'r';
                else
                    color = 'b';
                end
                rectangle('Position',obj.bb(i,:),'EdgeColor',color);
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