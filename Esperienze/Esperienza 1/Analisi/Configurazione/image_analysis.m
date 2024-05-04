%-------------------------------------------------------------------------%
%                Studio delle immagini per la calibrazione                %
%-------------------------------------------------------------------------%

% Funzione per calcolare il rumore medio di natura elettronica che è
% presente nelle immagini scattate dalla camera. Forniamo come input il
% path alla cartella ed il numero di immagini che dobbiamo andare ad
% analizzare, in modo tale da poter ciclare sulle varie istantanee
% scattate.
function noise = rumore_medio(path, n)
    appo = zeros(1024, 1224); appo = double(appo);
    for i=1:n
        pippo = [path '/dark' sprintf('%03i', i) '.tif'];
        appo = appo * (i-1)/i + double(imread(pippo))/i;
    end
    noise = appo;
end


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

