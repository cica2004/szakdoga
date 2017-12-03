function [ACF, PACF] = acf_pacf_meghat(X)
    ACF = autocorr(X);
    PACF = parcorr(X);
end