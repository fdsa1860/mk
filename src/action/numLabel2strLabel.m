function strLabel = numLabel2strLabel(numLabel)

if isempty(numLabel)
    error('numLabel is empty');
end

strLabel = cell(numel(numLabel), 1);

for i = 1:numel(numLabel)
    if numLabel(i) == 0
        strLabel{i} = 'none';
    elseif numLabel(i) == -1
        strLabel{i} = 'stationary';
    elseif numLabel(i) == 1
        strLabel{i} = 'locomotion';
    elseif numLabel(i) == 3
        strLabel{i} = 'chasing';
    elseif numLabel(i) == -2
        strLabel{i} = 'avoiding';
    else
        error('no label matched with %d\n', numLabel(i));
    end
end

end