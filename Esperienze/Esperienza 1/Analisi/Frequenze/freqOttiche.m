%-------------------------------------------------------------------------%
%                 Determinazione delle frequenze ottiche                  %
%-------------------------------------------------------------------------%

close all
clear all
clc

% Parametri per calcolo lineare
B = 390/300 * 0.1; Rw = 45e-3; eps0 = 8.85e-12; Qp = 1.262e-9; Lp = 0.7670; Rp = 265 * Rw/419; T = 3.5;

% Frequenza lineare
nu_lin = Qp/(Lp * (2*pi)^2 * eps0 * B * (Rw)^2);
disp(' ')
disp(['Frequenza modo uno di diocotron: ', num2str(nu_lin, 5)])


% Correzione per l'offset
tlib = [200, 300, 250, 150, 100, 125, 175, 225, 275];
off = [23.9696, 80.2032, 45.068, 11.0683, 6.2046, 8.418, 15.9677, 32.8892, 55.4206] * Rw/419;
nu1_nl = zeros(9, 1);
for i=1:9
    nu1_nl(i) = nu_lin * 1/(1-(off(i)/Rw)^2);
end

% Correzione per l'offset e raggio finito
nu1_nl_r = zeros(9, 1);
for i=1:9
    nu1_nl_r(i) = nu_lin * (1 + ((1-2*(Rp/Rw)^2)/(1-(Rp/Rw)^2)^2) * (off(i)/Rw)^2);
end

figure;
plot(tlib, nu1_nl, 'r.', 'MarkerSize', 20); hold on; grid on;
plot(tlib, nu1_nl_r, 'b.', 'MarkerSize', 20); hold on; grid on;
title('Frequenza modo 1: plasma freddo'); xlabel('Evoluzioni libere [ms]'); ylabel('Frequenze [Hz]');
legend('Non lineare', 'Offset & Raggio')


% Correzione per l'offset e raggio finito
nu1_t =  nu_lin * (1 + (2.405/2 * (0.25 + log(Rw/Rp) + (4*pi*eps0*T*Lp)/(Qp) - 0.671)*(Rw/Lp)));

for i=1:9
    nu1_nl(i) = nu1_t * 1/(1-(off(i)/Rw)^2);
end


% Correzione per l'offset e raggio finito
nu1_nl_r = zeros(9, 1);
for i=1:9
    nu1_nl_r(i) = nu1_t * (1 + ((1-2*(Rp/Rw)^2)/(1-(Rp/Rw)^2)^2) * (off(i)/Rw)^2);
end

figure;
plot(tlib, nu1_nl, 'r.', 'MarkerSize', 20); hold on; grid on;
plot(tlib, nu1_nl_r, 'b.', 'MarkerSize', 20); hold on; grid on;
title('Frequenza modo 1: correzione su T'); xlabel('Evoluzioni libere [ms]'); ylabel('Frequenze [Hz]');
legend('Non lineare', 'Offset & Raggio')