%------------------------------------------------------------------------%
%                Calcolo offset facendo l'analisi in FFT                 %
%------------------------------------------------------------------------%
close all
clear all
clc

%sign = [2, 4, 5, 6, 7, 8, 9, 10, 11, 14, 15, 16, 17, 18, 21, 22, 24, 29, 30, 31, 32, 33, 34, 35, 37, 39, 40, 41, 43, 45, 46, 47, 49];
%sign = [2, 3, 4, 6, 8, 9, 11, 12, 13, 14, 15, 16, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 34, 35, 36, 37, 38, 39, 40, 41, 42, 45, 46, 47, 48, 49, 50];
%sign = [1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 42, 43, 45, 46, 47, 48, 49, 50, 51, 52, 53, 56, 57, 58, 59, 60, 61, 62];
%sign = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
%sign = [1, 2, 3, 6, 7, 8, 9, 10, 11];
%sign = [1, 2, 3, 4, 6, 7, 8, 10];
%sign = [1, 2, 4, 5, 6, 7, 8, 9, 10];
%sign = [1, 3, 4, 5, 6, 8, 9, 10];
sign = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];



function fourierOffset(path, nome_serie, sign, liminf, limsup)
    
    % File di output
    base = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Dati/Signals/';
    new_data = fopen(['/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Analisi/Offset/Segnali/' nome_serie],'w');
    fprintf(new_data, '%s \n', 'Nu1       Nu3     Offset');
    

    % Creo il grafico di controllo per vedere se siamo in una regione ad
    % ampiezza circa costante
    data = fopen([base path 'segnale' sprintf('%02i', sign(1)) '.txt'], 'rt');
    N = 3; filescan = textscan(data,'%f %f','HeaderLines',N);
    t = filescan {1,1}; v = filescan {1,2};
    dt = (t(143) - t(142))*0.001;

    % Calcolo la frequenza di campionamento
    fprintf('Frequenza fondamentale di campionamento: %e\n', 1/(dt * length(t(t<limsup & t>liminf))))

    figure(1);
    plot(t(t<limsup & t>liminf), v(t<limsup & t>liminf), 'r-', 'LineWidth',2); hold on; grid on;
    ylim([-max(v)-0.1, max(v) + 0.1]); title('Segnale di controllo FFT'); xlabel('Tempo (ms)'); ylabel('Potenziale (V)')

    % Ciclo solamente sui segnali ripetibili
    for i=sign
        % Leggo segnali
        data = fopen([base path 'segnale' sprintf('%02i', i) '.txt'], 'rt');
        N = 3; filescan = textscan(data,'%f %f','HeaderLines',N);
        t = filescan {1,1}; v = filescan {1,2};
        disp(i)

        %---------------------------------------------%
        %        Applico trasformata di Fourier       %
        %---------------------------------------------%
        dt = (t(143)-t(142))*0.001;
        tfour = t(t<limsup & t>liminf); vfour = v(t<limsup & t>liminf);
        
        M = 2 * ceil(length(vfour)/2);
        fou = fft(vfour, M);
        fou = fou/M;
        power = fou.*conj(fou);

        % Trovo i due massimi relativi e calcolo offset
        frequenze = 0:1/(M * dt):1/(2*dt); amp = sqrt(power(1:length(frequenze)));
        [A1, ind1] = max(amp);
        [A3, ind3] = max(amp(int32(7 * ind1/3) : int32(10 * ind1/3)));
        d1 = (double(A3)/A1)^(0.5);

        % Printo dati a file
        fprintf(new_data,  '%s \n', [num2str(frequenze(ind1)) '    ' num2str(frequenze(ind3 + int32(7 * ind1/3))) '    ' num2str(d1)]);

        if i==sign(length(sign))
            figure(2);
            loglog(frequenze, amp, 'r-', 'LineWidth', 2); hold on; grid on;
            xticks([10 100 1000 10000 100000]); xticklabels({'10^1', '10^2', '10^3', '10^4', '10^5'});
            xlabel('log(f)'); ylabel('log(amp)'); title('Fourier Analysis');
        end
    end
    fclose(new_data);  
end

path = input('Path to working directory: \n');
fileout = input('Nome file_out: \n');
minimo = input('Limite minimo: \n');
massimo = input('Limite massimo: \n');
fourierOffset(path, fileout, sign, minimo, massimo);