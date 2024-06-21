%---------------------------------------------------%
%              Calcolo offset con FFT               %
%---------------------------------------------------%

close all
clear all
clc




%--------------------------------------------------%
%        Function to compute FFT amplitudes        %
%--------------------------------------------------%
function power = offset_SpectrumAnalysis(segn)
    % Calcolo le dimensioni del campione preso in considerazione per l'
    % analisi in FFT e faccio la FFT
    M = 2 * ceil(length(segn)/2);
    fou = fft(segn, M);
    
    % Normalizzo e considero il modulo
    fou = fou/M;
    power = fou.*conj(fou);
end



%----------------------------------------------------------%
%   Function to perform actual FFT on our set of signals   %
%----------------------------------------------------------%
function offset_FFT(path, name, sign, limsup, liminf, udmv, udmt)
    
    % File di output
    base = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Dati/Signals/series';
    new_data = fopen(['/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Analisi/Offset/Segnali/Serie/' name],'w');
    fprintf(new_data, '%s \n', 'Nu1     A1      Nu3     A3');
    

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
        vfour = v(t<limsup & t>liminf);
        t = t * udmt; vfour = vfour * udmv;
        dt = (t(143)-t(142));
        fftPow = offset_SpectrumAnalysis(vfour);

        %--------------------------------------------%
        %        Trovo i picchi dello spettro        %
        %--------------------------------------------%
        frequenze = 0:1/(2*ceil(length(vfour)/2)*dt):1/(2*dt); 
        amp = sqrt(fftPow(1:length(frequenze)));
        [A1, ind1] = max(amp);
        [A3, ind3] = max(amp(int32(44 * ind1/15) : int32(46 * ind1/15)));

        % Printo dati a file
        fprintf(new_data,  '%s \n', [num2str(frequenze(ind1)) '    ' num2str(A1) '     ' ...
            num2str(frequenze(ind3 + int32(44 * ind1/15))) '    ' num2str(A3) '     ']);
    end
    fclose(new_data);  

end

%sign = [2, 4, 5, 6, 7, 8, 9, 10, 11, 14, 15, 16, 17, 18, 21, 22, 24, 29, 30, 31, 32, 33, 34, 35, 37, 39, 40, 41, 43, 45, 46, 47, 49];
%sign = [2, 3, 4, 6, 8, 9, 11, 12, 13, 14, 15, 16, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 34, 35, 36, 37, 38, 39, 40, 41, 42, 45, 46, 47, 48, 49, 50];
%sign = [1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 42, 43, 45, 46, 47, 48, 49, 50, 51, 52, 53, 56, 57, 58, 59, 60, 61, 62];
%sign = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
%sign = [1, 2, 3, 6, 7, 8, 9, 10, 11];
%sign = [1, 2, 3, 4, 6, 7, 8, 10];
sign = [1, 2, 4, 5, 6, 7, 8, 9, 10];
%sign = [1, 3, 4, 5, 6, 8, 9, 10];
%sign = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];


path = input('Path to working directory: \n');
fileout = input('Nome file_out: \n');
minimo = input('Limite minimo: \n');
massimo = input('Limite massimo: \n');
udmt = input('Unità di misura tempo (s): \n');
udmv = input('Unità di misura potenziale (V): \n');
offset_FFT(path, fileout, sign, massimo, minimo, udmv, udmt);