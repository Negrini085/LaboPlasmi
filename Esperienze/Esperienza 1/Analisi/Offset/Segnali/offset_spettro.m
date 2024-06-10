%-------------------------------------------------------------------------%
%               Grafico i diversi offset al passare del tempo             %
%-------------------------------------------------------------------------%

close all
clear all
clc

%-------------------------------------------------------------------------%
%           Faccio grafico dell'offset tenendo conto del guadagno         %
%-------------------------------------------------------------------------%



figure (1);
l_pixel = 90/838.0; t = [200, 300, 250, 150, 100, 125, 175, 225, 275];
plot(t', opt_maxI' * l_pixel, 'b+', 'MarkerFaceColor','auto', 'MarkerSize',20); hold on; grid on;
plot(t', opt_wmC' * l_pixel, 'r.', 'MarkerFaceColor','auto', 'MarkerSize',20); hold on; grid on;
title('Offset: dipendenza da evoluzione libera'); 
xlabel('Tempo (ms)'); ylabel('Offset (mm)');
legend('Optical: maxI', 'Optical: wmCharge')
