% function to get monkey patches from videos
% Xikang Zhang, 02/26/2013

function mk_getMonkeyPatch(Display)

if nargin<1
    Display=0;
end

addpath(genpath('C:\zxk\Research\code3.0.0'));
% filePath = 'C:\zxk\Research\monkeyData\Camera1_extractedVideos';
% % outputDir = 'C:\zxk\Research\monkeyData\Camera1_extractedVideos_harrPatch';
% outputDir1 = 'C:\zxk\Research\monkeyData\Camera1_extractedVideos_Patch_Pos';
% if ~isempty(outputDir1)
%     if ~isdir(outputDir1)
%         mkdir(outputDir1);
%     end
% end
% outputDir2 = 'C:\zxk\Research\monkeyData\Camera1_extractedVideos_Patch_Neg';
% if ~isempty(outputDir2)
%     if ~isdir(outputDir2)
%         mkdir(outputDir2);
%     end
% end

filePath = 'C:\zxk\Research\monkeyData\Camera4_labeledVideos';
% outputDir ='C:\zxk\Research\monkeyData\Camera4_extractedVideos_harrPatch';
outputDir1 = 'C:\zxk\Research\monkeyData\Camera4_labeledVideos_Patch_Pos';
if ~isempty(outputDir1)
    if ~isdir(outputDir1)
        mkdir(outputDir1);
    end
end
outputDir2 = 'C:\zxk\Research\monkeyData\Camera4_labeledVideos_Patch_Neg3';
if ~isempty(outputDir2)
    if ~isdir(outputDir2)
        mkdir(outputDir2);
    end
end

numNeg = 5;
negWidRange = [80 400];
negHgtRange = [80 400];
% imgWidRange = [273 1124];
% imgHgtRange = [145 950];
imgWidRange = [1 1360];
imgHgtRange = [1 1024];
areaRatioThresh = 0.0;

ver = version('-release');
if strcmp(ver,'R2010a')
    s = RandStream.create('mt19937ar','seed',1);
    RandStream.setDefaultStream(s);
elseif strcmp(ver,'R2013a')
    s = RandStream('mt19937ar','Seed',1);
    RandStream.setGlobalStream(s);
end

numResizeRows = 60;
numResizeCols = 60;
countp = 0;
countn = 0;
firstVideoNumber = 100;
lastVideoNumber = 100;

for videoNumber = firstVideoNumber:lastVideoNumber
    
    folderName = [ '_extracted_' sprintf('%03d',videoNumber) ];
    labelFileName = [ folderName '.txt' ];
    
    A = vbb('vbbLoadTxt', [filePath '\' folderName '\' labelFileName ] );
    B = dir([filePath '\' folderName '\' '*.png']);
    assert(A.nFrame==length(B));
    
    numFrames = length(A.objLists);
    for frameNo=1:numFrames
        fprintf('Processing Frame %d / %d ...\n',frameNo,numFrames);
        I = imread([filePath '\' folderName '\' B(frameNo).name],'png');
        %     figure(1);
        %     imshow(I);
        if isempty(A.objLists{frameNo})
            continue;
        end
        % generate positive patches
        rect = [];
        numObj = length([A.objLists{frameNo}.id]);
        for i=1:numObj
            if A.objLists{frameNo}(i).occl==1
                continue;
            end
            rect = [rect; round(A.objLists{frameNo}(i).pos)];
            patch = I(rect(end,2):rect(end,2)+rect(end,4)-1,rect(end,1):rect(end,1)+rect(end,3)-1,:);
            harrPatch = imresize(patch,[numResizeRows numResizeCols]);
            harrPatch_mirror = harrPatch(:,end:-1:1,:);
            if Display
                figure(2);
                imshow(patch);
                pause(0.1);
            end
            imwrite(harrPatch,[outputDir1 '\' 'Camera4_pos_' sprintf('%06d',countp) '.png'],'png');
            countp = countp + 1;
            imwrite(harrPatch_mirror,[outputDir1 '\' 'Camera4_pos_' sprintf('%06d',countp) '.png'],'png');
            countp = countp + 1;
        end
        % generate negative patches
        for i=1:numNeg            
            isValid = false;
            while ~isValid
                negWid = randi(negWidRange);
                negHgt = randi(negHgtRange);
                negLeft = randi([imgWidRange(1) imgWidRange(2)-negWid]);
                negTop = randi([imgHgtRange(1) imgHgtRange(2)-negHgt]);
                negRect = [negLeft negTop negWid negHgt];
                if isempty(rect)                    
                    break;
                end
                intArea = rectint(negRect, rect)';
                sumArea = negWid*negHgt+rect(:,3).*rect(:,4);
                areaRatio = intArea./sumArea;
                if max(areaRatio)<=areaRatioThresh
                    isValid = true;
                end
            end
            negPatch = I(negTop:negTop+negHgt, negLeft:negLeft+negWid,:);
            harrNegPatch = imresize(negPatch,[numResizeRows numResizeCols]);
            if Display
                figure(3);
                imshow(negPatch);
                pause(0.1);
            end
            imwrite(harrNegPatch,[outputDir2 '\' 'Camera4_neg_' sprintf('%06d',countn) '.png'],'png');
            countn = countn + 1;
        end
        
    end
end

end