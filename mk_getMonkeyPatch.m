% function to get monkey patches from videos
% Xikang Zhang, 02/26/2013

function mk_getMonkeyPatch(Display)

if nargin<1
    Display=0;
end

addpath(genpath('C:\zxk\Research\code3.0.0'));
filePath = 'C:\zxk\Research\monkeyData\Camera1_extractedVideos';
% outputDir = 'C:\zxk\Research\monkeyData\Camera1_extractedVideos_harrPatch';
outputDir1 = 'C:\zxk\Research\monkeyData\Camera1_extractedVideos_Patch_Pos';
if ~isempty(outputDir1)
    if ~isdir(outputDir1)
        mkdir(outputDir1);
    end
end
outputDir2 = 'C:\zxk\Research\monkeyData\Camera1_extractedVideos_Patch_Neg';
if ~isempty(outputDir2)
    if ~isdir(outputDir2)
        mkdir(outputDir2);
    end
end

numNeg = 5;
negWidRange = [20 80];
negHgtRange = [20 80];
imgWidRange = [273 1124];
imgHgtRange = [145 950];
areaRatioThresh = 0.2;

s = RandStream('mt19937ar','Seed',1);
RandStream.setGlobalStream(s);
% numResizeRows = 20;
% numResizeCols = 20;
countp = 0;
countn = 0;
firstVideoNumber = 21;
lastVideoNumber = 90;

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
            rect = [rect; round(A.objLists{frameNo}(i).pos)];
            patch = I(rect(i,2):rect(i,2)+rect(i,4),rect(i,1):rect(i,1)+rect(i,3),:);
            %                 harrPatch = imresize(patch,[numResizeRows numResizeCols]);
            if Display
                figure(2);
                imshow(patch);
                pause(0.1);
            end
            imwrite(patch,[outputDir1 '\' 'pos_' sprintf('%06d',countp) '.png'],'png');
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
                intArea = rectint(negRect, rect)';
                sumArea = negWid*negHgt+rect(:,3).*rect(:,4);
                areaRatio = intArea./sumArea;
                if max(areaRatio)<areaRatioThresh
                    isValid = true;
                end
            end
            negPatch = I(negTop:negTop+negHgt, negLeft:negLeft+negWid,:);
            if Display
                figure(3);
                imshow(negPatch);
                pause(0.1);
            end
            imwrite(negPatch,[outputDir2 '\' 'neg_' sprintf('%06d',countn) '.png'],'png');
            countn = countn + 1;
        end
        
    end
end

end