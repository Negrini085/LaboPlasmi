%-------------------------------------------------------------------------%
%          Determinazione delle frequenze per i segnali ripetibili        %
%-------------------------------------------------------------------------%
close all
clear all
clc


%----------------------------------------------------------%
%   Function to perform actual FFT on our set of signals   %
%----------------------------------------------------------%
function offset_FFT(path, name, sign, limsup, liminf, udmv, udmt)
    
    % File di output
    base = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Dati/Signals/series';
    new_data = fopen(['/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/AnalisiRev/Frequenze/Risultati/Segnali/' name],'w');
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
        amp = abs(fft(vfour));

        %--------------------------------------------%
        %        Trovo i picchi dello spettro        %
        %--------------------------------------------%
        frequenze = 0:1/(2*ceil(length(vfour)/2)*dt):1/(2*dt); 
        amp = amp(1:length(frequenze));
        [A1, ind1] = max(amp);
        [A3, ind3] = max(amp(int32(44 * ind1/15) : int32(46 * ind1/15)));

        % Printo dati a file
        fprintf(new_data,  '%s \n', [num2str(frequenze(ind1)) '    ' num2str(A1) '     ' ...
            num2str(frequenze(ind3 + int32(44 * ind1/15))) '    ' num2str(A3) '     ']);
    end
    fclose(new_data);  

end

%sign = [6, 7, 9, 12, 17, 19, 22, 23, 24, 25, 29, 32, 38, 39, 42, 43, 44];
%sign = [4, 6, 9, 12, 14, 19, 22, 24, 25, 26, 27, 29, 31, 34, 35, 36, 39, 44, 49];
%sign = [2, 9, 14, 18, 22, 24, 25, 28, 31, 35, 36, 38, 40, 41, 43, 44, 46, 49, 50, 51, 52, 60];
%sign = [5, 6, 8, 10, 11];
%sign = [4, 5, 6, 11];
%sign = [1, 6, 8, 9];
%sign = [1, 4, 6, 9];
%sign = [2, 3, 4, 10];
%sign = [1, 2, 5, 8];


path = input('Path to working directory: \n');
fileout = input('Nome file_out: \n');
minimo = input('Limite minimo: \n');
massimo = input('Limite massimo: \n');
udmt = input('Unità di misura tempo (s): \n');
udmv = input('Unità di misura potenziale (V): \n');
offset_FFT(path, fileout, sign, massimo, minimo, udmv, udmt);