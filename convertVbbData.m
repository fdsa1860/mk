function bb = convertVbbData(fileName)

if nargin==0
    fileName = './data/Temp1-134700.txt';
end

addpath(genpath('C:\zxk\code3.0.0'));
A = vbb('vbbLoadTxt', fileName );

bb=[];

for frameNo=1:length(A.objLists)
    pos=[];
    if ~isempty(A.objLists{frameNo})
        if length([A.objLists{frameNo}.id])==5
            for i=1:length([A.objLists{frameNo}.id])
                rect = A.objLists{frameNo}(i).pos;
                xc = rect(1)+floor(rect(3)/2)-160;
                yc = rect(2)+floor(rect(4)/2)-120;
                pos = [ pos [xc;yc] ];
            end
        end
    end
    bb = [bb;pos];
end

end
