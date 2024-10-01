%-------------------------------------------------------------------------%
%      Dipendenza fra offset e frequenza del primo modo di diocotron      %
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

figure;
plot(offSign * 1000, freqSign, 'r.', 'MarkerSize', 15, 'DisplayName', 'Valori'); hold on; grid on;
xlabel('Offset [mm]', 'FontSize', 15); ylabel('Frequenze DFT (Hz)', 'FontSize', 15);
legend('Location','southeast');
