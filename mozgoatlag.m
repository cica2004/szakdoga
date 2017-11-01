function y = mozgoatlag(vector, tav)
% Mogzoatlag
% vector : az a vector amit átlagolni szeretnénk
% tav : az aktuális elemtõl a legtávolabb lévõ még beszámító elem mindkét
% irányba ha a tav = 3 és éppen az i-dik elemnél járunk
% akkor i-3 + i-2 .. i .. + i+2 + i+3 elemek átlagát vesszük

y = zeros(size(vector,1),1);
for i = (1+tav) : (size(vector,1)-tav),
    y(i) = mean(vector(i-tav : i+tav));
end
y = y(1+tav : size(vector,1)-tav, 1);

