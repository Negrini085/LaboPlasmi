%--------------------------------------------------%
%                    Compito 2                     %
%--------------------------------------------------%

close all
clear all
clc

% PUNTO 1 ---> Lavoro con i dati in cazdata, faccio un fit lineare e studio
% il rumore presente. Provo ad effettuare un fit con il comando fit
data = load('cazdata.txt'); t = data(:, 1); v = data(:, 2);
coeff = polyfit(t, v, 1); fit =  polyval(coeff, t); scarto = v - fit;

fprintf('Il coefficiente angolare del fit effettuato è: %f\n', coeff(1))
fprintf("L'intercetta della retta che meglio fitta i dati è: %f\n", coeff(2))

% Creo un grafico in cui confronto i dati raw con il fit e faccio vedere
% anche come si comportano gli scarti, ossia come si distribuiscono
figure(1)
subplot(1, 2, 1)
plot(t, v, 'g-'); hold on; grid on;
plot(t, fit, 'r-'); hold on; grid on;
xlabel('Tempo (s)')
ylabel('Velocità (m/s)')
title('Raw data & Fit')
subplot(1, 2, 2)
histogram(scarto, 40,'Normalization', 'pdf'); hold on;
xlabel('Scarto (m/s)')
ylabel('Occorrenza')
title('Error distribution')

% Faccio il fit con una funzione per valutare la distribuzione del rumore:
% lavoriamo con una curva gaussiana.
[mean,stddev] = normfit(scarto);
prob = normpdf(scarto,mean,stddev);
plot(scarto,prob,'r.'); hold on; grid on;
fprintf('\n')
fprintf('Il valore medio della gaussiana con cui è stato effettuato il fit è: %f\n', mean)
fprintf('La deviazione standard della gaussiana con cui è stato effettuato il fit è: %f\n', stddev)
legend('Dati' , ['Av: ' num2str(mean) ' DS: ' num2str(stddev)])



% PUNTO 2 ---> Utilizzare il segnale di scarica per calcolare la carica
% totale e confrontare tre metodologie:
%       1 --> Appox. Vmax * Capacità
%       2 --> Integrale del segnale di scarica (fino alla fine)
%       3 --> Metodo più completo, tenendo conto anche del potenziale
%             resido
%
% Possibili problematiche sono l'offset (dovrei valutarlo prima del segnale
% ma ho come il presentimento che nel file che sto prendendo in considerazione
% non ci sia), presenza di rumore (con conseguente necessità di smoothing)
% e poi la corretta determinazione della capacità. Per determinare la
% capacità posso proseguire in due modi diversi: in un caso posso pensare
% di fittare un'esponenziale alla parte di scarica vera e propria,
% altrimenti posso prima passare in scala semilogaritmica e poi efettuare
% un fit lineare, sapendo che la resistenza è: R = 1 MOhm

data = fopen("C1Rcdisch00000.txt", 'rt');
N = 5; filescan = textscan(data,'%f %f','HeaderLines',N);
t = filescan {1,1}; v = - filescan {1,2};

% Effettuo un plot per vedere le caratteristiche del segnale: effettuo uno
% smoothing sui primi 200 vicini in modo tale da avere un segnale liscio ed
% individuo il massimo del segnale che stiamo prendendo in considerazione
figure(2)
subplot(3, 1, 1)
v_smooth = movmean(v, 201);
plot(t,v, 'g-'); hold on; grid on;
plot(t,v_smooth, 'r-', 'LineWidth', 2); hold on; grid on;
legend('Raw', 'Smoothed'); xlabel('Tempo(s)'); ylabel('|V|'); title('Scarica plasma: raw vs smooth');

subplot(3, 1, 2)
plot(t(200000:end),v(200000:end), 'g-'); hold on; grid on;
plot(t(200000:end),v_smooth(200000:end), 'r-', 'LineWidth', 2); hold on; grid on;
legend('Raw', 'Smoothed'); xlabel('Tempo(s)'); ylabel('|V|'); title('Scarica plasma: regione piatta');

subplot(3, 1, 3)
% Ottengo la corrente passante per il circuito sfruttando la definizione di
% resistenza, ossia come rapporto fra differenza di potenziale e corrente
% passante
res = 1e6;
corr = v./res;
corr_smooth = movmean(corr, 201);
plot(t, corr, 'g-'); hold on; grid on;
plot(t, corr_smooth, 'r-', 'LineWidth', 2); hold on; grid on;
legend('Raw', 'Smoothed'); xlabel('Tempo(s)'); ylabel('Corrente (A)'); title('Scarica plasma: segnale in corrente')


% Individuo quali siano il massimo del potenziale ed il potenziale residuo
% al termine del processo di scarica. Per determinare se sto considerando
% una regione piatta del grafico stampo a file gli ultimi N dati (con N 
% scelto in modo tale che non vada al di fuori di questa regione).
res_V = 0;
for m = 1:(length(v_smooth(200000:end))-1)
    res_V = res_V * (m-1)/double(m) + v_smooth(200000 + m)/double(m);
end
[max_V ind_max] = max(v_smooth); 

fprintf('\n')
fprintf('Il potenziale massimo risulta essere pari a: %f\n', max_V)
fprintf('Il potenziale residuo risulta essere pari a: %f\n', res_V)

% Effettuo i due fit per aver una stima sull'entità della capacità presente
% nel circuito RC necessario per l'analisi del segnale in uscita
figure(3)
subplot(2, 1, 1)
%plot(t(,)
subplot(2, 1, 2)