%-------------------------------------------------------------------------%
%           Fit lineare fra chirp rate ed ampiezza di aggancio            %
%-------------------------------------------------------------------------%
close all
clear all
clc

v = [0.0375, 0.1125, 0.485, 0.750, 1.500, 2.600]/2;
chR = [5, 20, 80, 140, 350, 667];

myfit = polyfit(log(chR), log(v), 1);
fit_val = polyval(myfit, log(chR));


figure;
loglog(chR, v, 'b.', 'MarkerSize', 20); hold on; grid on;
loglog(chR, exp(fit_val), 'r-'); hold on; grid on;
xlabel('log(cr)'); ylabel('log(V_{pp})');

disp(['Esponente della relazione: ' num2str(myfit(1), 4)])