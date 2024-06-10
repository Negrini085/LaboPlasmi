%-------------------------------------------------------------------------%
%                   Studio degli offset dalle immagini                    %
%-------------------------------------------------------------------------%

close all
clear all
clc

% Dobbiamo selezionare quelle immagini di plasma che corrispondono a
% segnali ripetibili dal settore S2: di seguito riporto i progressivi delle
% immagini e dei segnali scelti (saranno 9 contenitori, di cui 8 commentati
% in fase di esecuzione -> dal primo all'ultimo ho corrispondenza con le
% serie dalla prima all'ultima)
%sign = [2, 4, 5, 6, 7, 8, 9, 10, 11, 14, 15, 16, 17, 18, 21, 22, 24, 29, 30, 31, 32, 33, 34, 35, 37, 39, 40, 41, 43, 45, 46, 47, 49];
%sign = [2, 3, 4, 6, 8, 9, 11, 12, 13, 14, 15, 16, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 34, 35, 36, 37, 38, 39, 40, 41, 42, 45, 46, 47, 48, 49, 50];
%sign = [1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 42, 43, 45, 46, 47, 48, 49, 50, 51, 52, 53, 56, 57, 58, 59, 60, 61, 62];
%sign = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
%sign = [1, 2, 3, 6, 7, 8, 9, 10, 11];
%sign = [1, 2, 3, 4, 6, 7, 8, 10];
%sign = [1, 2, 4, 5, 6, 7, 8, 9, 10];
%sign = [1, 3, 4, 5, 6, 8, 9, 10];
sign = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

% Riporto i nove possibili cammini che possono essere utilizzati durante
% l'esecuzione di questo matlab script, in modo tale da non dover copiarlo
% da terminale ogni volta
%path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Dati/CAMimages/series1_200ms/plasma';
%path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Dati/CAMimages/series2_300ms/plasma';
%path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Dati/CAMimages/series3_250ms/plasma';
%path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Dati/CAMimages/series4_150ms/plasma';
%path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Dati/CAMimages/series5_100ms/plasma';
%path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Dati/CAMimages/series6_125ms/plasma';
%path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Dati/CAMimages/series7_175ms/plasma';
%path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Dati/CAMimages/series8_225ms/plasma';
path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Dati/CAMimages/series9_275ms/plasma';


% Definisco ora la procedura per analizzare i file di immagini: quello che
% voglio fare è considerare solo le immagini che corrispondono a dei
% segnali che abbiamo ritenuto ripetibili. Troviamo la riga e la colonna a
% cui si trova il centro del plasma sommando inizialmente sulle ascisse e
% poi sulle ordinate (una volta sulla matrice di partenza, mentre una sulla
% trasposta per come funziona la funzione sum di matlab). I valori stimati
% per ogni singola immagine vengono stampati a file: il file conterrà 3
% colonne il cui significato sarà il seguente
%           ---> coordinata x del centro del plasma
%           ---> coordinata y del centro del plasma
%           ---> valore del raggio
function opticalOffset_maxI(path, sign, nome_serie)
    % File per contenere i dati elaborati
    new_data = fopen(['/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Analisi/Offset/Ottici/indMax/' nome_serie],'w');
    fprintf(new_data, '%s \n', 'Coordinata x       Coordinata y     Offset');

    % Ciclo solamente sulle immagini che corrispondono ad un buon segnale
    % sul settore S2
    for i=sign
        % Leggo immagini
        M = imread([path sprintf('%03i', i) '.tif']); 
        M = double(M); [rowm, colm] = size(M);
        % Trovo indici corretti e determino il raggio
        appo = sum(M); [m1, col] = max(appo);
        appo = sum(M'); [m2, row] = max(appo);
        offset = sqrt((row - rowm/2 + 10)^2 + (col - colm/2)^2);

        fprintf(new_data,  '%s \n', [num2str(col - colm/2) '    ' num2str(row - rowm/2 + 10) '    ' num2str(offset)]);
    end
    fclose(new_data);  
end

fileout = input('Nome file_out: \n');
opticalOffset_maxI(path, sign, fileout);