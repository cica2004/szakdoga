function [eredmeny] = forecast_rec(data, K)
    eredmeny = data(1:2*K, :);
    for i = 2*K : K : length(data) - K,
        sys = ar(data(1:i, :), K);
        eredmeny = [eredmeny; forecast(sys, data(1:i, 1), K)];
    end
end
