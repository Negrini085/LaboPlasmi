close all
clear all
clc

x = [1.15, 2.90, 4.63, 6.37, 8.11, 9.85];
freDir = [17212, 17329, 17351, 17757, 17795, 17762];

% Parametri per calcolo lineare
B = 390/300 * 0.1; Rw = 45e-3; eps0 = 8.85e-12; Qp = 1.262e-9; Lp = 0.7680; Rp = 200 * Rw/419; T = 3.5;
nu_lin = Qp/(Lp * (2*pi)^2 * eps0 * B * (Rw)^2);
nuSerie_r = zeros(1, length(x)); nuSerie_rp = zeros(1, length(x)); nuSerie_rpt = zeros(1, length(x));
offSerie = x * 0.001;
for j=1:length(x)
    nuSerie_r(j) = nu_lin * 1/(1-(offSerie(j)/Rw)^2); 
    nuSerie_rp(j) = nu_lin * (1 + ((1-2*(Rp/Rw)^2)/(1-(Rp/Rw)^2)^2) * (offSerie(j)/Rw)^2); 
    nuSerie_rpt(j) =  nuSerie_rp(j) * (1 + (2.405/2 * (0.25 + log(Rw/Rp) + (4*pi*eps0*T*Lp)/(Qp) - 0.671)*(Rw/Lp)));
end

figure;
plot(x, freDir, 'r.', DisplayName='Diretto', MarkerSize=20);hold on; grid on;
plot(x, nuSerie_r, 'g.', DisplayName='Offset', MarkerSize=20);hold on; grid on;
plot(x, nuSerie_rp, 'b.', DisplayName='Offset & R', MarkerSize=20);hold on; grid on;
plot(x, nuSerie_rpt, 'k.', DisplayName='Offset & R & T', MarkerSize=20);hold on; grid on;
legend('show', 'Location', 'southeast'); xlabel('Offset [mm]', 'FontSize',15); ylabel('Frequenza [Hz]', 'FontSize',15);