function x = orankentiatlag(data) 
    hossz = length(data);
    data_reshape = reshape(data, 24, hossz/24);  
    eredmeny = data_reshape(1:24, 1:2);
    for i = 2 : length(data_reshape) - 1, 
        tmp = mean(data_reshape(1:24, 1:i), 2);
        eredmeny = [eredmeny, tmp]; 
    end
    x = reshape(eredmeny', hossz, 1);
end