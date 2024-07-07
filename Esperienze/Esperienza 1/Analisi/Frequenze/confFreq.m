%-------------------------------------------------------------------------%
%               Confronto fra frequenze con due metodi                    %
%-------------------------------------------------------------------------%
tlib = [200, 300, 250, 150, 100, 125, 175, 225, 275];

nl_nt = 1.0e+04 * [1.794800610134197, 1.856966159085383, 1.809865888500123, 1.790176130576427, 1.789319299919821, 1.789649304249826, 1.791528776838311, 1.800017544411530, 1.820781543920136];
nlr_nt = 1.0e+04 * [1.792179335864392, 1.825340699596056, 1.800424842859736, 1.789620433589447, 1.789144863868965, 1.789328081246696, 1.790370271671249, 1.795050283200295, 1.806313935515591];

nl_t = 1.0e+04 * [1.829459025222401, 1.892825019163170, 1.844815220957130, 1.824745244863654, 1.823871868417844, 1.824208245281370, 1.826124011339309, 1.834776700870476, 1.855941662641851];
nlr_t = 1.0e+04 * [1.826787132955706, 1.860588857684916, 1.835191864436735, 1.824178817115425, 1.823694063927608, 1.823880819316130, 1.824943134911207, 1.829713519588822, 1.841194678146956];

nu_dft = 1.0e+04 * [1.725909090000000, 1.783922980000000, 1.744294040000000, 1.726818180000000, 1.720013670000000, 1.722000000000000, 1.733333330000000, 1.738580310000000, 1.761604510000000];


figure;
plot(tlib, nl_nt, 'r.', 'MarkerSize', 20); hold on; grid on;
plot(tlib, nlr_nt, 'g.', 'MarkerSize', 20); hold on; grid on;
plot(tlib, nu_dft, 'b.', 'MarkerSize', 20); hold on; grid on;
title('Confronto: plasma freddo'); xlabel('Evoluzioni libere [ms]'); ylabel('Frequenze [Hz]');
legend('Non lineare', 'Offset & Raggio', 'DFT')

figure;
plot(tlib, nl_t, 'r.', 'MarkerSize', 20); hold on; grid on;
plot(tlib, nlr_t, 'g.', 'MarkerSize', 20); hold on; grid on;
plot(tlib, nu_dft, 'b.', 'MarkerSize', 20); hold on; grid on;
title('Confronto: correzione T'); xlabel('Evoluzioni libere [ms]'); ylabel('Frequenze [Hz]');
legend('Non lineare', 'Offset & Raggio', 'DFT')

figure;
plot(nu_dft, nl_nt, 'r.', 'MarkerSize', 20); hold on; grid on;
plot(nu_dft, nlr_nt, 'g.', 'MarkerSize', 20); hold on; grid on;
title('Confronto: plasma freddo'); xlabel('Evoluzioni libere [ms]'); ylabel('Frequenze [Hz]');
legend('Non lineare', 'Offset & Raggio')

figure;
plot(nu_dft, nl_nt, 'r.', 'MarkerSize', 20); hold on; grid on;
plot(nu_dft, nlr_nt, 'g.', 'MarkerSize', 20); hold on; grid on;
title('Confronto: correzione T'); xlabel('Evoluzioni libere [ms]'); ylabel('Frequenze [Hz]');
legend('Non lineare', 'Offset & Raggio')