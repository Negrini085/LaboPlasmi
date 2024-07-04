%-------------------------------------------------------------------------%
%                   Determinazione degli offset con la FFT                %
%-------------------------------------------------------------------------%

close all
clear all
clc

% Guadagno dell'amplificatore necessario per il corretto calcolo
% dell'offset ---> I primi due sono fra 17000 e 18000, mentre la seconda
% coppia di dati riguarda quelle frequenze poste fra 50000 Hz e 53000 Hz
guad = [53.95, 53.1, 29.65, 28.15];

% File di output
path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Analisi/Offset/Segnali/Serie/serie';
new_data = fopen('/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Analisi/Offset/Segnali/offset.txt','w');
fprintf(new_data, '%s \n','#_serie    Offset    Errore');

% Lavoro sulle ampiezze dei modi precedentemente determinate
for i=1:9
    % Leggo segnali
    data = fopen([path num2str(i) '.txt'], 'rt');
    N = 1; filescan = textscan(data,'%f %f %f %f','HeaderLines',N);
    omega1 = filescan {1,1}; a1 = filescan {1,2}; omega3 = filescan {1,3}; a3 = filescan {1,4}; 
    disp(['Offset per serie ' num2str(i)])

    offset = omega1;    
    for j=1:length(omega1)
        g1 = (omega1(j) - 17000) * (guad(2) - guad(1))/1000 + guad(1);
        g3 = (omega3(j) - 50000) * (guad(4) - guad(3))/3000 + guad(3);
        offset(j) = sqrt(g1/g3) * (a3(j)/a1(j));
    end
    % Printo dati a file
    fprintf(new_data,  '%s \n', [ num2str(i) '    ' num2str(mean(offset)) '     ' num2str(std(offset))]);
end
fclose(new_data);  


%-------------------------------------------------------------------------%
%             Determinazione frequenze prima e terza armonica             %
%-------------------------------------------------------------------------%
new_data = fopen('/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Analisi/Offset/Segnali/frequenze.txt','w');
fprintf(new_data, '%s \n','#_serie    Omega1    Omega3');

disp(['Calcolo delle frequenze alle varie evoluzioni temporali'])
% Lavoro con dati trovati con la FFT
for i=1:9
    % Leggo segnali
    data = fopen([path num2str(i) '.txt'], 'rt');
    N = 1; filescan = textscan(data,'%f %f %f %f','HeaderLines',N);
    omega1 = filescan {1,1}; a1 = filescan {1,2}; omega3 = filescan {1,3}; a3 = filescan {1,4}; 

    % Printo dati a file
    fprintf(new_data,  '%s \n', [num2str(i) '    ' num2str(mean(omega1)) '    ' num2str(mean(omega3))]);
end
fclose(new_data);  