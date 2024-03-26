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
histogram(scarto, 40,'Normalization', 'probability'); hold on;
xlabel('Scarto (m/s)')
ylabel('Occorrenza')
title('Error distribution')

% Faccio il fit con una funzione