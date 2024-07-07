%-------------------------------------------------------------------------%
%                   Determinazione dei raggi di plasma                    %
%-------------------------------------------------------------------------%

close all
clear all 
clc

path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Dati/CAMimages/series5_100ms/plasma006.tif';
figure(1);
M = imread(path); 
[row col] = size(M); M = double(M); [row col] = size(M); 
[X, Y] = meshgrid(linspace(-col/2, col/2, col), linspace(-row/2+10, row/2+10, row));
colormap('jet'); surface(X, Y, M,'FaceAlpha',1,'LineStyle','none','FaceColor','flat');
title('Immagine di plasma pulita'); axis([ -col/2 col/2 -row/2 row/2]); daspect([1 1 1]); 
colorbar; xlabel("Colonne"); ylabel("Righe");

indCen = sum(M);
[maxM, ind] = max(indCen);
disp(['Indice di colonna: ' num2str(ind)]);

figure;
plot(linspace(1, 1024, 1024), M(:, ind), 'r-', 'LineWidth', 2);