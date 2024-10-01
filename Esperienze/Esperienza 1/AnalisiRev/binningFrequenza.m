%-------------------------------------------------------------------------%
%          Studio delle frequenze facendo un binning sull'offset          %
%-------------------------------------------------------------------------%

clear all
clc

baseOff = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/AnalisiRev/Offset/Risultati/Segnali/serie';
baseSign = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/AnalisiRev/Frequenze/Risultati/Segnali/serie';

% CICLO SUL NUMERO DI SERIE FATTE
freqSign = 0; offSign = 0;
for i=1:9
    % Leggo Offset
    pathOff = [baseOff num2str(i) '.txt'];
    data = fopen(pathOff, 'rt');
    N = 1; filescan = textscan(data,'%f %f','HeaderLines',N);
    offSerie = filescan {1,2}; 

    % Leggo segnali
    pathSign = [baseSign num2str(i) '.txt'];
    data = fopen(pathSign, 'rt');
    N = 1; filescan = textscan(data,'%f %f %f %f','HeaderLines',N);
    freqSerie = filescan {1,1};

    % AGGIUNGO AI RISPETTIVI CONTENITORI
    if i == 1
        freqSign = freqSerie';
        offSign = offSerie';
    else
        freqSign = [freqSign, freqSerie'];
        offSign = [offSign, offSerie'];
    end
end

freqBin = zeros(1, 6); offBin = zeros(1, 6); error = zeros(1, 6);
offMin = min(offSign); offMax = max(offSign); dOff = (offMax - offMin)/6;
for i=1:6
    offBin(i) = offMin+ (i-0.5) * dOff;
    freqBin(i) = mean(freqSign(offSign > (offMin + (i-1)*dOff) & offSign < (offMin + i*dOff)));
    error(i) = std(freqSign(offSign > (offMin + (i-1)*dOff) & offSign < (offMin + i*dOff)));
end

figure;
errorbar(1000 * offBin, freqBin, error, 'r.', 'MarkerSize', 20); hold on; grid on;
xlabel('Offset [mm]', 'FontSize', 15); ylabel('Frequenza [Hz]', 'FontSize', 15);

freqBin
1000 * offBin