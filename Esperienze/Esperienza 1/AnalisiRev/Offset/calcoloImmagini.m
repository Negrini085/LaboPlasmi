%-------------------------------------------------------------------------%
%          Determinazione degli offset dalle immagini ripetibili          %
%-------------------------------------------------------------------------%
close all
clear all
clc

% Dobbiamo selezionare quelle immagini di plasma che corrispondono a
% segnali ripetibili dal settore S2: di seguito riporto i progressivi delle
% immagini e dei segnali scelti (saranno 9 contenitori, di cui 8 commentati
% in fase di esecuzione -> dal primo all'ultimo ho corrispondenza con le
% serie dalla prima all'ultima). Riporto i nove possibili cammini che 
% possono essere utilizzati durante l'esecuzione di questo matlab script, 
% in modo tale da non dover copiarlo da terminale ogni volta.

%sign = [6, 7, 9, 12, 17, 19, 22, 23, 24, 25, 29, 32, 38, 39, 42, 43, 44];
%path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Dati/CAMimages/series1_200ms/plasma';

%sign = [4, 6, 9, 12, 14, 19, 22, 24, 25, 26, 27, 29, 31, 34, 35, 36, 39, 44, 49];
%path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Dati/CAMimages/series2_300ms/plasma';

%sign = [2, 9, 14, 18, 22, 24, 25, 28, 31, 35, 36, 38, 40, 41, 43, 44, 46, 49, 50, 51, 52, 60];
%path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Dati/CAMimages/series3_250ms/plasma';

%sign = [5, 6, 8, 10, 11];
%path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Dati/CAMimages/series4_150ms/plasma';

%sign = [4, 5, 6, 11];
%path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Dati/CAMimages/series5_100ms/plasma';

%sign = [1, 6, 8, 9];
%path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Dati/CAMimages/series6_125ms/plasma';

%sign = [1, 4, 6, 9];
%path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Dati/CAMimages/series7_175ms/plasma';

%sign = [2, 3, 4, 10];
%path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Dati/CAMimages/series8_225ms/plasma';

%sign = [1, 2, 5, 8];
%path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Dati/CAMimages/series9_275ms/plasma';


% Definisco ora la routine che mi consente di studiare quale sia l'offset
% della colonna di plasma: sono interessato a trovare la posizione centrale
% della regione a simmetria cilindrica occupata dal plasma stesso.
% Lavoriamo effettuando una media pesata sull'intensità del singolo pixel
% in modo da determinare l'ascissa e l'ordinata del centro del plasma
% stesso.
function opticalOffset_wmCharge(path, sign, nome_serie)
    % File per contenere i dati elaborati
    new_data = fopen(['/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/AnalisiRev/Offset/Risultati/Immagini/' nome_serie],'w');
    fprintf(new_data, '%s \n', 'Coordinata x       Coordinata y     Offset');

    % Ciclo solamente sulle immagini che corrispondono ad un buon segnale
    % sul settore S2
    for i=sign
        % Leggo immagini
        M = imread([path sprintf('%03i', i) '.tif']); 
        M = double(M); [rowm, colm] = size(M); disp(i);
        
        % Faccio media pesata sull'intensità dei singoli pixel: devo in
        % primo luogo creare una matrice delle ascisse e delle ordinate in
        % modo tale da poter calcolare le coordinate del centro della
        % colonna di plasma
        [X, Y] = meshgrid(linspace(-colm/2, colm/2, colm), linspace(-rowm/2 + 10, rowm/2 + 10, rowm));
        xm = X.*M; ym = Y.*M; col = sum(sum(xm))/sum(sum(M)); row = sum(sum(ym))/sum(sum(M));

        offset = sqrt((row)^2 + (col)^2);
        fprintf(new_data,  '%s \n', [num2str(col) '    ' num2str(row) '    ' num2str(offset)]);
    end
    fclose(new_data);  
end

fileout = input('Nome file_out: \n');
opticalOffset_wmCharge(path, sign, fileout);