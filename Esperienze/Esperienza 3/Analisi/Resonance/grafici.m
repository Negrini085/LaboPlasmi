%-------------------------------------------------------------------------%
%              Grafici per l'esperienza dell'auto-risonanza               %
%-------------------------------------------------------------------------%

close all
clear all
clc


% ESEMPIO DI AGGANCIO DELLA COLONNA DI PLASMA: Vpp = 150 mV
path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 3/Dati/Signals/aggancio_150mV/segnale02.txt';
data = fopen(path, 'rt');
N = 3; filescan = textscan(data,'%f %f %f','HeaderLines',N);
t = filescan {1,1}; vSett = filescan {1,2}; vDrive = filescan{1, 3};

% Preparo i segnali al plot
settOff = mean(vSett(1:40000)); driveOff = mean(vDrive(1:40000));
vSett = vSett - settOff; vDrive = vDrive - driveOff;
vSett = smooth(vSett, 100); vDrive = smooth(vDrive, 100); 
vSett =vSett(t<199.9); vDrive = vDrive(t<199.9); t = t(t<199.9);

figure('Renderer', 'painters', 'Position', [10 10 1000 700]);
subplot(3, 1, 1);
plot(t, vSett, 'r-'); hold on; grid on; ylim([-0.25 0.25]);
title('Segnale indotto'); ylabel('Potenziale (V)');

subplot(3, 1, 2);
plot(t, vDrive, 'y-'); hold on; grid on;
title('Forzante'); ylabel('Potenziale (mV)');

subplot(3, 1, 3);
plot(t, vSett, 'r-'); hold on; grid on;
plot(t, vDrive * 1e-3, 'y-'); hold on; grid on;
title('Segnali sovrapposti'); xlabel('Tempo (ms)'); ylabel('Potenziale (V)');



% ESEMPIO DI MANCATO AGGANCIO DELLA COLONNA DI PLASMA: Vpp = 100 mV
path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 3/Dati/Signals/no_aggancio_100mV/segnale02.txt';
data = fopen(path, 'rt');
N = 3; filescan = textscan(data,'%f %f %f','HeaderLines',N);
t = filescan {1,1}; vSett = filescan {1,2}; vDrive = filescan{1, 3};

% Preparo i segnali al plot
settOff = mean(vSett(1:40000)); driveOff = mean(vDrive(1:40000));
vSett = vSett - settOff; vDrive = vDrive - driveOff;
vSett = smooth(vSett, 100); vDrive = smooth(vDrive, 100); 
vSett =vSett(t<199.9); vDrive = vDrive(t<199.9); t = t(t<199.9);

figure('Renderer', 'painters', 'Position', [10 10 1000 700]);
subplot(3, 1, 1);
plot(t, vSett, 'r-'); hold on; grid on; ylim([-0.25 0.25]);
title('Segnale indotto'); ylabel('Potenziale (V)');

subplot(3, 1, 2);
plot(t, vDrive, 'y-'); hold on; grid on;
title('Forzante'); ylabel('Potenziale (mV)');

subplot(3, 1, 3);
plot(t, vSett, 'r-'); hold on; grid on;
plot(t, vDrive * 1e-3, 'y-'); hold on; grid on;
title('Segnali sovrapposti'); xlabel('Tempo (ms)'); ylabel('Potenziale (V)');
