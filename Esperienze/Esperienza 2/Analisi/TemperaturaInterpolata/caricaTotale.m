%-------------------------------------------------------------------------%
%              Codice per calcolare la carica totale uscita               %
%-------------------------------------------------------------------------%

close all
clear all
clc

% Funzione per determinare la carica totale fuoriuscita durante la scarica:
% per fare questo integriamo la totalità del segnale in corrente (che si 
% ottiene da quello in potenziale dividendo per la resistenza) e sommiamo 
% poi il termine ancora legato a fenomeni capacitivi parassiti. Prima di
% fare questo è però necessario valutare se il segnale è offsetato oppure
% no mediando i primi 100 valori di potenziale e sottraendo tale valore a
% tutta la scarica, in modo da ridurre questo possibile bias.
function car = car_tot(path, chOut, name, n_sc, cap, udmt, udmv)

    % File per contenere i dati elaborati
    new_data = fopen(chOut,'w');
    fprintf(new_data, '%s \n', 'Numero segnale     Carica elettronica');

    car = zeros(n_sc, 1);
    for i=1:n_sc

        % Apro il file, carico i vettori e riscalo opportunamente
        data = fopen([path '/' name sprintf('%02i', i) '.txt'], 'rt');
        N = 3; filescan = textscan(data,'%f %f','HeaderLines',N);
        t = filescan {1,1}; v = filescan {1,2}; t = udmt * t; v = - udmv * v;

        % Effettuo smoothing del segnale
        v_smooth = smooth(v, 100);
        
        % Valuto quanto valga l'offset del segnale (per fare questo
        % considero il valor medio delle prime 1000 celle del segnale e lo
        % sottraggo a tutta la successiva scarica
        offset = mean(v_smooth(1:1001));
        v_smooth = v_smooth - offset;
        
        % Calcolo la carica costituente il segnale: devo considerare due
        % contributi. Il primo è l'integrale della corrente passante per
        % l'oscilloscopio: tale valore deve essere corretto per il
        % potenziale rimanente (valutato come media degli ultimi 100 valori
        % presi) moltiplicato per la capacità parassita presente nel
        % circuito.

        dt = (t(35133) - t(35122))/10; res  = 1e6;
        car(i) = sum(v_smooth) * dt/res + mean(v_smooth(end-100:end)) * cap;
        fprintf(new_data,  '%s \n', [num2str(i) '    ' num2str(car(i))]);

    end
end


% Calcolo della carica totale del segnale
base = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 2/Dati/Signals/scarica_ramp_totale/no_off';
output = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 2/Analisi/StudioTemperatura/Risultati/caricaTotale.txt';
disp('Effettuo lo studio della carica totale del segnale:')
car = car_tot(base, output, 'segnale', 20, 4.393e-10, 1e-6, 1);

disp(' ')
disp(['     La carica totale espulsa risulta essere pari a: -(' num2str(mean(car), 4) ' +/-' num2str(std(car), 4) ') C'])
disp('     La carica totale dei singoli segnali è accessibile nel file: Risultati/caricaTotale.txt')
disp(' ')