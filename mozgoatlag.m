function y = mozgoatlag(vector, tav)
% Mogzoatlag
% vector : az a vector amit �tlagolni szeretn�nk
% tav : az aktu�lis elemt�l a legt�volabb l�v� m�g besz�m�t� elem mindk�t
% ir�nyba ha a tav = 3 �s �ppen az i-dik elemn�l j�runk
% akkor i-3 + i-2 .. i .. + i+2 + i+3 elemek �tlag�t vessz�k

y = zeros(size(vector,1),1);
for i = (1+tav) : (size(vector,1)-tav),
    y(i) = mean(vector(i-tav : i+tav));
end
y = y(1+tav : size(vector,1)-tav, 1);

