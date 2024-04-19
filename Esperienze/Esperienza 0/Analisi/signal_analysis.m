%---------------------------------------------------------------%
%             Analisi dei segnali dell'oscilloscopio            %
%---------------------------------------------------------------%

close all
clear all
clc

% Questo script è pensato per analizzare i segnali legati alla scarica
% degli ioni e alla scarica del plasma di elettroni: inizio in primo luogo
% a valutare la carica ionica in modo da tenerne conto durante il processo
% di scarica ed ottenere dei risultati veritieri





%---------------------------------------------------------------%
%                  VALORE DELLA CARICA IONICA                   %
%---------------------------------------------------------------%


% PUNTO 1 ---> Valuto l'offset totale del segnale per andare a correggere
%              eventuali sistematiche nella stima del potenziale e della
%              scarica: per fare questo medio sui 33 segnali di scarica
%              ionica che abbiamo preso in considerazione.
path = ''; offset_ionsig = 0.0; dim = 0;
for i=1:33
    if i < 10
        path = ['/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 0/Dati/Signals/ion_discharge/cdisch/cdisch_0' num2str(i) '.txt'];
    else
        path = ['/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 0/Dati/Signals/ion_discharge/cdisch/cdisch_' num2str(i) '.txt'];
    end
    data = fopen(path, 'rt');
    N = 3; filescan = textscan(data,'%f %f','HeaderLines',N);
    t = filescan {1,1}; v = filescan {1,2}; dim = length(v);
    % Valuto la media tenedo in considerazione quanto accade prima che
    % avvenga la scarica: dovrei avere una quantità identicamente pari a
    % zero, ma è effettivamente così??

    offset_ionsig = offset_ionsig * (i - 1)/double(i) + mean(v(1:36000))/double(i);
end

disp("L'offset globale del segnale risulta essere pari a: " + num2str(offset_ionsig, 6))

% Creo vettore di offset: serve per poterci riportare in una situazione che
% non sia affetta da eccessive sistematiche
v_offset = zeros(dim, 1);
for i=1:length(v_offset)
    v_offset(i, 1) = offset_ionsig;
end


% PUNTO 2 ---> Sottraggo l'offset globale del segnale e effettuo uno studio
%              per determinare su quanti punti adiacenti fare lo smoothing:
%              questo lo faccio su un solo grafico della scarica, poichè
%              grazie alla riproducibilità del plasma sarà un ragionamento
%              applicabile ad una qualsiasi scarica effettuata.

path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 0/Dati/Signals/ion_discharge/cdisch/cdisch_09.txt';
data = fopen(path, 'rt');
N = 3; filescan = textscan(data,'%f %f','HeaderLines',N);
t = filescan {1,1}; v = filescan {1,2}; v = v - v_offset;

% Creo un contenitore che mi consenta di fare un plot per studiare quale
% sia il numero ottimale di punti da prendere per effettuare uno smoothing
% del segnale

scelta_smooth = zeros(5, length(v));
for m=1:5
    Navg = m * 50 + 1;      % Scelgo a runtime il numero di punti da considerare per lo smooth
    scelta_smooth(m, :) = smooth(v,Navg);
end

plot(t, v, 'k-'); hold on; grid on;
plot(t, scelta_smooth(1, :), 'r-'); hold on; grid on;
plot(t, scelta_smooth(2, :), 'g-'); hold on; grid on;
plot(t, scelta_smooth(3, :), 'b-'); hold on; grid on;
plot(t, scelta_smooth(4, :), 'c-'); hold on; grid on;
plot(t, scelta_smooth(5, :), 'y-'); hold on; grid on;
legend('Data', 'N = 50', 'N = 100', 'N = 150', 'N = 200', 'N = 250')
xlabel('Tempo (ms)'); ylabel('Potenziale (V)'); title('Confronto fra smoothing')

% Decido di lavorare con un numero di punti pari a 100 per effettuare lo
% smoothing: il segnale lisciato sarà memorizzato nella variabile v_smooth
vsign_max = zeros(31, 1); capacity = zeros(31, 1); Navg = 100; res = 1e6;
car_ioni = zeros(31, 1);

for i=1:33
    if i ~= 10 && i ~= 31    % Scarto 10 e 31 perchè hanno valore massimo netttamente inferiore (sistematiche??)
        if i < 10
            path = ['/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 0/Dati/Signals/ion_discharge/cdisch/cdisch_0' num2str(i) '.txt'];
        else
            path = ['/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 0/Dati/Signals/ion_discharge/cdisch/cdisch_' num2str(i) '.txt'];
        end
        data = fopen(path, 'rt');
        N = 3; filescan = textscan(data,'%f %f','HeaderLines',N);
        t = filescan {1,1}; v = filescan {1,2}; dim = length(v);

        v_smooth = smooth(v, Navg);
        [vsign_max(i) ind] = max(v_smooth);
        vsign_max(i) = 0.001* vsign_max(i);

        % Effettuo fit esponenziale per la determinazione del tempo
        % caratteristico del decadimento da cui ricavare la capacità e di
        % conseguenza la carica degli ioni intrappolati
        myfit = fit(0.001* t(ind:70000), 0.001* v_smooth(ind:70000), 'exp1', 'Start', [-2.5, 200]); 
        myfit_coeff = coeffvalues(myfit);
        capacity(i) = -1.0/(myfit_coeff(2) * res);
        
        % Valuto l'integrale della corrente per poter determinare quale sia
        % la carica degli ioni positivi intrappolati nelle regioni in cui è
        % presente il potenziale delimitante: parto dallo 0 (inizio della 
        % scarica) fino a dove ho effettuato il fit esponenziale - Mi
        % ricordo di come il tempo sia fornito in millisecondi e l'ampiezza
        % del segnale in millivolt
        appo = 0;
        delta_t = (t(39150) - t(39149)) * 0.001 * 0.001;
        car_ioni(i) = sum(v_smooth(39500:70000))/res * delta_t;

        % Effettuo una correzione che mi consenta di tenere conto del
        % potenziale rimanente
        v_rim = 0.001 * mean(v_smooth(70000:end));
        car_ioni(i) = car_ioni(i) + v_rim * capacity(i);
    end
end

fprintf('\n')
fprintf('La carica media della popolazione ionica è pari a: %e\n', mean(car_ioni))




