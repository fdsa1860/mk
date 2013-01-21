function K = kernel(X1,X2)

K = zeros(size(X1,2),size(X2,2));
for i=1:size(X1,2)
    for j=1:size(X2,2)
        % intersection between two vectors
        K(i,j) = sum(min(X1(:,i), X2(:,j)));
    end
end

end