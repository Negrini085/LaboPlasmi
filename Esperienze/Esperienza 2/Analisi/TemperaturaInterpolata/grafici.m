%-------------------------------------------------------------------------%
%          Grafici per l'esperienza della misura di temperatura           %
%-------------------------------------------------------------------------%

close all
clear all
clc

path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 2/Dati/Signals/rumore_zoom_bump/no_off/segnale01.txt';
data = fopen(path, 'rt');
N = 3; filescan = textscan(data,'%f %f','HeaderLines',N);
t = filescan {1,1}; v = filescan {1,2};

figure;
plot(t, smooth(v, 100), 'k-'); hold on; grid on;
title('Rumore zoom bump'); xlabel('Tempo (us)'); ylabel('Potenziale (mV)')



path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 2/Dati/Signals/scarica_ramp_zoom/no_off/segnale01.txt';
data = fopen(path, 'rt');
N = 3; filescan = textscan(data,'%f %f','HeaderLines',N);
t = filescan {1,1}; v = filescan {1,2};

figure;
plot(t, smooth(v, 100), 'k-'); hold on; grid on;
title('Scarica ramp zoom'); xlabel('Tempo (us)'); ylabel('Potenziale (mV)')



path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 2/Dati/Signals/rumore_zoom/no_off/segnale01.txt';
data = fopen(path, 'rt');
N = 3; filescan = textscan(data,'%f %f','HeaderLines',N);
t = filescan {1,1}; v = filescan {1,2};

figure;
plot(t, smooth(v, 100), 'k-'); hold on; grid on;
title('Rumore zoom'); xlabel('Tempo (us)'); ylabel('Potenziale (mV)')



path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 2/Dati/Signals/scarica_ramp_totale/no_off/segnale01.txt';
data = fopen(path, 'rt');
N = 3; filescan = textscan(data,'%f %f','HeaderLines',N);
t = filescan {1,1}; v = filescan {1,2};

figure;
plot(t, smooth(v, 100), 'k-'); hold on; grid on;
title('Scarica ramp totale'); xlabel('Tempo (us)'); ylabel('Potenziale (V)')