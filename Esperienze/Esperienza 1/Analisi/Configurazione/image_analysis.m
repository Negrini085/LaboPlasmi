%-------------------------------------------------------------------------%
%                Studio delle immagini per la calibrazione                %
%-------------------------------------------------------------------------%

% Funzione per calcolare il rumore medio di natura elettronica che è
% presente nelle immagini scattate dalla camera. Forniamo come input il
% path alla cartella ed il numero di immagini che dobbiamo andare ad
% analizzare, in modo tale da poter ciclare sulle varie istantanee
% scattate.
function img = rumore_medio(path, n)
    appo = zeros(1024, 1224); appo = double(appo);
    for i=1:n
        pippo = [path '/dark' sprintf('%03i', i) '.tif'];
        appo = appo * (i-1)/i + double(imread(pippo))/i;
    end
    img = appo;
end


% Funzione per creare delle immagini di plasma pulite ed analizzabili. Gli 
% step che dobbiamo fare sono tre: sottrarre il rumore medio, porre a zero
% tutti i pixel che si trovano all'esterno del raggio della trappola ed
% infine sottrarre l'ulteriore rumore presente nella trappola legato
% principalmente a riflessioni sulle pareti cilindriche. Vengono create le
% immagini pulite e salvate in una cartella chiamata PlasmaPulite
function pulizia_immagine_3step(path, n_img, path_rum, n_rum, r_trap, r_plasma)
    meannoise = rumore_medio(path_rum, n_rum);
    for i=1:n_img
        % Pulisco le immagini togliendo il rumore medio
        pippo = [path '/plasma' sprintf('%03i', i) '.tif'];
        M = imread(pippo); M = double(M); 
        M = M - meannoise; M(M<0) = 0;

        % Pongo a zero i pixel fuori dalla trappola pari a zero
        [col row] = size(M); 
        [X, Y] = meshgrid(linspace(-col/2, col/2, col), linspace(-row/2+10, row/2+10, row));
        M((X.*X + Y.*Y)>r_trap^2) = 0;

        % Faccio una media sui pixel che si trovano nella trappola, ma non
        % contengono alcun plasma in modo tale da poter sottrarre del
        % rumore aggiuntivo dovuto a riflessioni multiple sulle pareti
        % della trappola
        rumore_rim = mean(mean(M((X.*X + Y.*Y)<r_trap^2 & (X.*X + Y.*Y)>r_plasma^2)));
        M((X.*X + Y.*Y)<r_trap^2 & (X.*X + Y.*Y)>r_plasma^2) = M((X.*X + Y.*Y)<r_trap^2 & (X.*X + Y.*Y)>r_plasma^2) - rumore_rim;
        M(M<0) = 0;

        M = uint16(M); pippo = [path '/PlasmaPulite/plasma' sprintf('%03i', i) '.tif'];
        imwrite(M, pippo); 
    end
end



                %---------------------------------%
                %        STUDIO DEL RUMORE        %
                %---------------------------------%

path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Dati/CAMimages/dark';
mean_noise = rumore_medio(path, 80);



                %-----------------------------%
                %     DIMENSIONI TRAPPOLA     %
                %-----------------------------%

% Abbiamo due immagini che ci consentono di valutare le dimensioni della
% trappola e di calcolare il fattore di conversione per determinare le
% dimensioni in metri di un singolo pixel: utilizziamo la parte di codice
% presente nell'Esperienza 0 per fare il display degli anelli. Abbiamo
% trovato:

% IMMAGINE 1:
%        ---> Pixel alto:        408
%        ---> Pixel basso:      -429
%        ---> Pixel destro:      417
%        ---> Pixel sinistro:   -419

% IMMAGINE 2:
%        ---> Pixel alto:        409
%        ---> Pixel basso:      -429
%        ---> Pixel destro:      418
%        ---> Pixel sinistro:   -419

% Per ottenere delle immagini esattamente centrate traslerò in alto di 10
% pixel tutte le immagini scattate per questa esperienza: il tasso di
% convesione è dato da 838 pixel che coprono i 9 cm di diametro della
% trappola. Presentiamo una lunghezza per pixel in millimetri
l_pixel = 90/838.0;



                 %-------------------------%
                 %     PULIZIA IMMAGINI    %
                 %-------------------------%

