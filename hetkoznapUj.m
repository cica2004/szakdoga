% Csak a hétköznapi munkanapokat veszem figyelembe. (Hétfõtõl - péntekig)
% Az ünnepnapok, áthelyezett munkanapok, plusz szabadságok és szabad és
% pihenõ napokat nem vesszük figyelembe ha viszonyítási adatunk normál
% hétköznapra esik.

 clear all;
load('2012_bemet+kimenet.mat');
Ar1=reshape(Av2012,24,366);             
Ar1=Ar1';
Br1=reshape(Br,24,366);             
Br1=Br1';
SK1=reshape(SK,24,366);             
SK1=SK1';
nap=reshape(napok,24,366);             
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
hossz = length(HetkoznapiAr);

TalaltNap = [Hetkoznap(1); Hetkoznap(2)];
NapPar = [Hetkoznap(1), Hetkoznap(1); Hetkoznap(2), Hetkoznap(2)];
Hiba = [0;0];
kimenet = HetkoznapiAr(1:2,:);     % Ezek a jósolt adatok
for nn=2:hossz-1,

    ma = HetkoznapiSK(nn,:);
    SKR = HetkoznapiSK(1:nn-1,:);  
    tmp = abs(SKR - ones(nn-1,1)*ma);
    [SKminimum, SKhely] = min(sum(tmp,2));  % Legkisebb összes hiba
    
    ma = HetkoznapiBr(nn,:);
    BrR = HetkoznapiBr(1:nn-1,:);   
    tmp = abs(BrR - ones(nn-1,1)*ma);
    [Brminimum, Brhely] = min(sum(tmp,2));  
    
    ma = HetkoznapiAr(nn,:);         % Utolsó ismert adat
    ArR = HetkoznapiAr(1:nn-1,:);    % Az eddigi jó adatok, a mai nap ( utolsó ismeret nap ) kivételével
    tmp = abs(ArR - ones(nn-1,1)*ma);
    [Arminimum, Arhely] = min(sum(tmp,2));      % Arhely helyen található a mai napra legjobban hasonlító Ar  
    
    m = [Arminimum, Brminimum, SKminimum];
    minimumok = esort(m); 
    
    m = [Arminimum, Brminimum, SKminimum];
    minimumok = esort(m);
    
    if ( minimumok(2) == Arminimum)  
        uj2 = [kimenet; HetkoznapiAr((Arhely+1),:)];
        kimenet = uj2;
        H = mean(abs(HetkoznapiAr(Arhely+1,:) - HetkoznapiAr(nn+1,:)));
        Hiba = [ Hiba; H ];
        TalaltNap = [TalaltNap; Hetkoznap(Arhely+1)];
        NapPar = [NapPar; Hetkoznap(nn), Hetkoznap(Arhely+1) ];
    end
    
    if ( minimumok(2) == Brminimum)  
        uj2 = [kimenet; HetkoznapiAr((Brhely+1),:)];
        kimenet = uj2;
        H = mean(abs(HetkoznapiAr(Brhely+1,:) - HetkoznapiAr(nn+1,:)));
        Hiba = [ Hiba; H ];
        TalaltNap = [TalaltNap; Hetkoznap(Brhely+1)];
        NapPar = [NapPar; Hetkoznap(nn), Hetkoznap(Brhely+1) ];
    end
    
    if ( minimumok(2) == SKminimum)  
        uj2 = [kimenet; HetkoznapiAr((SKhely+1),:)];
        kimenet = uj2;
        H = mean(abs(HetkoznapiAr(SKhely+1,:) - HetkoznapiAr(nn+1,:)));
        Hiba = [ Hiba; H ];
        TalaltNap = [TalaltNap; Hetkoznap(SKhely+1)];
        NapPar = [NapPar; Hetkoznap(nn), Hetkoznap(SKhely+1)];
    end
end

% NapokStasztika(TalaltNap, Sorszam);
Statisztika = zeros(5,5);
for ii = 1:size(NapPar,1)
        Statisztika(NapPar(ii,1), NapPar(ii,2)) = Statisztika(NapPar(ii,1), NapPar(ii,2)) + 1;
end;
Darab = [sum(TalaltNap==1); sum(TalaltNap==2); sum(TalaltNap==3); ...
        sum(TalaltNap==4); sum(TalaltNap==5)];
        

% MeanAbsoluteError = mae(HetkoznapiAr, kimenet);
% display(MeanAbsoluteError);
MAE = mean(abs(HetkoznapiAr-kimenet));
MM = mean(MAE);
display(MM);
% RMSE=mean(sqrt(mean((HetkoznapiAr-kimenet).^2)));
% display(RMSE);