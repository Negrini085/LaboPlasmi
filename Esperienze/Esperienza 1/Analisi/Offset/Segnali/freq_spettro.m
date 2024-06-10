%---------------------------------------------------%
%              Calcolo offset con FFT               %
%---------------------------------------------------%

close all
clear all
clc


%--------------------------------------------------%
%        Function to compute FFT amplitudes        %
%--------------------------------------------------%
function power = offset_SpectrumAnalysis(segnale)
    % Calcolo le dimensioni del campione preso in considerazione per l'
    % analisi in FFT e faccio la FFT
    M = 2 * ceil(length(segnale)/2);
    fou = fft(segnale, M);
    
    % Normalizzo e considero il modulo
    fou = fou/M;
    power = fou.*conj(fou);
end



%------------------------------------------------------%
%     Function to test FFT interval we want to use     %
%------------------------------------------------------%
function testIntervalFFT(t, segnale)
    % Calcolo il tempo di sampling
    dt = (t(160)-t(150))/10;

    % Valuto le frequenze caratteristiche di campionamento
    fprintf('PUNTO 1:\n')
    fprintf('Frequenza di Nyquist: %e\n', length(t)/(2*dt))
    fprintf('Frequenza fondamentale di campionamento: %e\n', 1/(dt))
    fprintf('\n')

    % Computing test spectrum analysis
    power = offset_SpectrumAnalysis(t, segnale);
    
    % Computing valuable variables to study spectrum behaviour
    frequenze = 0:10/(t(160)-t(150)):10*length(segnale)/(2 * (t(160) - t(150)));
    ampiezze = sqrt(power(1:length(frequenze)));

    % Primo subplot --> grafico il segnale considerato
    figure; subplot(2, 1, 1);
    plot(t, segnale, 'r-', 'LineWidth',2); hold on; grid on;
    title('Segnale originale'); xlabel('Tempo'); ylabel('Ampiezza');

    % Secondo subplot --> grafico in scala log-log la FFT Analysis
    subplot(2, 1, 2);
    loglog(frequenze, ampiezze, 'b-', 'LineWidth', 2); hold on; grid on;
    title('Analisi FFT'); xlabel('Frequenze (Hz)'); ylabel('Ampiezza');
end



%----------------------------------------------------------%
%   Function to perform actual FFT on our set of signals   %
%----------------------------------------------------------%
function offset_FFT(path, name, sign, limsup, liminf, udmv, udmt)
    
    % File di output
    base = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Dati/Signals/';
    new_data = fopen(['/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Analisi/Offset/Segnali/Serie' name],'w');
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
        t = t * udmt; v = v * udmv;
        dt = (t(143)-t(142));
        vfour = v(t<limsup & t>liminf);
        power = offset_SpectrumAnalysis(vfour);

        %--------------------------------------------%
        %        Trovo i picchi dello spettro        %
        %--------------------------------------------%
        frequenze = 0:1/(M * dt):1/(2*dt); 
        amp = sqrt(power(1:length(frequenze)));
        [A1, ind1] = max(amp);
        [A3, ind3] = max(amp(int32(7 * ind1/3) : int32(10 * ind1/3)));

        % Printo dati a file
        fprintf(new_data,  '%s \n', [num2str(frequenze(ind1)) '    ' A1 '     ' ...
            num2str(frequenze(ind3 + int32(7 * ind1/3))) '    ' A3 '     ']);
    end
    fclose(new_data);  

end


path = input('Path to working directory: \n');
fileout = input('Nome file_out: \n');
minimo = input('Limite minimo: \n');
massimo = input('Limite massimo: \n');
udmt = input('Unità di misura tempo (s): \n');
udmv = input('Unità di misura potenziale (V): \n');
fourierOffset(path, fileout, sign, massimo, minimo, udmv, udmt);