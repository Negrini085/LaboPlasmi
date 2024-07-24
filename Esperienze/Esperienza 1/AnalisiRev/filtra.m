%-------------------------------------------------------------------------%
%                 CODICE PER FILTRARE I SEGNALI RIPETIBILI                %
%       Voglio imporre una condizione congiunta su frequenza segnali      %
%         ed offset dalle immagini (voglio sempre coppia che passa)       %
%-------------------------------------------------------------------------%

close all
clear all
clc

% Funzione per calcolare la frequenza di un particolare segnale, in input
% serve il nome dello stesso ed i limiti dell'intervallo per calcolare la
% frequenza
function freq = freqSignal(path, tmin, tmax, udmt, udmv)
        % Leggo il segnale in questione
        data = fopen(path, 'rt');
        N = 3; filescan = textscan(data,'%f %f','HeaderLines',N);
        t = filescan {1,1}; v = filescan {1,2};
        
        % Seleziono la regione desiderata per applicare la trasformata di
        % Fourier
        vfour = v(t<tmax & t>tmin);
        t = t * udmt; vfour = vfour * udmv;
        dt = (t(150)-t(140))/10;
        amp = abs(fft(vfour));

        % Trovo il picco e restituisco la frequenza ad esso associata
        frequenze = 0:1/(2*ceil(length(vfour)/2)*dt):1/(2*dt); 
        amp = amp(1:length(frequenze));
        [A1, ind1] = max(amp);

        freq = frequenze(ind1);
end


% Funzione per determinare l'offset a partire da un immagine di plasma
% scattata con la camera CMOS
function offset = offsetImage(path)
    M = imread(path); 
    M = double(M); [rowm, colm] = size(M);
        
    % Faccio media pesata sull'intensità dei singoli pixel: devo in
    % primo luogo creare una matrice delle ascisse e delle ordinate in
    % modo tale da poter calcolare le coordinate del centro della
    % colonna di plasma
    [X, Y] = meshgrid(linspace(-colm/2, colm/2, colm), linspace(-rowm/2 + 10, rowm/2 + 10, rowm));
    xm = X.*M; ym = Y.*M; col = sum(sum(xm))/sum(sum(M)); row = sum(sum(ym))/sum(sum(M));

    offset = sqrt((row)^2 + (col)^2);
end



% Calcolo le frequenze mediante la FFT ed invece gli offset dalle immagini:
% impongo dei vincoli su entrambe in modo tale da decidere quale scartare e
% quale no, e nel caso procedo a performare le dovute analisi
function res = filtraSegnali(pathSign, pathIm, nmin, nmax, lunghLim, rlim, flim, tmin, tmax, udmt, udmv)
    freqMedia = 0; offsetMedio = 0;
    disp('Calcolo dei valori medi')
    for i=nmin:nmax
        p1 = [pathSign sprintf('%02i', i) '.txt'];
        p2 = [pathIm sprintf('%03i', i) '.tif'];
        
        % Aggiorno frequenze ed offset medi
        freqMedia = freqMedia * (i-1)/i + freqSignal(p1, tmin, tmax, udmt, udmv)/i;
        offsetMedio = offsetMedio * (i-1)/i + offsetImage(p2)/i;
    end

    res = 0; iter = 0;
    
    disp('Determinazione dei segnali ripetibili')
    while length(res) < lunghLim

        conta = 1;
        for i=nmin:nmax
            p1 = [pathSign sprintf('%02i', i) '.txt'];
            p2 = [pathIm sprintf('%03i', i) '.tif'];

            freq = freqSignal(p1, tmin, tmax, udmt, udmv);
            offset = offsetImage(p2);

            cond1 = ((1-(flim + iter * 0.01)) * freqMedia < freq) & (freq < freqMedia * (1 + flim + iter * 0.01));
            cond2 = ((1-(rlim + iter * 0.01)) * offsetMedio < offset) & (offset < offsetMedio * (1 + rlim + iter * 0.01));

            if cond1 && cond2
                res(conta) = i;
                conta = conta + 1;
            end
        end
        iter = iter + 1;
        disp(['Iterazione ' num2str(iter) ': numero segnali ripetibili ' num2str(length(res))])
    end


end

pathIm = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Dati/CAMimages/series9_275ms/plasma';
pathSign = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Dati/Signals/series9_275ms/segnale';
filtrati = filtraSegnali(pathSign, pathIm, 1, 10, 4, 0.10, 0.005, 249.9, 274.9, 0.001, 1)