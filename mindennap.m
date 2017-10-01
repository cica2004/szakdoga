% Nem teszek k�l�nbs�get a h�tv�g�k, h�tk�znapok �s az �nnepek k�z�tt.
% De viszont a h�rom rendelkez�sre �ll� adatban
% R�gi �r, Brutt�haza termel�s, SK �raml�s  keresek
% Mindh�romban megkeresem az utols� ismert napra legjobban  hasonl�t� adat
% hely�t. �s annak a helynek az �rt�keit �rom a kimenetbe ami a legkisebb
% relat�v hib�t okozza.

 clear all;
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

kimenet = Ar1(1:2,:);     % Ezek a j�solt adatok
Hiba = [0; 0];
TalaltNap = [nap(1,1); nap(2,1)];
Sorszam = [0;1]; % Keresett nap helye az eredti Ar t�mben
NapPar = [nap(1,1), nap(1,1); nap(2,1), nap(2,1)];
for nn=2:365,
    % Ha mondjuk m�rc 5 az utols� ismert adat akkor, az fog a ma v�ltoz�ba
    % ker�lni
    % m�g a xxR nev� m�trixban az �vben m�rc 4 ig ismert adatok ker�lnek
    % az�rt mert ebben az esetben m�rc 5 h�z legink�bb "hasonl�t�" napot
    % keress�k, de nem szeretn�nk ha mag�t m�rc 5 meg tudn� tal�lni, mert
    % annak nem lenne �rtelme
    ma = SK1(nn,:);         % Utols� ismert adat
    SKR = SK1(1:nn-1,:);  
    tmp = abs(SKR - ones(nn-1,1)*ma);   % az eddigi adatok �s az utols� ismert nap k�l�nbs�g�t veszem
    [SKminimum, SKhely] = min(sum(tmp,2));  % megn�zz�k hogy hol milyen �rt�kkel tal�lhat� a legkisebb
    % �gy most az SKhely-en lesz az a nap ami a legkisebb hib�t produk�lja
    % az utols� ismert nappunkkal
    % SKminimum pedig lesz a hiba nagys�ga
        
    % Most a brutto hazai rendszer terehel�sben fogok keresni
    ma = Br1(nn,:);
    BrR = Br1(1:nn-1,:);    
    tmp = abs(BrR - ones(nn-1,1)*ma);
    [Brminimum, Brhely] = min(sum(tmp,2));  
    
    ma = Ar1(nn,:);         % Utols� ismert adat
    ArR = Ar1(1:nn-1,:);                        % Az eddigi j� adatok, a mai nap ( utols� ismeret nap ) kiv�tel�vel
    tmp = abs(ArR - ones(nn-1,1)*ma);
    [Arminimum, Arhely] = min(sum(tmp,2));      % Arhely helyen tal�lhat� a mai napra legjobban hasonl�t� Ar  
    
    % Minden bemeneti t�mben Ar, Bruttotermeles, SK�raml�s megkerestem a
    % mainaphoz legjobban hasonl�t�t
    % kiv�lasztom a h�rom k�z�l azt ami legkisebb hib�t eredm�nyezi
    % �s a hozz�tartoz� hely ut�nni ( hely + 1 ) napot teszem a kimenetre.
    m = [Arminimum, Brminimum, SKminimum];
    minimumok = esort(m);       % sorba rendezz�k a minimumokat
                                % a legkisebb ker�l a sorv�g�re.
    
    % megn�zem hogy melyikn�l van a legkisebb hiba
    if ( minimumok(2) == Arminimum )  
        kimenet = [kimenet; Ar1((Arhely+1),:)];
        H = mean(abs(Ar1(Arhely+1,:) - Ar1(nn+1,:)));
        Hiba = [ Hiba; H ];
        TalaltNap = [TalaltNap;nap(Arhely+1,1)];    % Megtal�lt nap helye az Ar t�mben
        NapPar = [NapPar; nap(Arhley+1,1), nap(nn)]; % Tal�ltnap
    end
    
    if ( minimumok(2) == Brminimum )  
        kimenet = [kimenet; Ar1((Brhely+1),:)];
        H = mean(abs(Ar1(Brhely+1,:) - Ar1(nn+1,:)));
        Hiba = [ Hiba; H ];
        TalaltNap = [TalaltNap;nap(Brhely+1,1)];
        NapPar = [NapPar; nap(Brhely+1,1), nap(nn)];
    end
    
    if ( minimumok(2) == SKminimum )  
        kimenet = [kimenet; Ar1((SKhely+1),:)];
        H = mean(abs(Ar1(SKhely+1,:) - Ar1(nn+1,:)));
        Hiba = [ Hiba; H ];    
        TalaltNap = [TalaltNap;nap(SKhely+1,1)];
        NapPar = [NapPar; nap(SKhely+1,1), nap(nn)];
    end
    Sorszam = [Sorszam; nn];
end

Statisztika = zeros(10,10);
for ii = 1:size(NapPar,1)
        for kk = 1:2
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
Darab = [sum(TalaltNap==1); sum(TalaltNap==2); sum(TalaltNap==3); ...
        sum(TalaltNap==4); sum(TalaltNap==5); sum(TalaltNap==6); ...
        sum(TalaltNap==7); sum(TalaltNap==13); sum(TalaltNap==15); ...
        sum(TalaltNap==17)];

% MeanAbsoluteError = mae(Ar1, kimenet);
% display(MeanAbsoluteError);
MAE = mean(abs(Ar1-kimenet));
MM = mean(MAE);
display(MM);