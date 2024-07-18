%-------------------------------------------------------------------------%
%          CODICE per la stima della temperatura discretizzando           %
%          la cumulativa solo in corrispondenza dei vari gradini          %
%-------------------------------------------------------------------------%

close all
clear all
clc

% Funzione che consente di determinare quale sia il rumore medio da
% sottrarre alla scarica: per fare questo mediamo sui campioni di rumore
% zoom che abbiamo preso in fase di raccolta dati.
function rumSign = signalNoise(path, name, n, udmv)

    rumSign = 0;
    for i=1:n

        % Apro il file, carico i vettori e riscalo opportunamente
        data = fopen([path '/' name sprintf('%02i', i) '.txt'], 'rt');
        N = 3; filescan = textscan(data,'%f %f','HeaderLines',N);
        v = filescan {1,2}; v = - udmv * v;

        % Sommo membro a membro le varie istanze di rumore zoom ottenute in
        % fase di calibrazione
        rumSign = rumSign + v;
    end
    
    % Faccio la media in modo tale da restituire il rumore medio
    rumSign = rumSign/n;
end

% Valuto quale sia il rumore da sottrarre ai segnali di scarica zoomati
path_rum = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 2/Dati/Signals/rumore_zoom_bump/no_off';
v_noise = signalNoise(path_rum, 'segnale', 20, 1e-6);


% Leggo il file che contiene lo zoom della scarica
data = fopen('/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 2/Dati/Signals/scarica_ramp_zoom/no_off/segnale02.txt', 'rt');
N = 3; filescan = textscan(data,'%f %f','HeaderLines',N);
t = filescan {1,1}; v = filescan {1,2}; res = 1e6; qtot = 5.564e-10; cap = 4.393e-10;


vCum = - (v * 1e-3 - v_noise); dt = (t(1350) - t(1340))*1e-6/10;
chCum = zeros(1, 200); vConf = -99.5:0.5:0;

% Calcolo della cumulativa, sfrutto il fatto che i gradini hanno durata di
% due microsecondi per creare un filtro che consenta di valutare la carica
% uscita ad un certo istante di tempo e per un certo valore di potenziale
% confinante
for i=1:200
    chCum(i) = sum(vCum(t < 2*i) * dt/res) + cap * mean(vCum(2 * (i-1) < t & t < 2*i));
end

[vMax, ind] = max(chCum);
vConf = vConf(1:ind); chCum = chCum(1:ind);

% Grafico della funzione cumulativa, per capire se sto facendo delle cose
% sensate o meno
figure;
plot(vConf, chCum/qtot, 'r.', 'MarkerSize', 10); hold on; grid on;
xlabel('Potenziale (V)'); ylabel('Q_e/Q_t'); title('Funzione cumulativa')


% Lavoriamo ora in modo tale da determinare la temperatura del plasma
% prendendo la seguente regione della carica cumulativa [0.5, 3.5]%.
chFit = chCum(0.005 * qtot < chCum & chCum < 0.035 * qtot);
vFit = vConf(0.005 * qtot < chCum & chCum < 0.035 * qtot);

% Faccio il fit lineare nella regione interessata dal fenomeno
myfit = polyfit(vFit, log(chFit/qtot), 1); 
temp = 1/myfit(1);
disp(['La temperatura del plasma è pari a: ' num2str(temp, 4) ' eV'])

figure;
plot(vFit, log(chFit/qtot), 'r.', 'MarkerSize', 10); hold on; grid on;
plot(vFit,  polyval(myfit, vFit), 'g-', 'LineWidth', 2); hold on; grid on;
legend('Discharge', 'Fit'); xlabel('Potenziale (V)'); ylabel('log(Q_e/Q_t)'); title('Stima temperatura')



