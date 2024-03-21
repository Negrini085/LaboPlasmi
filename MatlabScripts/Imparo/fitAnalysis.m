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
coeff = polyfit(t, v, 1)    % Estraggo i coefficienti dal fit: posso specificare il grado del polinomio
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


