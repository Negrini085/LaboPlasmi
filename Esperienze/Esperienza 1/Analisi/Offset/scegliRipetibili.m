%-------------------------------------------------------------------------%
%   Scelgo quali segnali analizzare: voglio rispettare la riproducibiltà  %
%-------------------------------------------------------------------------%

close all
clear
clc

base = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Dati/Signals/';
path = input('Path to file: \n');
nfiles = input('numer of file: \n');

for i=1:nfiles
    % Apro il file, carico i vettori e riscalo opportunamente
    data = fopen([base path '/segnale' sprintf('%02i', i) '.txt'], 'rt');
    N = 3; filescan = textscan(data,'%f %f','HeaderLines',N);
    t = filescan {1,1}; v = filescan {1,2};

    figure(i);
    plot(t, v, 'r-', 'LineWidth',2); hold on; grid on;
    ylim([-0.7 0.7]); title(['Segnale ' num2str(i)]); xlabel('Tempo (ms)'); ylabel('Potenziale (V)')
end