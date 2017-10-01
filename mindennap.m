% Nem teszek különbséget a hétvégék, hétköznapok és az ünnepek között.
% De viszont a három rendelkezésre álló adatban
% Régi ár, Bruttóhaza termelés, SK áramlás  keresek
% Mindháromban megkeresem az utolsó ismert napra legjobban  hasonlító adat
% helyét. És annak a helynek az értékeit írom a kimenetbe ami a legkisebb
% relatív hibát okozza.

 clear all;
load('2012_bemet+kimenet.mat');
% Az adatokat napi bontásban szeretném vizsgálni
% így minden adatot egy 24 oszlopból álló mátrixba teszek
Ar1=reshape(Av2012,24,366); % A reshape mûködése miatt elsõnek a 24 hosszú sorokat készítek
                            % azért lesz 366 a másik paraméter mert 2012
                            % szökõév
                            % size(Av2012, 1) / 24 = 366
Ar1=Ar1';           % Az Av2012 jó árakat tartalmazza, elvárt kimenetet
Br1=reshape(Br,24,366);             % Br = Bruttó hazai áram termelés
Br1=Br1';
SK1=reshape(SK,24,366);             % SK = Szolvákia felöl átfolyó áram
SK1=SK1';
nap=reshape(napok,24,366);          % Készítettem egy napok vectort amiben
                                    % az aktuális naphoz tartozó érték azt
                                    % mutatja meg hogy milyen fajta nap
                                    % 1=hétfõ, 2=kedd ... 7=vasárnap
                                    % Az ünnepnapok= 
                                    % szombatimunkanap=
                                    % pluszszabadnap=
nap=nap';

kimenet = Ar1(1:2,:);     % Ezek a jósolt adatok
Hiba = [0; 0];
TalaltNap = [nap(1,1); nap(2,1)];
Sorszam = [0;1]; % Keresett nap helye az eredti Ar tömben
NapPar = [nap(1,1), nap(1,1); nap(2,1), nap(2,1)];
for nn=2:365,
    % Ha mondjuk márc 5 az utolsó ismert adat akkor, az fog a ma változóba
    % kerülni
    % míg a xxR nevû mátrixban az évben márc 4 ig ismert adatok kerülnek
    % azért mert ebben az esetben márc 5 höz leginkább "hasonlító" napot
    % keressük, de nem szeretnénk ha magát márc 5 meg tudná találni, mert
    % annak nem lenne értelme
    ma = SK1(nn,:);         % Utolsó ismert adat
    SKR = SK1(1:nn-1,:);  
    tmp = abs(SKR - ones(nn-1,1)*ma);   % az eddigi adatok és az utolsó ismert nap különbségét veszem
    [SKminimum, SKhely] = min(sum(tmp,2));  % megnézzük hogy hol milyen értékkel található a legkisebb
    % így most az SKhely-en lesz az a nap ami a legkisebb hibát produkálja
    % az utolsó ismert nappunkkal
    % SKminimum pedig lesz a hiba nagysága
        
    % Most a brutto hazai rendszer terehelésben fogok keresni
    ma = Br1(nn,:);
    BrR = Br1(1:nn-1,:);    
    tmp = abs(BrR - ones(nn-1,1)*ma);
    [Brminimum, Brhely] = min(sum(tmp,2));  
    
    ma = Ar1(nn,:);         % Utolsó ismert adat
    ArR = Ar1(1:nn-1,:);                        % Az eddigi jó adatok, a mai nap ( utolsó ismeret nap ) kivételével
    tmp = abs(ArR - ones(nn-1,1)*ma);
    [Arminimum, Arhely] = min(sum(tmp,2));      % Arhely helyen található a mai napra legjobban hasonlító Ar  
    
    % Minden bemeneti tömben Ar, Bruttotermeles, SKáramlás megkerestem a
    % mainaphoz legjobban hasonlítót
    % kiválasztom a három közül azt ami legkisebb hibát eredményezi
    % és a hozzátartozó hely utánni ( hely + 1 ) napot teszem a kimenetre.
    m = [Arminimum, Brminimum, SKminimum];
    minimumok = esort(m);       % sorba rendezzük a minimumokat
                                % a legkisebb kerül a sorvégére.
    
    % megnézem hogy melyiknél van a legkisebb hiba
    if ( minimumok(2) == Arminimum )  
        kimenet = [kimenet; Ar1((Arhely+1),:)];
        H = mean(abs(Ar1(Arhely+1,:) - Ar1(nn+1,:)));
        Hiba = [ Hiba; H ];
        TalaltNap = [TalaltNap;nap(Arhely+1,1)];    % Megtalált nap helye az Ar tömben
        NapPar = [NapPar; nap(Arhley+1,1), nap(nn)]; % Találtnap
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