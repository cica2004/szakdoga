
t1 = datenum('2012-01-01 00:00:00', 'yyyy-mm-dd HH:MM:SS');
t2 = datenum('2017-08-31 23:00:00', 'yyyy-mm-dd HH:MM:SS');
t = t1:1/24:t2;
datumInt=reshape(t,size(t,2),1);
[DayNumber,DayName] = weekday(datumInt);
DateString = datestr(datumInt);

legkisebb_ar_hely = DateString(find(arak == min(arak(:))),:);