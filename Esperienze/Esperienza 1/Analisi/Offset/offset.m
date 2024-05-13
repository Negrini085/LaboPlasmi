%-------------------------------------------------------------------------%
%               Grafico i diversi offset al passare del tempo             %
%-------------------------------------------------------------------------%

close all
clear
clc

%---------------------------------------------------------%
%    Offset in funzione del tempo di evoluzione libera    %
%---------------------------------------------------------%
base = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Analisi/Offset/Ottici/indMax/serie';
opt_maxI = zeros(1, 9);
% Calcolo quale sia l'offset medio per ciascuna delle prese dati - ottico
for i=1:9
    % Apro il file, carico i vettori e riscalo opportunamente
    data = fopen([base num2str(i) '.txt'], 'rt');
    N = 1; filescan = textscan(data,'%f %f %f','HeaderLines',N);
    x_centro = filescan {1,1}; y_centro = filescan {1,2}; offset_serie = filescan {1,3};

    opt_maxI(i) = mean(offset_serie);
end

base = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Analisi/Offset/Ottici/wmCharge/serie';
opt_wmC = zeros(1, 9);
% Calcolo quale sia l'offset medio per ciascuna delle prese dati - ottico
for i=1:9
    % Apro il file, carico i vettori e riscalo opportunamente
    data = fopen([base num2str(i) '.txt'], 'rt');
    N = 1; filescan = textscan(data,'%f %f %f','HeaderLines',N);
    x_centro = filescan {1,1}; y_centro = filescan {1,2}; offset_serie = filescan {1,3};

    opt_wmC(i) = mean(offset_serie);
end

figure (1);
l_pixel = 90/838.0; t = [200, 300, 250, 150, 100, 125, 175, 225, 275];
plot(t', opt_maxI' * l_pixel, 'b+', 'MarkerFaceColor','auto', 'MarkerSize',20); hold on; grid on;
plot(t', opt_wmC' * l_pixel, 'r.', 'MarkerFaceColor','auto', 'MarkerSize',20); hold on; grid on;
title('Offset: dipendenza da evoluzione libera'); 
xlabel('Tempo (ms)'); ylabel('Offset (mm)');
legend('Optical: maxI', 'Optical: wmCharge')
