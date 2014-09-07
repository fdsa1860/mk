
% Generate groundtruth detection log for cpp code

function log = temp

addpath(genpath('C:\zxk\Research\code3.0.0'));
% filePath = 'C:\zxk\Research\monkeyData\Camera1_extractedVideos';
filePath = 'C:\zxk\Research\monkeyData\Camera2_labeledVideos';

firstVideoNumber = 100;
lastVideoNumber = 100;
for videoNumber = firstVideoNumber:lastVideoNumber    
    folderName = [ '_extracted_' sprintf('%03d',videoNumber) ];
    labelFileName = [ folderName '.txt' ];    
    A = vbb('vbbLoadTxt', [filePath '\' folderName '\' labelFileName ] );
    
%     newLabelFileName = 'GTlog.txt';
%     fid = fopen([filePath '\' folderName '\' newLabelFileName ],'w');
    
    log = [];
    numFrames = length(A.objLists);    
    for frameNo=1:numFrames        
        numObj = length([A.objLists{frameNo}.id]);
        for i=1:numObj
            log = [log [frameNo; A.objLists{frameNo}(i).pos'] ];
        end
    end
    
%     fprintf(fid,'%d %6.6f %6.6f %6.6f %6.6f\r\n',log);
%     fclose(fid);
end

end