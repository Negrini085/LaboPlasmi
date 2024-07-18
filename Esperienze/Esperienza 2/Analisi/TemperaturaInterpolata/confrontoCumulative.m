%-------------------------------------------------------------------------%
%               Metodo per confrontare le cumulative per                  %
%           l'analisi dati della temperatura, potrebbe essere             %
%               presente un bug bello problematico                        %
%-------------------------------------------------------------------------%

close all
clear all
clc

% Il test lo faccio con la cumulativa per il segnale totale: dato che viene
% scaricato tutto il plasma ci aspettiamo che la cumulativa stessa saturi
% ad uno, poichè la carica espulsa deve coincidere con quella del plasma


% PRIMO METODO --> UTILIZZATO IN PRECEDENZA
data = fopen('/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 2/Dati/Signals/scarica_ramp_totale/no_off/segnale02.txt', 'rt');
N = 3; filescan = textscan(data,'%f %f','HeaderLines',N);
t = filescan {1,1}; v = filescan {1,2}; t = t * 1e-6; v = -v; v(v<0) = 0;
res = 1e6; cap = 4.393e-10; qtot = 5.564e-10; dt = (t(130)-t(120))/10;

% Valuto il rumore come il valor medio 
rum = mean(v(t<0));
% Considero solamente la regione dopo il trigger
tCum = t(t>0); vCum = v(v>0) - rum;

% Valuto quale sia la cumulativa con il metodo che utilizzavo in precedenza
chCum = cumsum(vCum * dt/res) + vCum * cap;
[vMax, ind] = max(vCum);

chCum = chCum(1:ind); tCum = tCum(1:ind); en = -100 + 0.5/2e-6 * tCum;

figure;
plot(en, chCum/qtot, 'r-'); hold on; grid on;
xlabel('Potenziale (V)'); ylabel('Q_e/Q_t'); title('Metodo 1')




% SECONDO METODO --> PROPOSTO PER AVERE RISULTATI CORRETTI

% Valuto il rumore come il valor medio 
rum = mean(v(t<0));
% Considero solamente la regione dopo il trigger
tCum1 = t(t>0); vCum1 = v(v>0) - rum;

% Valuto quale sia la cumulativa con il metodo che utilizzavo in precedenza
chCum1 = cumsum(vCum1 * dt/res);
for i=2:length(chCum)
    chCum1(i) = chCum1(i) + cap * (vCum1(i) - vCum1(i-1));
end
[vMax, ind] = max(vCum1);

chCum1 = chCum1(1:ind); tCum1 = tCum1(1:ind); en = -100 + 0.5/2e-6 * tCum1;

figure;
plot(en, chCum1/qtot, 'r-'); hold on; grid on;
xlabel('Potenziale (V)'); ylabel('Q_e/Q_t'); title('Metodo 2')







