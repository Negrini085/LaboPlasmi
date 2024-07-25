%-------------------------------------------------------------------------%
%                 Determinazione delle frequenze ottiche                  %
%-------------------------------------------------------------------------%

close all
clear all
clc

% Parametri per calcolo lineare
B = 390/300 * 0.1; Rw = 45e-3; eps0 = 8.85e-12; Qp = 1.262e-9; Lp = 0.7670; Rp = 200 * Rw/419; T = 3.5;

% FREQUENZA LINEARE
nu_lin = Qp/(Lp * (2*pi)^2 * eps0 * B * (Rw)^2);
disp(' ')
disp(['Frequenza modo uno di diocotron: ', num2str(nu_lin, 5)])


% CORREZIONE PER OFFSET FINITO, DIMENSIONE RAGGIO FINITA E TEMPERATURA
pathOff = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/AnalisiRev/Offset/Risultati/Immagini/serie';
nu_r = 0; nu_rp = 0; nu_rpt = 0; off_pl = 0;
for i=1:9
    % Leggo Risultati
    path = [pathOff num2str(i) '.txt'];
    data = fopen(path, 'rt');
    N = 1; filescan = textscan(data,'%f %f %f','HeaderLines',N); offSerie = 45e-3/419 * filescan {1,3};

    nuSerie_r = zeros(1, length(offSerie));
    nuSerie_rp = zeros(1, length(offSerie));
    nuSerie_rpt = zeros(1, length(offSerie));
    for j=1:length(offSerie)
        nuSerie_r(j) = nu_lin * 1/(1-(offSerie(j)/Rw)^2);
        nuSerie_rp(j) = nu_lin * (1 + ((1-2*(Rp/Rw)^2)/(1-(Rp/Rw)^2)^2) * (offSerie(j)/Rw)^2);
        nuSerie_rpt(j) =  nuSerie_rp(j) * (1 + (2.405/2 * (0.25 + log(Rw/Rp) + (4*pi*eps0*T*Lp)/(Qp) - 0.671)*(Rw/Lp)));
    end

    if i == 1
        nu_r = nuSerie_r;
        nu_rp = nuSerie_rp;
        off_pl = offSerie';
        nu_rpt = nuSerie_rpt;
    else
        nu_r = [nu_r, nuSerie_r];
        nu_rp = [nu_rp, nuSerie_rp];
        off_pl = [off_pl, offSerie'];
        nu_rpt = [nu_rpt, nuSerie_rpt];
    end
end

figure;
plot(off_pl, nu_r, 'r.', 'MarkerSize', 20); hold on; grid on;
plot(off_pl, nu_rp, 'b.', 'MarkerSize', 20); hold on; grid on;
plot(off_pl, nu_rpt, 'g.', 'MarkerSize', 20); hold on; grid on;
xlabel('Offset [mm]'); ylabel('Frequenze [Hz]');
legend('Offset', 'Offset & Raggio', 'Offset & Raggio & Temperatura', 'Location', 'northwest') 





