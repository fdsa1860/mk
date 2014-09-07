% Create a csv log file
% 08/27/2013, by Xikang Zhang
% C:\zxk\Research\monkey\monkey_cppPrj\testLBP\data\posExamples\Camera1_pos
% _000001.png;0

posPath = 'C:\zxk\Research\monkeyData\Camera4_labeledVideos_Patch_Pos';
negPath = 'C:\zxk\Research\monkeyData\Camera4_labeledVideos_Patch_Neg3';
posFiles = dir([posPath '\*.png']);
negFiles = dir([negPath '\*.png']);

fid = fopen('mycsv.txt','w');
for i=1:length(posFiles)
    fprintf(fid,'%s\r\n',[posPath '\' posFiles(i).name ';1']);
end
for i=1:length(negFiles)
    fprintf(fid,'%s\r\n',[negPath '\' negFiles(i).name ';-1']);
end
fclose(fid);