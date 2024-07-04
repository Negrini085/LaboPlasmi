%-------------------------------------------------------------------------%
%                   Calcolo della lunghezza media di plasma               %
%-------------------------------------------------------------------------%

close all
clear all
clc



% File di output
path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Analisi/Frequenze/LunghezzaPlasma/Lp_serie';
new_data = fopen('/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Analisi/Frequenze/LunghezzaPlasma/lunghMedie.txt','w');
fprintf(new_data, '%s \n','#_serie    Lp    Errore');

% Lavoro sulle ampiezze dei modi precedentemente determinate
for i=1:9
    % Leggo segnali
    data = fopen([path num2str(i) '.txt'], 'rt');
    N = 1; filescan = textscan(data,'%f %f','HeaderLines',N);
    stimeLungh = filescan {1,2}; 


    % Printo dati a file
    fprintf(new_data,  '%s \n', [ num2str(i) '    ' num2str(mean(stimeLungh)) '     ' num2str(std(stimeLungh))]);
end
fclose(new_data);  
