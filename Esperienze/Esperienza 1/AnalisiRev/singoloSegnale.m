%-------------------------------------------------------------------------%
%                      ANALISI SUL SINGOLO SEGNALE                        %
%-------------------------------------------------------------------------%

clear all
clc

% DETERMINAZIONE FREQUENZA PRIMA ARMONICA SINGOLO SEGNALE
function res = frequenzaSegnale(t, v, liminf, limsup, udmv, udmt)
        %---------------------------------------------%
        %        Applico trasformata di Fourier       %
        %---------------------------------------------%
        vfour = v(t<limsup & t>liminf);
        t = t * udmt; vfour = vfour * udmv;
        dt = (t(143)-t(142));
        amp = abs(fft(vfour));

        %--------------------------------------------%
        %        Trovo i picchi dello spettro        %
        %--------------------------------------------%
        frequenze = 0:1/(2*ceil(length(vfour)/2)*dt):1/(2*dt); 
        amp = amp(1:length(frequenze));
        [A1, ind1] = max(amp);
        [A3, ind3] = max(amp(int32(44 * ind1/15) : int32(46 * ind1/15)));

        res = frequenze(ind1);
end



% DETERMINAZIONE OFFSET PRIMA ARMONICA SINGOLO SEGNALE
function res = offsetSegnale(t, v, liminf, limsup, udmv, udmt, g)
        %---------------------------------------------%
        %        Applico trasformata di Fourier       %
        %---------------------------------------------%
        vfour = v(t<limsup & t>liminf);
        t = t * udmt; vfour = vfour * udmv;
        dt = (t(143)-t(142));
        amp = abs(fft(vfour));

        %--------------------------------------------%
        %        Trovo i picchi dello spettro        %
        %--------------------------------------------%
        frequenze = 0:1/(2*ceil(length(vfour)/2)*dt):1/(2*dt); 
        amp = amp(1:length(frequenze));
        [A1, ind1] = max(amp);
        [A3, ind3] = max(amp(int32(44 * ind1/15) : int32(46 * ind1/15)));
        
        g1 = g(1) + (frequenze(ind1) - 17000)/1000 * (g(2) - g(1));
        g2 = g(3) + (frequenze(int32(44 * ind1/15) + ind3) - 50000)/1000 * (g(4) - g(3));
        res = sqrt(g1/g2) * A3/A1;
end





% Leggo il segnale
path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Dati/Signals/series2_300ms/segnale22.txt';
data = fopen(path, 'rt');
N = 3; filescan = textscan(data,'%f %f','HeaderLines',N);
t = filescan {1,1}; v = filescan {1,2};

guad = [53.95, 53.1, 29.65, 28.15];
liminf = [79.9, 99.9, 124.9, 154.9, 179.9, 199.9, 229.9, 249.9, 269.9];
limsup = [99.9, 124.9, 149.9, 174.9, 199.9, 224.9, 249.9, 274.9, 299.9];

tGraph = [100, 125, 150, 175, 200, 225, 250, 275, 300];
freqProgrssive = zeros(1, 9);
offProgrssivi = zeros(1, 9);
for i=1:9
    freqProgrssive(i) = frequenzaSegnale(t, v, liminf(i), limsup(i), 1, 0.001);
    offProgrssivi(i) = offsetSegnale(t, v, liminf(i), limsup(i), 1, 0.001, guad);
end


figure;
plot(tGraph, freqProgrssive, 'r.', 'MarkerSize', 20); hold on; grid on;
xlabel('Tempo [ms]'); ylabel('Frequenza [Hz]');

figure;
plot(tGraph, offProgrssivi * 1000, 'r.', 'MarkerSize', 20); hold on; grid on;
xlabel('Tempo [ms]'); ylabel('Offset [mm]');

figure;
plot(offProgrssivi * 1000, freqProgrssive, 'r.', 'MarkerSize', 20); hold on; grid on;
xlabel('Offset [mm]'); ylabel('Frequenza [Hz]');