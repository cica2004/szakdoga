
hossz = size(arak_without_nan,1);
Ar1=reshape(arak_without_nan, 24, hossz/24);             
Ar1=Ar1';
ellenorzes = reshape(Ar1', hossz, 1);
Br1=reshape(RendszerTerheles, 24, hossz/24);             
Br1=Br1';
% SK1=reshape(HUSKmeres_without_nan, 24, hossz/24);             
% SK1=SK1';
% UK1=reshape(HUUKmeres_without_nan, 24, hossz/24);             
% UK1=UK1';
% AT1=reshape(HUATmeres_without_nan, 24, hossz/24);             
% AT1=AT1';
% RO1=reshape(HUROmeres_without_nan, 24, hossz/24);             
% RO1=RO1';
% RS1=reshape(HURSmeres_without_nan, 24, hossz/24);             
% RS1=RS1';
% HR1=reshape(HUHRmeres_without_nan, 24, hossz/24);             
% HR1=HR1';
IE1=reshape(ImportExportTeny_without_Nan, 24, hossz/24);             
IE1=IE1';
nap=reshape(DayNumber, 24, hossz/24);             
nap=nap';

%AM = random('Normal',0,1,24,366);
%AM = AM';
% display(hossz/24)

p=7;

ez_alapjan_dontott = repmat('er',[p,1]);
kimenet = Ar1(1:p, :);     % Ezek a jósolt adatok
for nn = p : hossz/24 -1,
    BrR = Br1(1:nn, :);
%     SKR = SK1(1:nn, :);
%     UKR = UK1(1:nn, :);
%     ATR = AT1(1:nn, :);
%     ROR = RO1(1:nn, :);
%     RSR = RS1(1:nn, :);
%     HRR = HR1(1:nn, :);
    IER = IE1(1:nn, :);
    napR = nap(1:nn, :);   
    tegnap = Ar1(nn,:);
    
    Arminimum = sum(abs(tegnap));
    Arhely = 1;
    for kk=1:nn-1,
        tmp = sum(abs(tegnap - Ar1(kk,:)));
            if (tmp < Arminimum)
                Arminimum = tmp;
                Arhely = kk;
            end
    end
    
    Brminimum = sum(abs(BrR(nn)));
    Brhely = 1;
    for kk=1:nn-1,
        tmp = sum(abs(BrR(nn,:) - BrR(kk,:)));
            if (tmp < Brminimum)
                Brminimum = tmp;
                Brhely = kk;
            end
    end
    
    IEminimum = sum(abs(IER(nn)));
    IEhely = 1;
    for kk=1:nn-1,
        tmp = sum(abs(IER(nn,:) - IER(kk,:)));
            if (tmp < IEminimum)
                IEminimum = tmp;
                IEhely = kk;
            end
    end

    
%     SKminimum = sum(abs(SKR(nn)));
%     SKhely = 1;
%     for kk=1:nn-1,
%         tmp = sum(abs(SKR(nn,:) - SKR(kk,:)));
%             if (tmp < SKminimum)
%                 SKminimum = tmp;
%                 SKhely = kk;
%             end
%     end

%     UKminimum = sum(abs(UKR(nn)));
%     UKhely = 1;
%     for kk=1:nn-1,
%         tmp = sum(abs(UKR(nn,:) - UKR(kk,:)));
%             if (tmp < UKminimum)
%                 UKminimum = tmp;
%                 UKhely = kk;
%             end
%     end

%     ATminimum = sum(abs(ATR(nn)));
%     AThely = 1;
%     for kk=1:nn-1,
%         tmp = sum(abs(ATR(nn,:) - ATR(kk,:)));
%             if (tmp < ATminimum)
%                 ATminimum = tmp;
%                 AThely = kk;
%             end
%     end

%     ROminimum = sum(abs(ROR(nn)));
%     ROhely = 1;
%     for kk=1:nn-1,
%         tmp = sum(abs(ROR(nn,:) - ROR(kk,:)));
%             if (tmp < ROminimum)
%                 ROminimum = tmp;
%                 ROhely = kk;
%             end
%     end
    
%     RSminimum = sum(abs(RSR(nn)));
%     RShely = 1;
%     for kk=1:nn-1,
%         tmp = sum(abs(RSR(nn,:) - RSR(kk,:)));
%             if (tmp < RSminimum)
%                 RSminimum = tmp;
%                 RShely = kk;
%             end
%     end

%     HRminimum = sum(abs(HRR(nn)));
%     HRhely = 1;
%     for kk=1:nn-1,
%         tmp = sum(abs(HRR(nn,:) - HRR(kk,:)));
%             if (tmp < HRminimum)
%                 HRminimum = tmp;
%                 HRhely = kk;
%             end
%     end

    m = [Arminimum, IEminimum, Brminimum];
    %display(length(minimumok));
    minimumok = esort(m);
    
    % megnézem hogy melyiknél van a legkisebb hiba és annak az ar-at veszem
    if ( minimumok(length(minimumok)) == Arminimum)  
        uj2 = [kimenet; Ar1((Arhely+1),:)];
        kimenet = uj2;
        d = repmat('ar',[1,1]);
        d_uj = [ez_alapjan_dontott; d];
        ez_alapjan_dontott = d_uj;
    end
    
    if ( minimumok(length(minimumok)) == Brminimum)  
        uj2 = [kimenet; Ar1((Brhely+1),:)];
        kimenet = uj2;
        d = repmat('Br',[1,1]);
        d_uj = [ez_alapjan_dontott; d];
        ez_alapjan_dontott = d_uj;
    end
    
%     if ( minimumok(length(minimumok)) == SKminimum)  
%         uj2 = [kimenet; Ar1((SKhely+1),:)];
%         kimenet = uj2;
%         d = repmat('SK',[1,1]);
%         d_uj = [ez_alapjan_dontott; d];
%         ez_alapjan_dontott = d_uj;
%     end
% 
%     if ( minimumok(length(minimumok)) == UKminimum)  
%         uj2 = [kimenet; Ar1((UKhely+1),:)];
%         kimenet = uj2;
%         d = repmat('UK',[1,1]);
%         d_uj = [ez_alapjan_dontott; d];
%         ez_alapjan_dontott = d_uj;
%     end
% 
%     if ( minimumok(length(minimumok)) == ATminimum)  
%         uj2 = [kimenet; Ar1((AThely+1),:)];
%         kimenet = uj2;
%         d = repmat('AT',[1,1]);
%         d_uj = [ez_alapjan_dontott; d];
%         ez_alapjan_dontott = d_uj;
%     end
% 
%     if ( minimumok(length(minimumok)) == ROminimum)  
%         uj2 = [kimenet; Ar1((ROhely+1),:)];
%         kimenet = uj2;
%         d = repmat('RO',[1,1]);
%         d_uj = [ez_alapjan_dontott; d];
%         ez_alapjan_dontott = d_uj;
%     end
% 
%     if ( minimumok(length(minimumok)) == RSminimum)  
%         uj2 = [kimenet; Ar1((RShely+1),:)];
%         kimenet = uj2;
%         d = repmat('RS',[1,1]);
%         d_uj = [ez_alapjan_dontott; d];
%         ez_alapjan_dontott = d_uj;
%     end
% 
%     if ( minimumok(length(minimumok)) == HRminimum)  
%         uj2 = [kimenet; Ar1((HRhely+1),:)];
%         kimenet = uj2;
%         d = repmat('HR',[1,1]);
%         d_uj = [ez_alapjan_dontott; d];
%         ez_alapjan_dontott = d_uj;
%     end
    
    if ( minimumok(length(minimumok)) == IEminimum)  
        uj2 = [kimenet; Ar1((IEhely+1),:)];
        kimenet = uj2;
        d = repmat('IE',[1,1]);
        d_uj = [ez_alapjan_dontott; d];
        ez_alapjan_dontott = d_uj;
    end
    
end

kimenet_vector_1szomszed = reshape(kimenet', hossz, 1);

abserror = abs(Ar1(p+1:hossz/24,1:24)-kimenet(p+1:hossz/24,1:24));
sumabserror = sum(abserror,2);
ss = sum(sumabserror);
atlag = mean(abserror);
% ae = reshape(abserror', 1, (hossz/24-p)*24);
% uj3 = reshape(kimenet', 1, (hossz/24-p)*24);
ae = reshape(abserror', 1, size(abserror,1)*size(abserror,2));
uj3 = kimenet_vector_1szomszed(p*24+1:hossz,1);
relerror = ae/uj3'*100;
display(relerror);
display(mae(arak_without_nan(p*24:hossz,1), kimenet_vector_1szomszed(p*24:hossz,1)));
display(mse(arak_without_nan(p*24:hossz,1), kimenet_vector_1szomszed(p*24:hossz,1)));

