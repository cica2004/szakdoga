function y = mozgoatlag(x,n)
% Mogzoatlag
y = zeros(size(x,1),1);
for i = (1+n) : (size(x,1)-n),
    y(i) = mean(x(i-n:i+n));
end
y = y(1+n : size(x,1)-n,1);

