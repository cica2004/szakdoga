% Nem teszek különbséget a hétvégék, hétköznapok és az ünnepek között.
% De viszont a három rendelkezésre álló adatban
% Régi ár, Bruttóhaza termelés, SK áramlás  keresek
% Mindháromban megkeresem az utolsó ismert napra legjobban  hasonlító adat
% helyét. És annak a helynek az értékeit írom a kimenetbe ami a legkisebb
% relatív hibát okozza.

%  clear all;
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

kimenet3 = Ar1(1:4,:);     % Ezek a jósolt adatok
Hiba3 = [0; 0; 0; 0];
TalaltNap = [nap(1,1); nap(2,1); nap(3,1); nap(4,1)];
Sorszam = [0;1;2;3]; % Keresett nap helye az eredti Ar tömben
NapPar = [nap(1,1), nap(1,1), nap(1,1), nap(1,1); ...
    nap(2,1), nap(2,1), nap(2,1), nap(2,1); ...
    nap(3,1), nap(3,1), nap(3,1), nap(3,1); ...
    nap(4,1), nap(4,1), nap(4,1), nap(4,1) ];
for nn=4:365,
    % Ha mondjuk márc 5 az utolsó ismert adat akkor, az fog a ma változóba
    % kerülni
    % míg a xxR nevû mátrixban az évben márc 4 nn ismert adatok kerülnek
    % azért mert ebben az esetben márc 5 höz leginkább "hasonlító" napot
    % keressük, de nem szeretnénk ha magát márc 5 meg tudná találni, mert
    % annak nem lenne értelme
    
    maAr = Ar1(nn,:);         % Utolsó ismert adat
    ArR = Ar1(1:nn-1,:); 
    maSK = SK1(nn,:);
    SKR = SK1(1:nn-1,:);        % SK = Szolvákia felöl érkezõ áram
    maBr = Br1(nn,:);
    BrR = Br1(1:nn-1,:);         % Br = Bruttó hazai áram termelés

    % Megkeressük a legkisebb hibáju napot
    % Relatív hibát számolok az eddnn adatok és az utolsó ismert adat között  
    tmpAr = abs(ArR - ones(nn-1,1)*maAr);
    [Arminimum, Arhely] = min(sum(tmpAr,2));      % Arhely helyen található a mai napra legjobban hasonlító Ar  
    tmpSK = abs(SKR - ones(nn-1,1)*maSK);
    [SKminimum, SKhely] = min(sum(tmpSK,2));  
    tmpBr = abs(BrR - ones(nn-1,1)*maBr);
    [Brminimum, Brhely] = min(sum(tmpBr,2));
    
    m = [Arminimum, Brminimum, SKminimum];
    minimumok = esort(m);    % sorba rendezzük a minimumokat
                             % a legkisebb kerül a sorvégére
    
    % Megkeresem a második leghasonlóbbat
    tmp2Ar = [tmpAr(1:Arhely-1,:); tmpAr(Arhely+1:nn-1,:)];
    [Arminimum2, Arhely2] = min(sum(tmp2Ar,2));
    tmp2SK = [tmpSK(1:SKhely-1,:); tmpSK(SKhely+1:nn-1,:)];
    [SKminimum2, SKhely2] = min(sum(tmp2SK,2));
    tmp2Br = [tmpBr(1:Brhely-1,:); tmpBr(Brhely+1:nn-1,:)];
    [Brminimum2, Brhely2] = min(sum(tmp2Br,2));
    
    m2 = [Arminimum2, Brminimum2, SKminimum2];  
    hossz = size(tmp2Ar,1);

    % Megkeresem a harmadik leghasonlóbbat
    tmp3Ar = [tmp2Ar(1:Arhely2-1,:); tmp2Ar(Arhely2+1:hossz,:)];
    [Arminimum3, Arhely3] = min(sum(tmp3Ar,2));
    tmp3SK = [tmp2SK(1:SKhely2-1,:); tmp2SK(SKhely2+1:hossz,:)];
    [SKminimum3, SKhely3] = min(sum(tmp3Ar,2));
    tmp3Ar = [tmpBr(1:Brhely2-1,:); tmpBr(Brhely2+1:hossz,:)];
    [Brminimum3, Brhely3] = min(sum(tmp2Ar,2));
    
    m3 = [Arminimum3, Brminimum3, SKminimum3];
    
    AtlagArany = m + m2 + m3;
    minimumokArany = esort(AtlagArany);
    
    if ( minimumokArany(2) == AtlagArany(1)) 
       josoltAtlag = mean([Ar1(Arhely+1,:); Ar1(Arhely2+1,:); Ar1(Arhely3+1,:)]); % akkor hozzá adunk a talált holnaphoz 
%        if(Arhely2>Arhely)
%            Arhely2 = Arhely2 + 1;
%        elseif(Arhely3>Arhely)
%            Arhely3 = Arhely3 + 1;
%        elseif(Arhely3>Arhely2)
%            Arhely3 = Arhely3 + 1;
%        end;
       NapPar = [NapPar; nap(nn), nap(Arhely+1,1), nap(Arhely2+1,1), nap(Arhely3+1,1) ];
    end
    if ( minimumokArany(2) == AtlagArany(2))  
        josoltAtlag = mean([Ar1(Brhely+1,:); Ar1(Brhely2+1,:); Ar1(Brhely3+1,:)]); 
%         if(Brhely2>Arhely)
%            Brhely2 = Brhely2 + 1;
%        elseif(Brhely3>Brhely)
%            Brhely3 = Brhely3 + 1;
%        elseif(Brhely3>Brhely2)
%            Brhely3 = Brhely3 + 1;
%        end;
        NapPar = [NapPar; nap(nn), nap(Brhely+1,1), nap(Brhely2+1,1), nap(Brhely3+1,1) ];
    end
    if ( minimumokArany(2) == AtlagArany(3))  
       josoltAtlag = mean([Ar1(SKhely+1,:); Ar1(SKhely2+1,:); Ar1(SKhely3+1,:)]);  
       NapPar = [NapPar; nap(nn), nap(SKhely+1,1), nap(SKhely2+1,1), nap(SKhely3+1,1) ];
    end
    
    kimenet3 = [kimenet3; josoltAtlag];
    H = mean(abs(josoltAtlag - Ar1(nn+1,:)));
    Hiba3 = [ Hiba3; H ];
    
    
    Sorszam = [Sorszam; nn];  
    
end

Statisztika = zeros(10,10);
Statisztika2 = zeros(10,10);
Statisztika3 = zeros(10,10);
for ii = 1:size(NapPar,1)
        for kk = 1:4
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
for ii = 1:size(NapPar,1)
        Statisztika3(NapPar(ii,1), NapPar(ii,4)) = Statisztika3(NapPar(ii,1), NapPar(ii,4)) + 1;
end;
Darab = [sum(TalaltNap==1); sum(TalaltNap==2); sum(TalaltNap==3); ...
        sum(TalaltNap==4); sum(TalaltNap==5); sum(TalaltNap==6); ...
        sum(TalaltNap==7); sum(TalaltNap==13); sum(TalaltNap==15); ...
        sum(TalaltNap==17)];

% MeanAbsoluteError = mae(Ar1, kimenet);
% display(MeanAbsoluteError);
MAE = mean(abs(Ar1-kimenet3));
MM = mean(MAE);
display(MM);