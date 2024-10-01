%-------------------------------------------------------------------------%
%             CODICE per confronto segnali non ripetibili                 %
%-------------------------------------------------------------------------%

close all
clear all
clc

% Leggo il segnale in questione
path1 = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Dati/Signals/series2_300ms/segnale01.txt';
path2 = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Dati/Signals/series2_300ms/segnale10.txt';

data = fopen(path1, 'rt');
N = 3; filescan = textscan(data,'%f %f','HeaderLines',N);
t1 = filescan {1,1}; v1 = filescan {1,2};

data = fopen(path2, 'rt');
N = 3; filescan = textscan(data,'%f %f','HeaderLines',N);
t2 = filescan {1,1}; v2 = filescan {1,2};

figure;
plot(t2, v2, 'r-', 'DisplayName', 'First'); hold on; grid on;
plot(t1, v1, 'g-', 'DisplayName', 'Second'); hold on; grid on;
xlabel('Tempo [ms]', 'FontSize', 14); ylabel('Potenziale [V]', 'FontSize', 14);
legend('show', 'Location','northwest'); xlim([0, 350]);