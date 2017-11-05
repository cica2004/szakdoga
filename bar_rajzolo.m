x=1:size(y,2);
numberOfBars = size(y,2);
barFontSize = 15;

for b = 1 : numberOfBars
	% Plot one single bar as a separate bar series.
	handleToThisBarSeries(b) = bar(x(b), y(b), 'BarWidth', 0.9);	
	% Place text atop the bar
	barTopper = sprintf('%.3f', y(b));
	text(x(b)-0.2, y(b)+3, barTopper, 'FontSize', barFontSize);
	hold on;
end
%names=[HUATmenetrend; HUATmeres; HUHRmenetrend; HUHRmeres; HUROmenetrend; HUROmeres; HURSmenetrend; HURSmeres; HUSKmenetrend; HUSKmeres; HUUKmenetrend; HUUKmeres];
set(gca,...
'XTickLabel',{'HUATmenetrend','HUATmeres','HUHRmenetrend','HUHRmeres     ','HUROmenetrend ','HUROmeres','HURSmenetrend  ','HURSmeres     ','HUSKmenetrend     ','HUSKmeres','HUUKmenetrend','HUUKmeres'},...
'XTick',[1 2 3 4 5 6 7 8 9 10 11 12],...
'FontSize',11);