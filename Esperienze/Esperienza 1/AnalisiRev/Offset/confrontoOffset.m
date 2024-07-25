%-------------------------------------------------------------------------%
%            CONFRONTO fra offset ottenuti con due metodologie            %
%-------------------------------------------------------------------------%

clear all
clc

baseIm = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/AnalisiRev/Offset/Risultati/Immagini/serie';
baseSign = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/AnalisiRev/Offset/Risultati/Segnali/serie';

% CICLO SUL NUMERO DI SERIE FATTE
offIm = 0; offSign = 0;
for i=1:9
    % Leggo immagini
    pathIm = [baseIm num2str(i) '.txt'];
    data = fopen(pathIm, 'rt');
    N = 1; filescan = textscan(data,'%f %f %f','HeaderLines',N);
    offImSerie = filescan {1,3}; 

    % Leggo segnali
    pathSign = [baseSign num2str(i) '.txt'];
    data = fopen(pathSign, 'rt');
    N = 1; filescan = textscan(data,'%f %f','HeaderLines',N);
    offSignSerie = filescan {1,2}; 
    

    % AGGIUNGO AI RISPETTIVI CONTENITORI
    offIm = [offIm, offImSerie'];
    offSign = [offSign, offSignSerie'];
end

% FACCIO IL FIT LINEARE
offIm = offIm * 45/419; offSign = offSign * 1000;
offIm = offIm(not (offIm < 0.2)); offSign = offSign(not (offSign < 0.2));
myFit = polyfit(offIm, offSign, 1);


figure;
plot(offIm, offSign, 'r.', 'MarkerSize', 15, 'DisplayName', 'Valori'); hold on; grid on;
plot(offIm, polyval(myFit, offIm), 'b-', 'LineWidth', 2, 'DisplayName', 'Fit'); hold on; grid on;
xlabel('Offset ottici (mm)', 'FontSize', 12); ylabel('Offset DFT (mm)', 'FontSize', 12);
legend('Location','southeast');

disp(['Il coefficiente angolare della regressione lineare è: ' num2str(myFit(1))])