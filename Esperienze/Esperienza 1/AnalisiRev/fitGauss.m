%-------------------------------------------------------------------------%
%        FIT GAUSSIANO per la determinazione del raggio di plasma         %
%-------------------------------------------------------------------------%

close all
clear all
clc

% FIGURA UNO --> FIT GAUSSIANO CON EVOLUZIONE LIBERA 300ms
path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Dati/CAMimages/series2_300ms/plasma003.tif';
M = imread(path); M = double(M); [rowm, colm] = size(M);

[X, Y] = meshgrid(linspace(-colm/2, colm/2, colm), linspace(-rowm/2 + 10, rowm/2 + 10, rowm));
xm = X.*M; ym = Y.*M; col = sum(sum(xm))/sum(sum(M)); row = sum(sum(ym))/sum(sum(M));

xFit = [linspace(-colm/2 - col, colm/2 - col, colm) linspace(-rowm/2 - row + 10, rowm/2 + 10 - row, rowm)];
yFit = [M(int32(row + rowm/2 - 10), :) M(:, int32(col + colm/2))'];
f = fit(xFit.', yFit.', 'gauss1');
a = f.a1; b = f.b1; c = f.c1;
disp(['Evoluzione libera di 300ms: ' num2str(c)])

myFit = zeros(1, length(xFit));
xFit1 = sort(xFit);
for i=1:length(xFit1)
    myFit(i) = a * exp(-((xFit1(i) - b)/c)^2);
end

figure;
plot(linspace(-colm/2 - col, colm/2 - col, colm), M(int32(row + rowm/2 - 10), :), 'r.', 'MarkerSize', 5, 'DisplayName', 'Dati Colonna'); hold on; grid on;
plot(linspace(-rowm/2 - row + 10, rowm/2 + 10 - row, rowm), M(:, int32(col + colm/2))', 'g.', 'MarkerSize', 5, 'DisplayName', 'Dati Riga'); hold on; grid on;
plot(xFit1, myFit, 'b-', 'LineWidth', 2, 'DisplayName', 'Gaussian Fit'); hold on; grid on;

xlabel('Posizione'); ylabel('Intensità'); legend('show');


% FIGURA DUE --> FIT GAUSSIANO CON EVOLUZIONE LIBERA 100ms
path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Dati/CAMimages/series5_100ms/plasma003.tif';
M = imread(path); M = double(M); [rowm, colm] = size(M);

[X, Y] = meshgrid(linspace(-colm/2, colm/2, colm), linspace(-rowm/2 + 10, rowm/2 + 10, rowm));
xm = X.*M; ym = Y.*M; col = sum(sum(xm))/sum(sum(M)); row = sum(sum(ym))/sum(sum(M));

xFit = [linspace(-colm/2 - col, colm/2 - col, colm) linspace(-rowm/2 - row + 10, rowm/2 + 10 - row, rowm)];
yFit = [M(int32(row + rowm/2 - 10), :) M(:, int32(col + colm/2))'];
f = fit(xFit.', yFit.', 'gauss1');
a = f.a1; b = f.b1; c = f.c1;
disp(['Evoluzione libera di 100ms: ' num2str(c)])

myFit = zeros(1, length(xFit));
xFit1 = sort(xFit);
for i=1:length(xFit1)
    myFit(i) = a * exp(-((xFit1(i) - b)/c)^2);
end

figure;
plot(linspace(-colm/2 - col, colm/2 - col, colm), M(int32(row + rowm/2 - 10), :), 'r.', 'MarkerSize', 5, 'DisplayName', 'Dati Colonna'); hold on; grid on;
plot(linspace(-rowm/2 - row + 10, rowm/2 + 10 - row, rowm), M(:, int32(col + colm/2))', 'g.', 'MarkerSize', 5, 'DisplayName', 'Dati Riga'); hold on; grid on;
plot(xFit1, myFit, 'b-', 'LineWidth', 2, 'DisplayName', 'Gaussian Fit'); hold on; grid on;

xlabel('Posizione'); ylabel('Intensità'); legend('show');