close all
clear all
clc

%----------------------------------------------------------%
%        Codice per effettuare l'analisi di segnali        %
%----------------------------------------------------------%

% In questo Matlab script saranno presenti alcune metodologie che
% consentono l'analisi di segnali prodotti da oscilloscopi (utile durante il
% corso per determinare OffSets e altre grandezze caratteristiche del plasma)


%-------------------------------------%
%     Sovrapposizione di segnali      %
%-------------------------------------%
figure(1)
omega = 1.6; t = 0:0.01:20;
y1 = sin(omega * t); y2 = sin(2 * omega * t); y_tot = y1 + y2;
plot(t, y1, 'b-'); hold on; grid on;
plot(t, y2, 'r-'); hold on; grid on;
plot(t, y_tot, 'k-', 'LineWidth',2); hold on; grid on;  % Specifico la dimensione della riga
xlabel("Tempo (s)")
ylabel("Posizione (m)")
title("Sovrapposizione di segnali")


%-------------------------------------%
%     Metodo fancy per sovrapporre    %
%-------------------------------------%
figure(2)
for m = 1:5     % Effettuo un ciclo for (indice va da 1 a 5 incluso -> avrò 5 iterazioni)
    y(:, m) = sin(m * omega * t);
    plot(t, y(:, m), 'b-'); hold on; grid on;
end     % Nella sintassi di Matlab per terminare l'esecuzione di un ciclo for si utilizza la keyword "end"
ysum = sum(y'); % Sommo insieme i 5 segnali per avere quello risultante: la funzione sum mi fa perdere una dimensione
% Passo da una matrice ad un vettore condensando le colonne in una sola
% avendo come valore la somma di quelli presenti nelle colonne di partenza
% NB: devo trasporre per avere che venga rispettata la dimensione per i
% plot. La trasposizione è: y' con l'apostrofo che indica appunto tale
% operazione.
plot(t, ysum, 'k-', 'LineWidth',2); hold on; grid on;
xlabel("Tempo (s)")
ylabel("Posizione(m)")
title("Segnale risultante: metodo fancy")