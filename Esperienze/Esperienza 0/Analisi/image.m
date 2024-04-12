%---------------------------------------------------------------%
%    Analisi del rumore legato all'utilizzo della camera CCD    %
%---------------------------------------------------------------%

close all
clear all
clc

% PUNTO 1 ---> Stampo a video un'immagine scattata a trappola vuota e con
%              fosforo a potenziale di terra: ciò che stiamo osservando è
%              il rumore dovuto alla camera e ai vari circuiti elettronici
%              in gioco.

path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 0/Dati/CAMimages/dark2x2/dark023.tif';
M = imread(path); [row col] = size(M); M = double(M); [row col] = size(M); 
[X, Y] = meshgrid(linspace(-col/2, col/2, col), linspace(-row/2, row/2, row));
colormap('jet'); surface(X, Y, M,'FaceAlpha',1,'LineStyle','none','FaceColor','flat');
title('Rumore'); axis([ -col/2 col/2 -row/2 row/2]); daspect([1 1 1]); colorbar; xlabel("Colonne"); ylabel("Righe");



% PUNTO 2 ---> Faccio una media delle varie immagini di rumore per avere
%              una stima del rumore medio causato dalla camera ed evitare
%              di conseguenza delle sistematiche sperimentali

mean = zeros(1024, 1224); mean = double(mean);

for i=1:80
    if i<10
        path = ['/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 0/Dati/CAMimages/dark2x2/dark00' num2str(i) '.tif'];
    else
        path = ['/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 0/Dati/CAMimages/dark2x2/dark0' num2str(i) '.tif'];
    end
    
    appo = imread(path); appo = double(appo);
    mean = mean * (i-1)/i + appo/i;
end
figure;
[X, Y] = meshgrid(linspace(-col/2, col/2, col), linspace(-row/2, row/2, row));
colormap('jet'); surface(X, Y, M,'FaceAlpha',1,'LineStyle','none','FaceColor','flat');
title('Rumore medio'); axis([ -col/2 col/2 -row/2 row/2]); daspect([1 1 1]); colorbar; xlabel("Colonne"); ylabel("Righe");