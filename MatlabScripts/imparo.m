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
x = data(:, 2); % Seconda colonna sono delle posizioni
