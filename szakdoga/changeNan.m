function y=changeNan(mit, mire) 
for m=1:size(mit)
    if isnan(mit(m))
        mit(m) = mire(m);
    end
end
y = mit;



