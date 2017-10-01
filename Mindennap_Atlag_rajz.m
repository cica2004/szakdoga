clear all;
mindennap;
Mindennap_2minimumAtlagaval;
Mindennap_3minimumAtlagaval;

figure1 = figure;
axes1 = axes('Parent',figure1);
box(axes1,'on');
hold(axes1,'all');
plot(Hiba,'Parent',axes1);
plot(Hiba2,'Parent',axes1);
plot(Hiba3,'Parent',axes1);
hold off;

figure2 = figure;
axes2 = axes('Parent',figure2);
box(axes1,'on');
hold(axes2,'all');
% bar(Statisztika,'DisplayName','Statisztika')
subplot(2,2,1);
bar(Statisztika,'Parent',axes2);
title('Az elsõnek legjobban hasonlító napok');
subplot(2,2,2);
bar(Statisztika2,'Parent',axes2);
title('Az másodiknak legjobban hasonlító napok');
subplot(2,2,3);
bar(Statisztika3,'Parent',axes2);
title('Az harmadiknak legjobban hasonlító napok');
hold off;
