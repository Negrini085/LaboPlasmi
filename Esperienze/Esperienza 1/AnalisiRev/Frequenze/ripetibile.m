%-------------------------------------------------------------------------%
%       Vogliamo rendere visivamente evidente la problematica dei         %
%               segnali non ripetibili (scariche diverse)                 %
%-------------------------------------------------------------------------%
close all
clear all
clc

% PRIMO GRAFICO: segnali ottenuti con stessa evoluzione libera a contronto
%                (penso che li sovrappongo per renderlo bello evidente dal
%                punto di vista visivo)
path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Dati/Signals/series2_300ms/segnale10.txt';
data = fopen(path, 'rt');
N = 3; filescan = textscan(data,'%f %f','HeaderLines',N);
t1 = filescan {1,1}; v1 = filescan {1,2};

path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Dati/Signals/series2_300ms/segnale01.txt';
data = fopen(path, 'rt');
N = 3; filescan = textscan(data,'%f %f','HeaderLines',N);
t2 = filescan {1,1}; v2 = filescan {1,2};


figure('Renderer', 'painters', 'Position', [10 10 800 700]);
plot(t1, v1, 'r-'); hold on; grid on;
plot(t2, v2, 'g-'); hold on; grid on;
ylabel('Potenziale (V)', 'FontSize',20); xlabel('Tempo (ms)', 'FontSize',20);
