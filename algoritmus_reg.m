function [x, p] = algoritmus_reg(data, datumInt, napok, reghossz)
    %data : az adatok amiken regressziót szeretnénk
    %datumInt : gyakorlatilag az x tengely
    %napok : mennyi napot kap meg az algoritmus alapból 24-gyel szorozva
    %lesz majd ez a kiinduló adatbázis
    %reghossz : hány napot vegyen figyelembe a regresszió kiszámításában, nem
    %lehet nagyobb mint a napok száma, ha n=0 akkor az összes addigi napot
    %figyelembe veszi
    %x visszatérési érték pedig úgy alakul ki hogy mindig 24 órát
    %elõrejelzünk és hozzáfûzzûk a már meglévõ adatokhoz, hogy könnyen
    %lehessen hibát számolni ugyan olyan hosszú lesz mint a data ami úgy
    %lehetséges hogy az elején beleteszem az adatbázisnak megadott napokat
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