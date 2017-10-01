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

HetkoznapiAr = Ar1(2,:);
HetkoznapiBr = Br1(2,:);
HetkoznapiSK = SK1(2,:);
Hetkoznap = nap(2,1);
Sorszam = 2;
for nn = 3:366,
    if ( nap(nn,1) < 6 )
        HetkoznapiAr = [HetkoznapiAr; Ar1(nn,:)];
        HetkoznapiBr = [HetkoznapiBr; Br1(nn,:)];
        HetkoznapiSK = [HetkoznapiSK; SK1(nn,:)];
        Hetkoznap = [Hetkoznap; nap(nn,1)];
        Sorszam = [Sorszam; nn];
    end        
end;

kimenet2 = HetkoznapiAr(1:3,:);     % Ezek a j�solt adatok
Hiba2 = mean(abs(HetkoznapiAr(1,:)-HetkoznapiAr(1,:)));
Hiba2 =[Hiba2; mean(abs(HetkoznapiAr(2,:)-HetkoznapiAr(2,:)))];
Hiba2 =[Hiba2; mean(abs(HetkoznapiAr(3,:)-HetkoznapiAr(3,:)))];
TalaltNap = [Hetkoznap(1,1); Hetkoznap(2,1); Hetkoznap(3,1)];
Sorszam = [0;1;2]; % Keresett nap helye az eredti Ar t�mben
NapPar = [Hetkoznap(1,1), Hetkoznap(1,1), Hetkoznap(1,1); ...
    Hetkoznap(2,1), Hetkoznap(2,1), Hetkoznap(2,1); ...
    Hetkoznap(3,1), Hetkoznap(3,1), Hetkoznap(3,1)];

hossz = size(HetkoznapiAr,1);
for nn=3:hossz - 1,
    % Ha mondjuk m�rc 5 az utols� ismert adat akkor, az fog a ma v�ltoz�ba
    % ker�lni
    % m�g a xxR nev� m�trixban az �vben m�rc 4 nn ismert adatok ker�lnek
    % az�rt mert ebben az esetben m�rc 5 h�z legink�bb "hasonl�t�" napot
    % keress�k, de nem szeretn�nk ha mag�t m�rc 5 meg tudn� tal�lni, mert
    % annak nem lenne �rtelme
    
    maAr = HetkoznapiAr(nn,:);         % Utols� ismert adat
    ArR = HetkoznapiAr(1:nn-1,:); 
    maSK = HetkoznapiSK(nn,:);
    SKR = HetkoznapiSK(1:nn-1,:);        % SK = Szolv�kia fel�l �rkez� �ram
    maBr = HetkoznapiBr(nn,:);
    BrR = HetkoznapiBr(1:nn-1,:);         % Br = Brutt� hazai �ram termel�s

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
       josoltAtlag = mean([HetkoznapiAr(Arhely+1,:); HetkoznapiAr(Arhely2+1,:)]); % akkor hozz� adunk a tal�lt holnaphoz 
       NapPar = [NapPar; Hetkoznap(nn), Hetkoznap(Arhely+1,1), nap(Arhely2+1,1)];
    end
    if ( minimumokArany(2) == minimumokArany(2))  
        josoltAtlag = mean([HetkoznapiAr(Brhely+1,:); HetkoznapiAr(Brhely2+1,:)]);
        NapPar = [NapPar; Hetkoznap(nn), Hetkoznap(Brhely+1,1), Hetkoznap(Brhely2+1,1)];
    end
    if ( minimumokArany(2) == minimumokArany(3))  
       josoltAtlag = mean([HetkoznapiAr(SKhely+1,:); HetkoznapiAr(SKhely2+1,:)]); 
       NapPar = [NapPar; Hetkoznap(nn), Hetkoznap(SKhely+1,1), Hetkoznap(SKhely2+1,1)];
    end
    
    kimenet2 = [kimenet2; josoltAtlag];
    H = mean(abs(josoltAtlag - HetkoznapiAr(nn+1,:)));
    Hiba2 = [ Hiba2; H ]; 
    
    Sorszam = [Sorszam; nn];  
    
end

Statisztika = zeros(5,5);
Statisztika2 = zeros(5,5);
for ii = 1:size(NapPar,1)
        Statisztika(NapPar(ii,1), NapPar(ii,2)) = Statisztika(NapPar(ii,1), NapPar(ii,2)) + 1;
end;
for ii = 1:size(NapPar,1)
        Statisztika2(NapPar(ii,1), NapPar(ii,3)) = Statisztika2(NapPar(ii,1), NapPar(ii,3)) + 1;
end;
Darab = [sum(TalaltNap==1); sum(TalaltNap==2); sum(TalaltNap==3); ...
        sum(TalaltNap==4); sum(TalaltNap==5)];

% MeanAbsoluteError = mae(Ar1, kimenet);
% display(MeanAbsoluteError);
MAE = mean(abs(HetkoznapiAr-kimenet2));
MM = mean(MAE);
display(MM);