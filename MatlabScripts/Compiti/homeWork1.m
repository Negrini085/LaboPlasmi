%--------------------------------------------------------%
%          Compito uno - Laboratorio di Plasmi 1         %
%--------------------------------------------------------%

close all
clear all
clc

% PUNTO 1 ---> Aprire i files e immagazzinare in memoria
data = fopen("C1Rcdisch00000.txt", 'rt');
%-------------------------------------------------------------------------%
%  Le prime righe non devono essere considerate dato che l'oscilloscopio  %
%  non stampa solamente dati, ma anche delle righe con le specifiche      %
%  dello strumento utilizzato.                                            %
%-------------------------------------------------------------------------%
N = 5; filescan = textscan(data,'%f %f','HeaderLines',N);
t = filescan {1,1}; v = filescan {1,2};

% PUNTO 2 ---> Effettuo il plot
figure(1)
plot(t, v, 'b-'); hold on; grid on;
xlabel('Tempo (s)')
ylabel('Corrente (A)')
title('Dati compito 1')

% PUNTO 3 ---> Faccio smoothing
figure(2)
for i = 1:5
    vs(:,i) = movmean(v, 1+100*i);
end
% Per vedere quale sia il numero migliore di punti per effettuare lo
% smoothing faccio un grafico in modo tale da vedere le varie curve al
% variare del numero di punti presi in considerazione
plot(t, vs(:, 1), 'g-'); hold on; grid on;
plot(t, vs(:, 2), 'r-'); hold on; grid on;
plot(t, vs(:, 3), 'b-'); hold on; grid on;
plot(t, vs(:, 4), 'y-'); hold on; grid on;
plot(t, vs(:, 5), 'k-'); hold on; grid on;
xlabel('Tempo (s)')
ylabel('Corrente (A)')
title('Confronto fra smoothing')
% Decido a livello puramente visivo che il migliore è lo smoothing che
% prende in considerazione 201 dati alla volta. L'intervallo è quindi
% caratterizzato da un'escursione del tipo [-100, 100] centrata nel dato
% preso in considerazione


% PUNTO 4 ---> Trovare il minimo della curva e valutare la discrepanza fra
% i valori appiattiti ed i valori "raw": ne vale la pena oppure perdo
% informazione importante? Per fare questo effettuo un plot della
% discrepanza.
figure(3);
scarto = v(201:end) - vs(201:end, 2);
plot(t(201:end), scarto, 'b-'); hold on; grid on;
xlabel('Tempo (s)')
ylabel('Corrente (A)')
title('Studio dello scarto')

% L'errore che compio è compreso fra i 0.05 e 0.01: non è presente alcuna
% spike nello scarto, marimane circa costante su tutto l'intervallo
% considerato. L'approssimazione può essere corretta in dipendenza dalla
% precisione che noi vogliamo sulla misura stessa.



% Punto 5 ---> Prendo in considerazione l'ultima parte della curva che
% dovrebbe essere relativamente piatta e cerco di comprendere se essa
% rappresenta solo rumore di natura stocastica (come per esempio
% gaussiana), oppure se è presente un fenomeno emergente
appo = v(200000:end);
fprintf('Il valor medio della coda della curva presa in considerazione è: %f\n', mean(appo))
smooth_appo = movmean(appo, 201);

% Effettuo un plot per confrontare noise data con smoothed data: sono
% veramente stato bravo ed ho preso correttamente la coda della curva?
figure(4);
plot(t(200000:end), appo, 'b-'); hold on; grid on;
plot(t(200000:end), smooth_appo, 'k-'); hold on; grid on;
xlabel('Tempo (s)')
ylabel('Corrente (A)')
title('Coda del grafico: raw data vs smoothed')

% Notiamo dal grafico che la sezione presa riguarda una parte del grafico
% che è piatta, tuttavia non presenta valor medio zero. Per studiare come
% siano distribuiti gli errori vado a sottrarre ad i valori raw quelli
% smoothati per riportarmi in una situazione centrata in zero
figure(5)
scarto = appo - smooth_appo;
histogram(scarto, 100);
xlabel('Scarto (A)');
ylabel('Occorrenza');


% PUNTO 6 --> Faccio un grafico semi-logaritmico ponendo una scala
% logaritmica sull'asse delle ordinate
figure(6)
semilogy(t, abs(v), 'k-'); hold on; grid on;
xlabel('Tempo (s)')
ylabel('log(i(t)')
title('Segnale in corrente: scala semilogaritmica')

% La parte di scarica in un grafico in scala semilogaritmica è una retta,
% la cui pendenza è l'inverso del tempo caratteristico del circuito
% resistivo-capacitivo in analisi