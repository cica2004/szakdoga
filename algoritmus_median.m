function x = algoritmus_median(data)
    hossz = length(data);
    eredmeny = data(1:24, 1);
    for i = 25 : 24 : length(data) - 24, 
        tmp = median(data(1:i, :));
        tmp = mean(data(i-24:i, :));
        eredmeny = [eredmeny; repmat(tmp, 24, 1)]; 
    end
    x = eredmeny;
end