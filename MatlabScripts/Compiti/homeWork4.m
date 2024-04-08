%--------------------------------------------------%
%                    Compito 4                     %
%--------------------------------------------------%

close all
clear all
clc

% L'obiettivo di questo script di matlab è ricostruire il segnale in
% frequenza dovuto ad un modo uno di diocotron in modo tale da avere
% un'idea più o meno quantitativa di quanto troveremo in laboratorio

% Per risolvere questa problematica lavoriamo con dei valori che sono
% realistici, in modo tale da riprodurre al meglio le condizioni di labo:
%
%       B = 0.1 T, n = 1e7 cm^-3, Rp/Rw = 0.2, Lp = 80 cm, Rw = 45 mm,
%       D/Rw = 0.1, 0.4, 0.7
%

% Faccio i dovuti cambi di unità di misura ed effettuo i calcoli
% propedeutici alla ricostruzione del segnale di corrente indotta

% Costanti necessarie per il calcolo della corrente indotta
epsilon_0 = 8.854187817e-12; q_e = 1.602176634e-19;

% Quantità per riproduzione realistica
B = 0.1; Rw = 0.045; Lp = 0.8; Rp = 0.2 * Rw; Ls = 0.15;
dens = 1e13; lambda = q_e * dens * pi * Rp^2; dalpha = pi; 


%++++++++++++++++++++++++++++++++++++++++++++++%
%          Span del settore: pi greco          %
%++++++++++++++++++++++++++++++++++++++++++++++%

% Ciclo esterno per tenere conto dei tre possibili posizionamenti spaziali
% del plasma
for i=0:2
    % Determino l'offset della colonna di plasma e calcolo la frequenza
    % omega1 del primo modo di diocotron
    D = (0.1 + 0.3 * i) * Rw;
    omega1 = lambda/((2 * pi * epsilon_0 * B * Rw^2)*(1 - (D/Rw)^2));
    T = 2 * pi/omega1;
    signal = zeros(1, 150000);
    t = linspace(0, 3 * T, 150000);
    
    % Ciclo interno per ricostruire la corrente indotta sul settore a causa
    % del posizionamento della colonna di plasma
    modi = zeros(3, 150000);
    for m=1:20
        if m < 4
            modi(m, :) = 2 * (lambda * Ls/pi) * sin(m * dalpha/2) * (D/Rw)^m * omega1 * sin(m * omega1 * t);
        end
        signal = signal + 2 * (lambda * Ls/pi) * sin(m * dalpha/2) * (D/Rw)^m * omega1 * sin(m * omega1 * t);
    end
    
    figure;
    plot(t, modi(1, :), 'g-'); hold on; grid on;
    plot(t, modi(2, :), 'b-'); hold on; grid on;
    plot(t, modi(3, :), 'k-'); hold on; grid on;
    plot(t, signal, 'r-', 'LineWidth', 2); hold on; grid on;
    xlabel('Tempo'); ylabel('Corrente indotta'); title(['Sector span: pi, D/Rw = ' num2str(D/Rw, 2)])
    legend('Mode 1', 'Mode 2', 'Mode 3', 'Somma')

end



%++++++++++++++++++++++++++++++++++++++++++++++%
%         Span del settore: pi greco/2         %
%++++++++++++++++++++++++++++++++++++++++++++++%
dalpha = pi/2;

% Ciclo esterno per tenere conto dei tre possibili posizionamenti spaziali
% del plasma
for i=0:2
    % Determino l'offset della colonna di plasma e calcolo la frequenza
    % omega1 del primo modo di diocotron
    D = (0.1 + 0.3 * i) * Rw;
    omega1 = lambda/((2 * pi * epsilon_0 * B * Rw^2)*(1 - (D/Rw)^2));
    T = 2 * pi/omega1;
    signal = zeros(1, 150000);
    t = linspace(0, 3 * T, 150000);
    
    % Ciclo interno per ricostruire la corrente indotta sul settore a causa
    % del posizionamento della colonna di plasma
    modi = zeros(3, 150000);
    for m=1:20
        if m < 4
            modi(m, :) = 2 * (lambda * Ls/pi) * sin(m * dalpha/2) * (D/Rw)^m * omega1 * sin(m * omega1 * t);
        end
        signal = signal + 2 * (lambda * Ls/pi) * sin(m * dalpha/2) * (D/Rw)^m * omega1 * sin(m * omega1 * t);
    end
    
    figure;
    plot(t, modi(1, :), 'g-'); hold on; grid on;
    plot(t, modi(2, :), 'b-'); hold on; grid on;
    plot(t, modi(3, :), 'k-'); hold on; grid on;
    plot(t, signal, 'r-', 'LineWidth', 2); hold on; grid on;
    xlabel('Tempo'); ylabel('Corrente indotta'); title(['Sector span: pi/2, D/Rw = ' num2str(D/Rw, 2)])
    legend('Mode 1', 'Mode 2', 'Mode 3', 'Somma')

end