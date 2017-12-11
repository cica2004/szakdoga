function [x, p] = algoritmus_reg(data, datumInt, napok, reghossz)
    %data : az adatok amiken regresszi�t szeretn�nk
    %datumInt : gyakorlatilag az x tengely
    %napok : mennyi napot kap meg az algoritmus alapb�l 24-gyel szorozva
    %lesz majd ez a kiindul� adatb�zis
    %reghossz : h�ny napot vegyen figyelembe a regresszi� kisz�m�t�s�ban, nem
    %lehet nagyobb mint a napok sz�ma, ha n=0 akkor az �sszes addigi napot
    %figyelembe veszi
    %x visszat�r�si �rt�k pedig �gy alakul ki hogy mindig 24 �r�t
    %el�rejelz�nk �s hozz�f�zz�k a m�r megl�v� adatokhoz, hogy k�nnyen
    %lehessen hib�t sz�molni ugyan olyan hossz� lesz mint a data ami �gy
    %lehets�ges hogy az elej�n beleteszem az adatb�zisnak megadott napokat
    hossz = length(data);
    eredmeny = data(1:24*napok, 1);
    display(length(eredmeny));
    p = zeros(napok, 2);
    for i = 24*napok + 1 : 24 : length(data) - 23, 
        if reghossz == 0,
            k = 1;
        else
            k = i - 24*reghossz;
        end
        P = polyfit(datumInt(k : i, 1), data(k : i, 1), 1);
        p = [p; P];
        yfit = P(1) * datumInt(k : i+23, 1) + P(2);
        eredmeny = [eredmeny; yfit(length(yfit)-23 : length(yfit))];
    end
     x = eredmeny;
end