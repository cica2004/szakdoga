
hossz = size(arak_without_nan,1);
display(hossz);
Ar1=reshape(arak_without_nan, 24, hossz/24);             
Ar1=Ar1';
Br1=reshape(RendszerTerheles, 24, hossz/24);             
Br1=Br1';

nap=reshape(DayNumber, 24, hossz/24);             
nap=nap';

p=7;

kimenet4 = Ar1(1:p,:);     % Ezek a j�solt adatok
Hiba4 = zeros(p,1);
TalaltNap4 = zeros(p,1);
Sorszam4 = zeros(p,1); % Keresett nap helye az eredti Ar t�mben
NapPar4 = ones(p,4);

for nn = p : hossz/24 -1,
    % Ha mondjuk m�rc 5 az utols� ismert adat akkor, az fog a ma v�ltoz�ba
    % ker�lni
    % m�g a xxR nev� m�trixban az �vben m�rc 4 nn ismert adatok ker�lnek
    % az�rt mert ebben az esetben m�rc 5 h�z legink�bb "hasonl�t�" napot
    % keress�k, de nem szeretn�nk ha mag�t m�rc 5 meg tudn� tal�lni, mert
    % annak nem lenne �rtelme
    
    maAr = Ar1(nn,:);         % Utols� ismert adat
    ArR = Ar1(1:nn-1,:); 
    maBr = Br1(nn,:);
    BrR = Br1(1:nn-1,:);         % Br = Brutt� hazai �ram termel�s
    napR = nap(1:nn-1, :);   
    tegnap = Ar1(nn-1, :);
    
    Napok = [nap(nn)];

    % Megkeress�k a legkisebb hib�ju napot
    % Relat�v hib�t sz�molok az eddnn adatok �s az utols� ismert adat k�z�tt  
    tmpAr = abs(ArR - ones(nn-1,1)*maAr);
    [Arminimum, Arhely] = min(sum(tmpAr,2));      % Arhely helyen tal�lhat� a mai napra legjobban hasonl�t� Ar  
    tmpBr = abs(BrR - ones(nn-1,1)*maBr);
    [Brminimum, Brhely] = min(sum(tmpBr,2));
    
    m = [Arminimum, Brminimum];
    minimumok = esort(m);    % sorba rendezz�k a minimumokat
                             % a legkisebb ker�l a sorv�g�re
        % megn�zem hogy melyikn�l van a legkisebb hiba �s annak az ar-at veszem
    if ( minimumok(length(minimumok)) == Arminimum)  
        Atlagolandok = Ar1((Arhely+1),:);
        Napok = [Napok, nap(Arhely+1,1)];
    else  
        Atlagolandok = Ar1((Brhely+1),:);
        Napok = [Napok, nap(Brhely+1,1)];
    end
                          
    % Megkeresem a m�sodik leghasonl�bbat
    tmp2Ar = [tmpAr(1:Arhely-1,:); tmpAr(Arhely+1:nn-1,:)];
    [Arminimum2, Arhely2] = min(sum(tmp2Ar,2));
    tmp2Br = [tmpBr(1:Brhely-1,:); tmpBr(Brhely+1:nn-1,:)];
    [Brminimum2, Brhely2] = min(sum(tmp2Br,2));
    
    m2 = [Arminimum2, Brminimum2]; 
    minimumok2 = esort(m2);
    tmp2_hossz = size(tmp2Ar,1);
    
    if ( minimumok2(length(minimumok2)) == Arminimum2)  
        Atlagolandok = [Atlagolandok; Ar1((Arhely2+1),:)];
        Napok = [Napok, nap(Arhely2+1,1)];
    else
        Atlagolandok = [Atlagolandok; Ar1((Brhely2+1),:)];
        Napok = [Napok, nap(Brhely2+1,1)];
    end

    % Megkeresem a harmadik leghasonl�bbat
    tmp3Ar = [tmp2Ar(1:Arhely2-1,:); tmp2Ar(Arhely2+1:tmp2_hossz,:)];
    [Arminimum3, Arhely3] = min(sum(tmp3Ar,2));
    tmp3Ar = [tmpBr(1:Brhely2-1,:); tmpBr(Brhely2+1:tmp2_hossz,:)];
    [Brminimum3, Brhely3] = min(sum(tmp2Ar,2));
    
    m3 = [Arminimum3, Brminimum3];
    minimumok3 = esort(m3);
    tmp3_hossz = size(tmp2Ar,1);
    
    if ( minimumok3(length(minimumok3)) == Arminimum3)  
        Atlagolandok = [Atlagolandok; Ar1((Arhely3+1),:)];
        Napok = [Napok, nap(Arhely3+1,1)];
    else 
        Atlagolandok = [Atlagolandok; Ar1((Brhely3+1),:)];
        Napok = [Napok, nap(Brhely3+1,1)];
    end
    
   
    josoltAtlag = mean(Atlagolandok);
    NapPar4 = [NapPar4; Napok];
    kimenet4 = [kimenet4; josoltAtlag];
    H = mean(abs(josoltAtlag - Ar1(nn+1,:)));
    Hiba4 = [ Hiba4; H ];
    
    Sorszam4 = [Sorszam4; nn];  
    
end

Statisztika = zeros(10,10);
Statisztika2 = zeros(10,10);
Statisztika3 = zeros(10,10);
for ii = 1:size(NapPar4,1)
        for kk = 1:4
            if (NapPar4(ii, kk) == 13)
                NapPar4(ii, kk) = 8;
            elseif (NapPar4(ii, kk) == 15)
                NapPar4(ii, kk) = 9;
            elseif (NapPar4(ii, kk) == 17)
                NapPar4(ii, kk) = 10;
            end
        end
    end
            
for ii = 1:size(NapPar4,1)
        Statisztika(NapPar4(ii,1), NapPar4(ii,2)) = Statisztika(NapPar4(ii,1), NapPar4(ii,2)) + 1;
end;
for ii = 1:size(NapPar4,1)
        Statisztika2(NapPar4(ii,1), NapPar4(ii,3)) = Statisztika2(NapPar4(ii,1), NapPar4(ii,3)) + 1;
end;
for ii = 1:size(NapPar4,1)
        Statisztika3(NapPar4(ii,1), NapPar4(ii,4)) = Statisztika3(NapPar4(ii,1), NapPar4(ii,4)) + 1;
end;
Darab = [sum(TalaltNap4==1); sum(TalaltNap4==2); sum(TalaltNap4==3); ...
        sum(TalaltNap4==4); sum(TalaltNap4==5); sum(TalaltNap4==6); ...
        sum(TalaltNap4==7); sum(TalaltNap4==13); sum(TalaltNap4==15); ...
        sum(TalaltNap4==17)];

% MeanAbsoluteError = mae(Ar1, kimenet);
% display(MeanAbsoluteError);
MAE = mean(abs(Ar1-kimenet4));
MM = mean(MAE);
display(MM);

kimenet_vector_3atlaga = reshape(kimenet4', hossz, 1);
display(mae(arak_without_nan(p*24:hossz,1), kimenet_vector_3atlaga(p*24:hossz,1)));
display(mse(arak_without_nan(p*24:hossz,1), kimenet_vector_3atlaga(p*24:hossz,1)));

abserror = abs(Ar1(p+1:hossz/24,1:24)-kimenet4(p+1:hossz/24,1:24));
sumabserror = sum(abserror,2);
ss = sum(sumabserror);
atlag = mean(abserror);
uj3 = kimenet_vector_3atlaga(p*24+1:hossz,1);
relerror = ae/uj3'*100;
display(relerror);