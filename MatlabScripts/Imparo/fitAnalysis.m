%-------------------------------------------------------%
%        Script matlab per imparare ad utilizzarlo      %
%-------------------------------------------------------% 

close all % Chiudo tutte le immagini presenti
clear all % "Pulisco" tutte le variabili presenti in memoria
clc % Pulisce lo schermo

% Prendo i dati da file ed inizio ad analizzarli
% NB: gli indici iniziano da 1, non da zero come di norma
data = load("cazdata.txt"); % Matrice con 2 colonne
t = data(:, 1); % Prima colonna sono dei tempi (sintassi stile python, ma senza [])
v = data(:, 2); % Seconda colonna sono delle velocità

[row col] = size(data); 


figure(1)
% Effettuo il plotting di dati (voglio che rimangano visibili duranet script e abbiano griglia)
plot(t, v, 'k.-'); hold on; grid on % Plotto dati contraddistinti da un punto e collegati da linee
ylabel("Velocity (m/s)")    % Label asse y
xlabel("Time (s)")  % Label asse x


figure(2)
% Plotto nuovamente, ma lavoro con smoothing e per effettuare un fit lineare dei dati
vs = movmean(v, 11);  % Medio sui primi 5 vicini in entrambe le direzioni
plot(t, v, '.-', color = 'black'); hold on; grid on   % Plotto dati normali
plot(t, vs, '.-', color = 'green'); hold off;
ylabel("Velocity (m/s)")    % Label asse y
xlabel("Time (s)")  % Label asse x


figure(3)
% Faccio dei subplots per vedere output vicini
% Divido in subplots la figura che utilizzo
% Subplot divide la finestra in tanti plot ed attiva l'utilizzo di quella parte di schermo
% y1 = cos(t); y2 = cos(2*t)/(2+cos(t));  % Definisco due coordinate y, per i due plots
subplot(1,2,1)
plot(t, v, 'r.-'); hold on; grid on;
ylabel("Velocity (m/s)")    % Label asse y
xlabel("Time (s)")  % Label asse x
subplot(1,2,2)
plot(t, v, 'y.-'); hold on; grid on;
ylabel("Velocity (m/s)")    % Label asse y
xlabel("Time (s)")  % Label asse x


figure(4)
% Faccio un fit lineare di quanto sto studiando
coeff = polyfit(t, v, 1);    % Estraggo i coefficienti dal fit: posso specificare il grado del polinomio
fprintf('\n\n') % Per printare a display posso usare due funzioni: disp() e fprintf() per avere una formattazione dell'output 
disp("Effettuo un fit lineare: y = mx +q")
fprintf('\n')
fprintf('Il coefficiente del termine di primo grado è: %f\n', coeff(1))
fprintf('Il coefficiente del termine di grado nullo è: %f\n', coeff(2))
v_fit = polyval(coeff, t); % Creo il polinomio di grado richiesto (lo capisce dal numero di coeff. passati)
plot(t, v, 'b.-'); hold on; grid on     % Dati raw
plot(t, vs, 'y.-'); hold on; grid on    % Dati con smoothing
plot(t, v_fit, 'r-'); hold on; grid on  % Fit lineare
ylabel("Velocity (m/s)")    % Label asse y
xlabel("Time (s)")  % Label asse x

% Per definire un array posso sfruttare una sintassi molto comoda e
% sintetica. Per esempio: x = 0:0.01:10 consente di creare un array con
% valori che vanno da 0 a 10 e che presentano un incremento pari a 0.01

noise = v - v_fit;  % Calcolo il rumore presente sui dati
fprintf('\n\n')
fprintf("Il rumore medio presente sui dati è: %f\n", mean(noise))   % Valore medio
fprintf("La deviazione standard risulta essere: %f\n", std(noise))  % Deviazione standard

% Creo un istogramma che mi consente di andare ad osservare come siano
% distribuiti gli scarti rispetto al valor medio
figure(5)
histogram(noise, 100); hold on; % Devo definire quale sia il numero di bins e fornire in input dei valori da plottare
xlabel('Noise (m/s)')
ylabel('Occurence')
title('Noise distribution function')

% Posso anche effettuare un plot che abbia lo stesso andamento
% dell'istogramma che stiamo prendendo in considerazione. Per fare questo
% dobbiamo comunque determinare quante volte un certo valore di scarto sia
% presente rispetto al valor medio che abbiamo individuato con le
% regressione lineare y = mx + q
[hvaly hvalx] = hist(noise,100);
figure(6)
plot(hvalx, hvaly, 'b.-')
xlabel("Noise (m/s)")
ylabel("Occurrence")
title('Noise distribution function')