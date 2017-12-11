function [y, db] = darabteli(x, z)
y = zeros(size(x));
for i = 1:length(x)
    %y(i) = sum(x==x(i));
    if strcmp(x(i,1:2), z)
        y(i,1) = 1;
    else
        y(i,1) = 0;
    end
end
db = sum(y(:,1));


