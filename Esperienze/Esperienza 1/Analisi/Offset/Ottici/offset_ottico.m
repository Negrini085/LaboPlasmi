%-------------------------------------------------------------------------%
%                Determinazione degli offset dalle immagini               %
%-------------------------------------------------------------------------%

close all
clear all
clc


% File di output
path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Analisi/Offset/Ottici/wmCharge/serie';
new_data = fopen('/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Analisi/Offset/Ottici/offset.txt','w');
fprintf(new_data, '%s \n','#_serie    Offset');

% Lavoro sulle ampiezze dei modi precedentemente determinate
for i=1:9
    % Leggo segnali
    data = fopen([path num2str(i) '.txt'], 'rt');
    N = 1; filescan = textscan(data,'%f %f %f ','HeaderLines',N);
    x = filescan {1,1}; y = filescan {1,2}; offset = filescan {1,3}; 

    % Printo dati a file
    fprintf(new_data,  '%s \n', [ num2str(i) '    ' num2str(mean(offset))]);
    disp(['Offset per serie ' num2str(i) ' determinato'])
end
fclose(new_data);  
