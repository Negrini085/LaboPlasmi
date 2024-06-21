%-------------------------------------------------------------------%
%              Frequenze modo 1 e modo 3 di Diocotron               %
%-------------------------------------------------------------------%

close all
clear all
clc

t_ev = [200, 300, 250, 150, 100, 125, 175, 225, 275];
err = [50, 33.3, 40, 50, 50, 40, 50, 50, 40];

% Leggo frequenze (chiaramente solo quelle che ho determinato mediante la FFT)
path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Analisi/Offset/Segnali/frequenze.txt';

% Leggo Ottici
data = fopen(path, 'rt');
N = 1; filescan = textscan(data,'%f %f %f','HeaderLines',N);
a = filescan {1,1}; omega1 = filescan {1,2}; omega3 = filescan {1,3};
fclose(data);


figure (1);
errorbar(t_ev', omega1, err,  'r.', 'MarkerFaceColor','auto', 'MarkerSize',20); hold on; grid on;
title('Frequenza prima armonica: FFT'); 
xlabel('Tempo (ms)'); ylabel('Frequenza (Hz)');


figure (2);
errorbar(t_ev', omega3, err, 'b.', 'MarkerFaceColor','auto', 'MarkerSize',20); hold on; grid on;
title('Frequenza terza armonica: FFT'); 
xlabel('Tempo (ms)'); ylabel('Frequenza (Hz)');