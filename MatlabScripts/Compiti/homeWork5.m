%--------------------------------------------------------%
%        Compito cinque - Laboratorio di Plasmi 1        %
%--------------------------------------------------------%

close all
clear all
clc

% Utilizzo matlab per fare l'analisi di Fourier discreta di un segnale che
% presente due contributi in frequenza

% Intervallo temporale: intervallo di campionamento, tempo totale e array
dt = 1e-6; T = 0.1; t = 0:dt:T;
% Numero di punti per il campionamento
N = length(t);

% Valuto frequenze caratteristiche del campionamento
fprintf('PUNTO 1:\n')
fprintf('Frequenza di Nyquist: %e\n', N/(2*T))
fprintf('Frequenza fondamentale di campionamento: %e\n', 1/(T))
fprintf('\n')

% Introduco le frequenze per la costruzione del segnale 
w1 = 2 * pi * 4e3;
w2 = 2 * pi * 12e3;
segnale = sin(w1 * t) + sin(w2 * t);

% Faccio l'analisi di Fourier discreta lavorando con la funzionalità fft di
% matlab, che effettua la fast fourier transform del segnale di input. I
% parametri sono:
%       - segnale
%       - numero di punti costituenti il segnale (fornisco un valore pari)
M = 2 * ceil(length(segnale)/2);
fou = fft(segnale, M);

% Per rendere l'ampiezza dello spettro indipendente dal sampling
% effettuato, è necessario normalizzare sul numero di punti presi in
% considerazione per la ricostruzione del segnale
fou = fou/M;

% Valuto il quadrato dell'ampiezza della trasformata andando ad effettuare
% una moltiplicazione per il complesso coniugato dei valori restituiti
% dalla fft
power = fou.*conj(fou);

% Plot di partenza: è quello che va migliorato seguendo le istruzioni
% dell'homeWork
figure; 
plot(power); hold on; grid on
xlabel('Frequenza (Hz)'); ylabel('Potenza'); title('Fourier Analysis: grafico di partenza'); 



% PUNTO 1 ---> Usare scale semi-logaritmiche e logaritmiche per avere una
% miglior percezione dell'effettivo plot, troncare il ramo ridondante e
% trovare il valore del massimo e la relativa frequenza
frequenze = 0:1/T:N/(2*T);
ampiezze = sqrt(power(1:length(frequenze)));

figure;
% Primo subplot ==> lavoro con la scala semi-logaritmica posta solo
%                   sull'asse x
subplot(1, 2, 1);
semilogx(frequenze, ampiezze, 'b-', 'LineWidth', 2); hold on; grid on;
xticks([10 100 1000 10000 100000]); xticklabels({'10^1', '10^2', '10^3', '10^4', '10^5'});
xlabel('log10(f)'); ylabel('Ampiezza'); title('Scala semi-logaritmica'); 
% Secondo subplot ==> lavoro con scala logaritmica, ossia vado a plottare
%                     il grafico loglog
subplot(1, 2, 2);
loglog(frequenze, ampiezze, 'r-', 'LineWidth', 2); hold on; grid on;
xticks([10 100 1000 10000 100000]); xticklabels({'10^1', '10^2', '10^3', '10^4', '10^5'});
xlabel('log(f)'); ylabel('log(amp)'); title('Fourier Analysis');

% Cerco ora il massimo e la frequenza a cui tale valore viene raggiunta:
% per fare questo è necessario valutare l'indice della cella di memoria
% ospitante il dato richiesto
[val ind] = max(ampiezze);
fprintf('Il massimo contributo allo spettro è dato dalla frequenza: %f\n', frequenze(ind));

clear all

% PUNTO 2 ---> Fare la trasformata di Fourier del modo realistico con l=1 e
% studiare cosa cambia al variare dei parametri caratteristici del segnale
% considerato
nu = 40;
dt = 1e-4; T = 0.4; t = 0:dt:T;
modi = zeros(5, length(t)); somma = zeros(1, length(t));

for m = 1:5
    modi(m, :) = (1/m) * sin(2 * pi * m * nu * t);
    somma = somma + modi(m, :);
end

figure;
subplot(2, 1, 1)
plot(t, modi(1, :), 'k-'); hold on; grid on;
plot(t, modi(2, :), 'g-'); hold on; grid on;
plot(t, modi(3, :), 'b-'); hold on; grid on;
plot(t, modi(4, :), 'y-'); hold on; grid on;
plot(t, modi(5, :), 'c-'); hold on; grid on;
plot(t, somma, 'r-', 'LineWidth', 2); hold on; grid on;
xlabel('Tempo (s)'); ylabel('Ampiezza'); title('Segnale');
legend('Modo 1', 'Modo 2', 'Modo 3', 'Modo 4', 'Modo 5', 'Somma');

% Effettuo analisi di fourier del segnale appena costruito artificialmente:
% mi aspetto 5 picchi in corrispondenza delle varie frequenze che
% caratterizzano il segnale
M = 2 * ceil(length(t)/2);
fprintf('\n\nPUNTO 2:\n')
fprintf('Frequenza di Nyquist: %e\n', M/(2*T))
fprintf('Frequenza fondamentale di campionamento: %e\n', 1/(T))
fprintf('\n')

% Effettuo l'analisi di Fourier con la normalizzazione necessaria per avere
% delle "ampiezze" indipendenti dal sampling effettuato
fou = fft(somma, M);
fou = fou/M;
pow = fou.*conj(fou);
frequenze = 0:1/T:M/(2*T);

subplot(2, 1, 2)
loglog(frequenze, sqrt(pow(1:length(frequenze))), 'r-', 'LineWidth', 2); hold on; grid on;
xlabel('log(f)'); ylabel('log(amp)'); title('Fourier Analysis');



% PUNTO 3 ---> Creare un segnale con una componente di frequenza oltre a
% quella dei limiti di Nyquist-Shannon e controllare per fenomeni di alias
clear all

dt = 1e-3; T = 1; t = 0:dt:T;
nu1 = 300; nu2 = 600;

% Costruisco il segnale con una componente in frequenza a 300 Hz, mentre la
% seconda a 600 Hz in modo tale da testare i fenomeni di alias predetti
% dalla teoria di Nyquist e Shannon
y = sin(2 * pi * nu1 * t) + sin(2 * pi * nu2 * t);
M = 2 * ceil(length(y)/2);

% Effettuo analisi di Fourier
fou = fft(y, M); fou = fou/M; pow = fou.*conj(fou);


% Faccio i plot necessari, andando a costruire l'asse delle frequenze per
% poter ottenere delle informazioni più complete
frequenze = 0:1/T:M/(2*T);
figure;
% Plotto segnale
subplot(2, 1, 1);
plot(t, sin(2 * pi * nu1 * t), 'g-'); hold on; grid on;
plot(t, sin(2 * pi * nu2 * t), 'c-'); hold on; grid on;
plot(t, y, 'r-', 'LineWidth', 2); hold on; grid on;
xlabel('Tempo (s)'); ylabel('Ampiezza'); title('Segnale');
legend('f = 300 Hz', 'f = 600 Hz', 'Segnale risultante');
% Plotto studio con Fourier
subplot(2, 1, 2);
loglog(frequenze, sqrt(pow(1:length(frequenze))), 'r-', 'LineWidth', 2); hold on; grid on;
xlabel('log(f)'); ylabel('log(amp)'); title('Fourier Analysis');