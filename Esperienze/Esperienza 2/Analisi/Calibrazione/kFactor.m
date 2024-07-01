%-------------------------------------------------------------------------%
%             Codice per determinare il fattore di conversione            %
%-------------------------------------------------------------------------%

% Funzione per il calcolo dell'intensità totale delle immagini: ciò che
% facciamo è sommare i valori dei vari pixel. Questa funzione restituisce
% un vettore di intensità, di dimensione pari al campione che stiamo
% prendendo in considerazione
function img_int = intensita_immagine(path, name, n)
    img_int = zeros(1, n);
    for i=1:n
        appo = [path '/' name sprintf('%03i', i) '.tif'];
        M = imread(appo); M = double(M);
        img_int(i) = sum(sum(M));
    end
end

% Funzione per il calcolo della carica elettronica, mi basta leggere il
% contenuto del file Risultati/scaricaEle.txt
function charge = carica_elettronica(path)
    % Apro il file, carico i vettori e riscalo opportunamente
    data = fopen(path, 'rt');
    N = 3; filescan = textscan(data,'%f %f','HeaderLines',N);
    charge = filescan {1,2};
end

pathCh = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 2/Analisi/Calibrazione/Risultati/scaricaEle.txt';
car_ele = carica_elettronica(pathCh);

pathInt = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 2/Analisi/Calibrazione/PlasmaPulite';
img_int = intensita_immagine(pathInt, 'plasma', 20);

disp(['La carica elettronica è pari a: -(' num2str(mean(car_ele), 4) ' +/-' num2str(std(car_ele), 4) ') C'])
disp(['La intensità media delle immagini pulite è: ' num2str(mean(img_int), 4) ' +/-' num2str(std(img_int), 4) ' a.u.'])

k_factor = mean(car_ele)/mean(img_int);
disp(['Il fattore di conversione è pari a : -' num2str(k_factor, 4) ' C/a.u.'])