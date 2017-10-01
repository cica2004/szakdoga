% Nem teszek k�l�nbs�get a h�tv�g�k, h�tk�znapok �s az �nnepek k�z�tt.
% De viszont a h�rom rendelkez�sre �ll� adatban
% R�gi �r, Brutt�haza termel�s, SK �raml�s  keresek
% Mindh�romban megkeresem az utols� ismert napra legjobban  hasonl�t� adat
% hely�t. �s annak a helynek az �rt�keit �rom a kimenetbe ami a legkisebb
% relat�v hib�t okozza.

%  clear all;
load('2012_bemet+kimenet.mat');
% Az adatokat napi bont�sban szeretn�m vizsg�lni
% �gy minden adatot egy 24 oszlopb�l �ll� m�trixba teszek
Ar1=reshape(Av2012,24,366); % A reshape m�k�d�se miatt els�nek a 24 hossz� sorokat k�sz�tek
                            % az�rt lesz 366 a m�sik param�ter mert 2012
                            % sz�k��v
                            % size(Av2012, 1) / 24 = 366
Ar1=Ar1';           % Az Av2012 j� �rakat tartalmazza, elv�rt kimenetet
Br1=reshape(Br,24,366);             % Br = Brutt� hazai �ram termel�s
Br1=Br1';
SK1=reshape(SK,24,366);             % SK = Szolv�kia fel�l �tfoly� �ram
SK1=SK1';
nap=reshape(napok,24,366);          % K�sz�tettem egy napok vectort amiben
                                    % az aktu�lis naphoz tartoz� �rt�k azt
                                    % mutatja meg hogy milyen fajta nap
                                    % 1=h�tf�, 2=kedd ... 7=vas�rnap
                                    % Az �nnepnapok= 
                                    % szombatimunkanap=
                                    % pluszszabadnap=
nap=nap';

kimenet2 = Ar1(1:3,:);     % Ezek a j�solt adatok
Hiba2 = mean(abs(Ar1(1,:) - Ar1(1,:)));
Hiba2 =[Hiba2; mean(abs(Ar1(2,:) - Ar1(2,:)))];
Hiba2 =[Hiba2; mean(abs(Ar1(3,:) - Ar1(3,:)))];
TalaltNap = [nap(1,1); nap(2,1); nap(3,1)];
Sorszam = [0;1;2]; % Keresett nap helye az eredti Ar t�mben
NapPar = [nap(1,1), nap(1,1), nap(1,1); nap(2,1), nap(2,1), nap(2,1); nap(3,1), nap(3,1), nap(3,1)];
for nn=3:365,
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

    % Megkeress�k a legkisebb hib�ju napot
    % Relat�v hib�t sz�molok az eddnn adatok �s az utols� ismert adat k�z�tt  
    tmpAr = abs(ArR - ones(nn-1,1)*maAr);
    [Arminimum, Arhely] = min(sum(tmpAr,2));      % Arhely helyen tal�lhat� a mai napra legjobban hasonl�t� Ar  
    tmpSK = abs(SKR - ones(nn-1,1)*maSK);
    [SKminimum, SKhely] = min(sum(tmpSK,2));  
    tmpBr = abs(BrR - ones(nn-1,1)*maBr);
    [Brminimum, Brhely] = min(sum(tmpBr,2));
    
    m = [Arminimum, Brminimum, SKminimum];
    minimumok = esort(m);    % sorba rendezz�k a minimumokat
                             % a legkisebb ker�l a sorv�g�re
    
    % Megkeresem a m�sodik leghasonl�bbat
    tmp2 = [tmpAr(1:Arhely-1,:);tmpAr(Arhely+1:nn-1,:)];
    [Arminimum2, Arhely2] = min(sum(tmp2,2));
    tmp2 = [tmpSK(1:SKhely-1,:);tmpSK(SKhely+1:nn-1,:)];
    [SKminimum2, SKhely2] = min(sum(tmp2,2));
    tmp2 = [tmpBr(1:Brhely-1,:);tmpBr(Brhely+1:nn-1,:)];
    [Brminimum2, Brhely2] = min(sum(tmp2,2));
    
    m2 = [Arminimum2, Brminimum2, SKminimum2];
    AtlagArany = m + m2;
    minimumokArany = esort(AtlagArany);
    
    % Atalgot kimenet
    if ( minimumokArany(2) == minimumokArany(1)) 
       josoltAtlag = mean([Ar1(Arhely+1,:); Ar1(Arhely2+1,:)]); % akkor hozz� adunk a tal�lt holnaphoz
       NapPar = [NapPar; nap(nn), nap(Arhely+1,1), nap(Arhely2+1,1)];
    end
    if ( minimumokArany(2) == minimumokArany(2))  
        josoltAtlag = mean([Ar1(Brhely+1,:); Ar1(Brhely2+1,:)]); 
        NapPar = [NapPar; nap(nn), nap(Brhely+1,1), nap(Brhely2+1,1)];
    end
    if ( minimumokArany(2) == minimumokArany(3))  
       josoltAtlag = mean([Ar1(SKhely+1,:); Ar1(SKhely2+1,:)]); 
       NapPar = [NapPar; nap(nn), nap(SKhely+1,1), nap(SKhely2+1,1)];
    end
    
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
            
for ii = 1:size(NapPar,1)
        Statisztika(NapPar(ii,1), NapPar(ii,2)) = Statisztika(NapPar(ii,1), NapPar(ii,2)) + 1;
end;
for ii = 1:size(NapPar,1)
        Statisztika2(NapPar(ii,1), NapPar(ii,3)) = Statisztika2(NapPar(ii,1), NapPar(ii,3)) + 1;
end;
Darab = [sum(TalaltNap==1); sum(TalaltNap==2); sum(TalaltNap==3); ...
        sum(TalaltNap==4); sum(TalaltNap==5); sum(TalaltNap==6); ...
        sum(TalaltNap==7); sum(TalaltNap==13); sum(TalaltNap==15); ...
        sum(TalaltNap==17)];

% MeanAbsoluteError = mae(Ar1, kimenet);
% display(MeanAbsoluteError);
MAE = mean(abs(Ar1-kimenet2));
MM = mean(MAE);
display(MM);