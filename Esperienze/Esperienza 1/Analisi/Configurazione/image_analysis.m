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

