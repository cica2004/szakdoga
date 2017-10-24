function y = exponencialisatlag(x,n,e)
% x maga az idosor
% visszafele a hossza az atlagolando sornak 
% e a legregebbi elem milyen szazalekben vesszük bele az atlagba, a többit
% linearisan veszem ugy hogy utolso 1 
% fejlesztesi lehetoseg hogy egy vector az e is ami sulyokat tartalmazz
y = zeros(size(x,1),1);

suly = zeros(size(n+1, 1), 1);
koz = (1 - e) / (n + 1);
for s = 1 : (size(suly, 1)),
    suly(s) = e + s * koz;
end
for i = (1+n) : (size(x,1)),
    y(i) = mean(x(i-n : i) * suly);
end
y = y(1+n : size(x,1)-n,1);

