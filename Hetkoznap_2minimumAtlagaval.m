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

kimenet2 = HetkoznapiAr(1:3,:);     % Ezek a jósolt adatok
Hiba2 = mean(abs(HetkoznapiAr(1,:)-HetkoznapiAr(1,:)));
Hiba2 =[Hiba2; mean(abs(HetkoznapiAr(2,:)-HetkoznapiAr(2,:)))];
Hiba2 =[Hiba2; mean(abs(HetkoznapiAr(3,:)-HetkoznapiAr(3,:)))];
TalaltNap = [Hetkoznap(1,1); Hetkoznap(2,1); Hetkoznap(3,1)];
Sorszam = [0;1;2]; % Keresett nap helye az eredti Ar tömben
NapPar = [Hetkoznap(1,1), Hetkoznap(1,1), Hetkoznap(1,1); ...
    Hetkoznap(2,1), Hetkoznap(2,1), Hetkoznap(2,1); ...
    Hetkoznap(3,1), Hetkoznap(3,1), Hetkoznap(3,1)];

hossz = size(HetkoznapiAr,1);
for nn=3:hossz - 1,
    % Ha mondjuk márc 5 az utolsó ismert adat akkor, az fog a ma változóba
    % kerülni
    % míg a xxR nevû mátrixban az évben márc 4 nn ismert adatok kerülnek
    % azért mert ebben az esetben márc 5 höz leginkább "hasonlító" napot
    % keressük, de nem szeretnénk ha magát márc 5 meg tudná találni, mert
    % annak nem lenne értelme
    
    maAr = HetkoznapiAr(nn,:);         % Utolsó ismert adat
    ArR = HetkoznapiAr(1:nn-1,:); 
    maSK = HetkoznapiSK(nn,:);
    SKR = HetkoznapiSK(1:nn-1,:);        % SK = Szolvákia felöl érkezõ áram
    maBr = HetkoznapiBr(nn,:);
    BrR = HetkoznapiBr(1:nn-1,:);         % Br = Bruttó hazai áram termelés

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
       josoltAtlag = mean([HetkoznapiAr(Arhely+1,:); HetkoznapiAr(Arhely2+1,:)]); % akkor hozzá adunk a talált holnaphoz 
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