function numLabel = strLabel2numLabel(strLabel)

assert(iscell(strLabel));
if cellfun(@isempty,strLabel)
    error('strLabel is empty');
end

numLabel = zeros(length(strLabel),1);

for i = 1:length(strLabel)
    if strcmp(strLabel{i},'none')
        numLabel(i) = 0;
    elseif strcmp(strLabel{i},'stationary')
        numLabel(i) = -1;
    elseif strcmp(strLabel{i},'locomotion')
        numLabel(i) = 1;
    elseif strcmp(strLabel{i},'chasing')
        numLabel(i) = 3;
    elseif strcmp(strLabel{i},'avoiding')
        numLabel(i) = -2;
    elseif strcmp(strLabel{i},'fleeing')
        numLabel(i) = -2; % merge flee into avoid
    else
        error('no label matched with %s',strLabel{i});
    end
end

end