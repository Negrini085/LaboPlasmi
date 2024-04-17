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