%-------------------------------------------------------------------------%
%                Pulizia delle immagini per la calibrazione               %
%-------------------------------------------------------------------------%

close all
clear all
clc

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
% step che dobbiamo fare sono due: sottrarre il rumore medio e porre a zero
% tutti i pixel che si trovano all'esterno del raggio della trappola.
function pulizia(path, name, n_img, path_rum, n_rum, r_trap)
    meannoise = rumore_medio(path_rum, n_rum);
    for i=1:n_img
        % Pulisco le immagini togliendo il rumore medio
        pippo = [path '/' name sprintf('%03i', i) '.tif'];
        M = imread(pippo); M = double(M); [col row] = size(M); 
        M = M - meannoise; M(M<0) = 0;
        

        % Pongo a zero i pixel fuori dalla trappola pari a zero
        [X, Y] = meshgrid(linspace(-col/2, col/2, col), linspace(-row/2 + 10, row/2 + 10, row));
        M((X.*X + Y.*Y)' > r_trap^2) = 0;
 
        % Salvo l'immagine: l'effetto totale è che vado a porre a zero
        % tutti i pixel esterni a
        M = uint16(M); pippo = [path '/plasma' sprintf('%03i', i) '.tif'];
        imwrite(M, pippo);
        
    end
end
