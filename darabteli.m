function y = darabteli(x, z)
y = zeros(size(x));
for i = 1:length(x)
    y(i) = sum(x==x(i));
end
sum(x(:) < z)
