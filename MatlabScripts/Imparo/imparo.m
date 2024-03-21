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
disp(row)

figure(1)
% Effettuo il plotting di dati (voglio che rimangano visibili duranet script e abbiano griglia)
plot(t, v, 'k.-'); hold on; grid on % Plotto dati contraddistinti da un punto e collegati da linee


xlabel("Time (s)")  % Label asse x
ylabel("Velocity (m/s)")    % Label asse y
