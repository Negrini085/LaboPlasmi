%-------------------------------------------------------------------------%
%               Grafico i diversi offset al passare del tempo             %
%-------------------------------------------------------------------------%

%---------------------------------------------------------%
%    Offset in funzione del tempo di evoluzione libera    %
%---------------------------------------------------------%
base = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Analisi/Offset/Ottici/serie';
off = zeros(1, 9);
% Calcolo quale sia l'offset medio per ciascuna delle prese dati
for i=1:9
    % Apro il file, carico i vettori e riscalo opportunamente
    data = fopen([base num2str(i) '.txt'], 'rt');
    N = 1; filescan = textscan(data,'%f %f %f','HeaderLines',N);
    x_centro = filescan {1,1}; y_centro = filescan {1,2}; offset_serie = filescan {1,3};

    off(i) = mean(offset_serie);
end

figure (1);
l_pixel = 90/838.0; t = [200, 300, 250, 150, 100, 125, 175, 225, 275];
plot(t', off' * l_pixel, 'r.', 'MarkerFaceColor','auto', 'MarkerSize',20); hold on; grid on;
title('Offset: dipendenza da evoluzione libera'); 
xlabel('Tempo (ms)'); ylabel('Offset (mm)');