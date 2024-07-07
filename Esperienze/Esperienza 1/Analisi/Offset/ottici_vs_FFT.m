%-------------------------------------------------------------------------%
%              Confronto calcolo offset (Ottici vs Segnali)               %
%-------------------------------------------------------------------------%

close all
clear all
clc

t_ev = [200, 300, 250, 150, 100, 125, 175, 225, 275];

% Leggo offset 
path1 = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Analisi/Offset/Ottici/offset.txt';
path2 = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Analisi/Offset/Segnali/offset.txt';

% Leggo Ottici
data1 = fopen(path1, 'rt');
N = 1; filescan = textscan(data1,'%f %f %f','HeaderLines',N);
off_ottici = filescan {1,2}; errOpt = filescan {1,3}; fclose(data1);

% Leggo Segnali
data2 = fopen(path2, 'rt');
N = 1; filescan = textscan(data1,'%f %f %f','HeaderLines',N);
off_FFT = filescan {1,2}; errFFT = filescan {1,3}; fclose(data2);


figure (1);
l_pixel = 90/838.0; 
errorbar(t_ev', off_ottici * l_pixel, errOpt * l_pixel, 'r.', 'MarkerFaceColor','auto', 'MarkerSize',20); hold on; grid on;
errorbar(t_ev', off_FFT * 1000, errFFT * 1000, 'b.', 'MarkerFaceColor','auto', 'MarkerSize',20); hold on; grid on;
title('Offset: DFT'); 
xlabel('Tempo (ms)'); ylabel('Offset (mm)');
legend('Ottico', 'DFT')


figure (2);
l_pixel = 90/838.0; 
sx_lim = errOpt * l_pixel;
sx_lim(1) = 0;

myfit = polyfit(off_FFT * 1000, off_ottici * l_pixel, 1);
fit_offset = regress(off_FFT * 1000, off_ottici * l_pixel);
y_fit = fit_offset * off_ottici * l_pixel;
errorbar(off_ottici * l_pixel, off_FFT * 1000,  sx_lim, errOpt * l_pixel, errFFT * 1000, errFFT * 1000, 'r.', 'MarkerFaceColor','auto', 'MarkerSize',20); hold on; grid on;
plot(off_ottici * l_pixel, y_fit, 'g-', 'LineWidth', 1.5); hold on; grid on;
plot(linspace(0, 9, 100), linspace(0, 9, 100), 'b-', 'LineWidth', 1.5); hold on; grid on;
title('Offset: Ottico vs FFT'); 
xlabel('Analisi immagini (mm)'); ylabel('Analisi segnali (mm)');
legend('Ottico vs FFT', 'Fit lineare', 'Bisettrice')
