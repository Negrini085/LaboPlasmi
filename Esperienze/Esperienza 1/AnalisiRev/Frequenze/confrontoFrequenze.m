%-------------------------------------------------------------------------%
%            CONFRONTO fra offset ottenuti con due metodologie            %
%-------------------------------------------------------------------------%

close all
clear all
clc

function confrFreq(baseSign, baseIm, tipo, aggiuntaIm)
    disp(['Confronto fra frequenze a partire dai segnali e ' tipo]);

    % CICLO SUL NUMERO DI SERIE FATTE
    offIm = 0; offSign = 0;
    for i=1:9
        % Leggo immagini
        pathIm = [baseIm num2str(i) aggiuntaIm];
        data = fopen(pathIm, 'rt');
        N = 1; filescan = textscan(data,'%f %f','HeaderLines',N);
        offImSerie = filescan {1,2}; 

        % Leggo segnali
        pathSign = [baseSign num2str(i) '.txt'];
        data = fopen(pathSign, 'rt');
        N = 1; filescan = textscan(data,'%f %f %f %f','HeaderLines',N);
        offSignSerie = filescan {1,1};

        % AGGIUNGO AI RISPETTIVI CONTENITORI
        if i == 1
            offIm = offImSerie';
            offSign = offSignSerie';
        else
            offIm = [offIm, offImSerie'];
            offSign = [offSign, offSignSerie'];
        end
    end

    figure;
    plot(offIm, offSign, 'r.', 'MarkerSize', 15, 'DisplayName', 'Valori'); hold on; grid on;
    xlabel('Frequenze ottiche (Hz)', 'FontSize', 12); ylabel('Frequenze DFT (Hz)', 'FontSize', 12);
    legend('Location','southeast');
end


pathSign = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/AnalisiRev/Frequenze/Risultati/Segnali/serie';
pathIm = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/AnalisiRev/Frequenze/Risultati/Immagini/serie';

% CASO CON CORREZIONE PER OFFSET FINITO
confrFreq(pathSign, pathIm, 'correzione per offset finito sulle immagini', '_r.txt');

% CASO CON CORREZIONE PER OFFSET E RAGGIO FINITI
confrFreq(pathSign, pathIm, 'correzione per offset e raggio finiti sulle immagini', '_rp.txt');

% CASO CON CORREZIONE PER OFFSET, RAGGIO E TEMPERATURA FINITE
confrFreq(pathSign, pathIm, 'correzione per offset, raggio e temperatura finiti sulle immagini', '_rpt.txt');