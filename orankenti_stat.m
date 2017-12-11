function x = orankenti_stat(data, napok, n, m) 
    %data : az adatok amiket felszeretnénk dolgozni
    %napok : mennyi napot kap meg az algoritmus
    hossz = length(data);
    data_reshape = reshape(data, 24, hossz/24); 
    eredmeny = data_reshape(1:24, 1:napok);
    for i = napok : length(data_reshape) - 1,
        if n == 0,
            k = 1;
        else
            k = i - n + 1;
        end
        if strcmp(m, 'mean'),
            tmp = mean(data_reshape(1 : 24, k : i), 2);
        end
        if strcmp(m, 'median'),
            tmp = median(data_reshape(1 : 24, k : i), 2);
        end
        eredmeny = [eredmeny, tmp]; 
    end
    x = reshape(eredmeny, hossz, 1);
end
