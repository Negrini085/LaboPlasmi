close all
clear all
clc

path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 2/Dati/Signals/rumore_zoom_bump/no_off/segnale01.txt';
data = fopen(path, 'rt');
N = 3; filescan = textscan(data,'%f %f','HeaderLines',N);
t = filescan {1,1}; v = filescan {1,2};

figure;
plot(t, smooth(v, 100), 'k-'); hold on; grid on;
title('rumore-zoom-bump')



path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 2/Dati/Signals/scarica_ramp_zoom/no_off/segnale01.txt';
data = fopen(path, 'rt');
N = 3; filescan = textscan(data,'%f %f','HeaderLines',N);
t = filescan {1,1}; v = filescan {1,2};

figure;
plot(t, smooth(v, 100), 'k-'); hold on; grid on;
title('scarica-ramp-zoom')



path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 2/Dati/Signals/rumore_zoom/no_off/segnale01.txt';
data = fopen(path, 'rt');
N = 3; filescan = textscan(data,'%f %f','HeaderLines',N);
t = filescan {1,1}; v = filescan {1,2};

figure;
plot(t, smooth(v, 100), 'k-'); hold on; grid on;
title('rumore-zoom')



path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 2/Dati/Signals/scarica_ramp_totale/no_off/segnale01.txt';
data = fopen(path, 'rt');
N = 3; filescan = textscan(data,'%f %f','HeaderLines',N);
t = filescan {1,1}; v = filescan {1,2};

figure;
plot(t, smooth(v, 100), 'k-'); hold on; grid on;
title('scarica-ramp-totale')