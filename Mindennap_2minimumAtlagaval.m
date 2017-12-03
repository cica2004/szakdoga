% Nem teszek k�l�nbs�get a h�tv�g�k, h�tk�znapok �s az �nnepek k�z�tt.
% De viszont a h�rom rendelkez�sre �ll� adatban
% R�gi �r, Brutt�haza termel�s, SK �raml�s  keresek
% Mindh�romban megkeresem az utols� ismert napra legjobban  hasonl�t� adat
% hely�t. �s annak a helynek az �rt�keit �rom a kimenetbe ami a legkisebb
% relat�v hib�t okozza.

hossz = size(arak_without_nan,1);
Ar1=reshape(arak_without_nan, 24, hossz/24);             
Ar1=Ar1';
ellenorzes = reshape(Ar1', hossz, 1);
Br1=reshape(RendszerTerheles, 24, hossz/24);             
Br1=Br1';
SK1=reshape(HUSKmeres_without_nan, 24, hossz/24);             
SK1=SK1';
UK1=reshape(HUUKmeres_without_nan, 24, hossz/24);             
UK1=UK1';
AT1=reshape(HUATmeres_without_nan, 24, hossz/24);             
AT1=AT1';
RO1=reshape(HUROmeres_without_nan, 24, hossz/24);             
RO1=RO1';
RS1=reshape(HURSmeres_without_nan, 24, hossz/24);             
RS1=RS1';
HR1=reshape(HUHRmeres_without_nan, 24, hossz/24);             
HR1=HR1';
nap=reshape(DayNumber, 24, hossz/24);             
nap=nap';

p=7;

kimenet2 = Ar1(1:p,:);     % Ezek a j�solt adatok
Hiba2 = zeros(p,1);
TalaltNap = zeros(p,1);
Sorszam = zeros(p,1); % Keresett nap helye az eredti Ar t�mben
NapPar = ones(p,3);
for nn = p : hossz/24 -1,
    % Ha mondjuk m�rc 5 az utols� ismert adat akkor, az fog a ma v�ltoz�ba
    % ker�lni
    % m�g a xxR nev� m�trixban az �vben m�rc 4 nn ismert adatok ker�lnek
    % az�rt mert ebben az esetben m�rc 5 h�z legink�bb "hasonl�t�" napot
    % keress�k, de nem szeretn�nk ha mag�t m�rc 5 meg tudn� tal�lni, mert
    % annak nem lenne �rtelme
    
    maAr = Ar1(nn,:);         % Utols� ismert adat
    ArR = Ar1(1:nn-1,:); 
    maSK = SK1(nn,:);
    SKR = SK1(1:nn-1,:);        % SK = Szolv�kia fel�l �rkez� �ram
    maBr = Br1(nn,:);
    BrR = Br1(1:nn-1,:);         % Br = Brutt� hazai �ram termel�s
    UKR = UK1(1:nn-1, :);
    ATR = AT1(1:nn-1, :);
    ROR = RO1(1:nn-1, :);
    RSR = RS1(1:nn-1, :);
    HRR = HR1(1:nn-1, :);
    napR = nap(1:nn-1, :);   
    tegnap = Ar1(nn-1,:);

    % Megkeress�k a legkisebb hib�ju napot
    % Relat�v hib�t sz�molok az eddnn adatok �s az utols� ismert adat k�z�tt  
    tmpAr = abs(ArR - ones(nn-1,1)*maAr);
    [Arminimum, Arhely] = min(sum(tmpAr,2));      % Arhely helyen tal�lhat� a mai napra legjobban hasonl�t� Ar  
    tmpSK = abs(SKR - ones(nn-1,1)*maSK);
    [SKminimum, SKhely] = min(sum(tmpSK,2));  
    tmpBr = abs(BrR - ones(nn-1,1)*maBr);
    [Brminimum, Brhely] = min(sum(tmpBr,2));
    
    m = [Arminimum, Brminimum];
    minimumok = esort(m);    % sorba rendezz�k a minimumokat
                             % a legkisebb ker�l a sorv�g�re
    
    % Megkeresem a m�sodik leghasonl�bbat
    tmpAr(Arhely,:) = 10000;
    [Arminimum2, Arhely2] = min(sum(tmpAr,2));
    tmpSK(SKhely,:) = 10000;
    [SKminimum2, SKhely2] = min(sum(tmpSK,2));
    tmpBr(Brhely,:) = 10000;
    [Brminimum2, Brhely2] = min(sum(tmpBr,2));
    
    m2 = [Arminimum2, Brminimum2];
    AtlagArany = m + m2;
    minimumokArany = esort(AtlagArany);
    
    % Atalgot kimenet
    if ( minimumokArany(2) == minimumokArany(1)) 
       josoltAtlag = mean([Ar1(Arhely+1,:); Ar1(Arhely2+1,:)]); % akkor hozz� adunk a tal�lt holnaphoz
       NapPar = [NapPar; nap(nn,1), nap(Arhely+1,1), nap(Arhely2+1,1)];
    end
    if ( minimumokArany(2) == minimumokArany(2))  
        josoltAtlag = mean([Ar1(Brhely+1,:); Ar1(Brhely2+1,:)]); 
        NapPar = [NapPar; nap(nn,1), nap(Brhely+1,1), nap(Brhely2+1,1)];
    end
%     if ( minimumokArany(2) == minimumokArany(3))  
%        josoltAtlag = mean([Ar1(SKhely+1,:); Ar1(SKhely2+1,:)]); 
%        NapPar = [NapPar; nap(nn,1), nap(SKhely+1,1), nap(SKhely2+1,1)];
%     end
    
    kimenet2 = [kimenet2; josoltAtlag];
    H = mean(abs(josoltAtlag - Ar1(nn+1,:)));
    Hiba2 = [ Hiba2; H ];
    
    Sorszam = [Sorszam; nn];  
    
end

Statisztika = zeros(10,10);
Statisztika2 = zeros(10,10);
for ii = 1:size(NapPar,1)
        for kk = 1:3
            if (NapPar(ii, kk) == 13)
                NapPar(ii, kk) = 8;
            elseif (NapPar(ii, kk) == 15)
                NapPar(ii, kk) = 9;
            elseif (NapPar(ii, kk) == 17)
                NapPar(ii, kk) = 10;
            end
        end
    end
            
% for ii = 1:size(NapPar,1)
%         Statisztika(NapPar(ii,1), NapPar(ii,2)) = Statisztika(NapPar(ii,1), NapPar(ii,2)) + 1;
% end;
% for ii = 1:size(NapPar,1)
%         Statisztika2(NapPar(ii,1), NapPar(ii,3)) = Statisztika2(NapPar(ii,1), NapPar(ii,3)) + 1;
% end;

MAE = mean(abs(Ar1-kimenet2));
MM = mean(MAE);
display(MM);

kimenet_vector_2atlaga = reshape(kimenet2', hossz, 1);
display(mae(arak_without_nan(p*24:hossz,1), kimenet_vector_2atlaga(p*24:hossz,1)));
display(mse(arak_without_nan(p*24:hossz,1), kimenet_vector_2atlaga(p*24:hossz,1)));

abserror = abs(Ar1(p+1:hossz/24,1:24)-kimenet2(p+1:hossz/24,1:24));
sumabserror = sum(abserror,2);
ss = sum(sumabserror);
atlag = mean(abserror);
ae = reshape(abserror', 1, size(abserror,1)*size(abserror,2));
uj3 = kimenet_vector_2atlaga(p*24+1:hossz,1);
relerror = ae/uj3'*100;
display(relerror);