function x = algoritmus_stat(data, napok, n, m)
    %data : az adatok amiket felszeretnénk dolgozni
    %napok : mennyi napot kap meg az algoritmus alapból 24-gyel szorozva
    %lesz majd ez a kiinduló adatbázis
    %n : hány napot vegyen figyelembe a kiszámításában,
    %nem lehet nagyobb mint a napok száma,
    %ha n=0 akkor az összes addigi napot figyelembe veszi
    %m : melyik algoritmust szeretnénk használni a mean -t vagy a median -t
    %x visszatérési érték pedig úgy alakul ki hogy mindig 24 órát
    %elõrejelzünk és hozzáfûzzûk a már meglévõ adatokhoz, hogy könnyen
    %lehessen hibát számolni ugyan olyan hosszú lesz mint a data ami úgy
    %lehetséges hogy az elején beleteszem az adatbázisnak megadott napokat
    hossz = length(data);
    eredmeny = data(1:24*napok, 1);
    for i = 24*napok + 1 : 24 : length(data) - 23, 
        if n == 0,
            k = 1;
        else
            k = i-24*n;
        end
        if strcmp(m, 'median'),
            tmp = median(data(k : i, :));
        end
        if strcmp(m, 'mean'),
            tmp = mean(data(k : i, :));
        end
        eredmeny = [eredmeny; repmat(tmp, 24, 1)]; 
    end
    x = eredmeny;
end