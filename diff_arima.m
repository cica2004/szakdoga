figure
subplot(2,1,1)
autocorr(arak_without_nan, 80,[], 2)
subplot(2,1,2)
parcorr(arak_without_nan, 80,[], 2)

d_arak = diff(arak_without_nan);
figure
plot(d_arak)
xlim([0,49680])
title('Differenced arak')
figure
subplot(2,1,1)
autocorr(d_arak, 80,[], 2)
subplot(2,1,2)
parcorr(d_arak, 80,[], 2)

dd_arak = diff(d_arak);
figure
plot(dd_arak)
xlim([0,49680])
title('Again difference arak')
figure
subplot(2,1,1)
autocorr(dd_arak, 80,[], 2)
subplot(2,1,2)
parcorr(dd_arak, 80,[], 2)

model = arima(2,1,0);
fit = estimate(model, arak_without_nan);
model = arima('Constant',0,'MA',0.9,'Variance',0.15)