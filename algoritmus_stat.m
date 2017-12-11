function x = algoritmus_stat(data, napok, n, m)
    %data : az adatok amiket felszeretn�nk dolgozni
    %napok : mennyi napot kap meg az algoritmus alapb�l 24-gyel szorozva
    %lesz majd ez a kiindul� adatb�zis
    %n : h�ny napot vegyen figyelembe a kisz�m�t�s�ban,
    %nem lehet nagyobb mint a napok sz�ma,
    %ha n=0 akkor az �sszes addigi napot figyelembe veszi
    %m : melyik algoritmust szeretn�nk haszn�lni a mean -t vagy a median -t
    %x visszat�r�si �rt�k pedig �gy alakul ki hogy mindig 24 �r�t
    %el�rejelz�nk �s hozz�f�zz�k a m�r megl�v� adatokhoz, hogy k�nnyen
    %lehessen hib�t sz�molni ugyan olyan hossz� lesz mint a data ami �gy
    %lehets�ges hogy az elej�n beleteszem az adatb�zisnak megadott napokat
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