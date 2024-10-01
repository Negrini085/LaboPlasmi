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

inte = sum((M(:, int32(col + colm/2))'));
intGrad = inte/470;
profDens = zeros(1, 730);
for i=130:600
    profDens(i) = intGrad;
end

figure;
plot(linspace(-colm/2 - col, colm/2 - col, colm), M(int32(row + rowm/2 - 10), :), 'r.', 'MarkerSize', 5, 'DisplayName', 'Dati Colonna'); hold on; grid on;
plot(linspace(-rowm/2 - row + 10, rowm/2 + 10 - row, rowm), M(:, int32(col + colm/2))', 'g.', 'MarkerSize', 5, 'DisplayName', 'Dati Riga'); hold on; grid on;
plot(linspace(-365, 365, 730), profDens, 'b-', 'LineWidth', 2, 'DisplayName', 'Profile'); hold on; grid on; xlim([0, 300]);

xlabel('Posizione'); ylabel('Intensità'); legend('show');


% FIGURA DUE --> FIT GAUSSIANO CON EVOLUZIONE LIBERA 100ms
path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Dati/CAMimages/series5_100ms/plasma003.tif';
M = imread(path); M = double(M); [rowm, colm] = size(M);

[X, Y] = meshgrid(linspace(-colm/2, colm/2, colm), linspace(-rowm/2 + 10, rowm/2 + 10, rowm));
xm = X.*M; ym = Y.*M; col = sum(sum(xm))/sum(sum(M)); row = sum(sum(ym))/sum(sum(M));

xFit = [linspace(-colm/2 - col, colm/2 - col, colm) linspace(-rowm/2 - row + 10, rowm/2 + 10 - row, rowm)];
yFit = [M(int32(row + rowm/2 - 10), :) M(:, int32(col + colm/2))'];

inte = sum((M(:, int32(col + colm/2))'));
intGrad = inte/470;
profDens = zeros(1, 730);
for i=130:600
    profDens(i) = intGrad;
end

figure;
plot(linspace(-colm/2 - col, colm/2 - col, colm), M(int32(row + rowm/2 - 10), :), 'r.', 'MarkerSize', 5, 'DisplayName', 'Dati Colonna'); hold on; grid on;
plot(linspace(-rowm/2 - row + 10, rowm/2 + 10 - row, rowm), M(:, int32(col + colm/2))', 'g.', 'MarkerSize', 5, 'DisplayName', 'Dati Riga'); hold on; grid on;
plot(linspace(-365, 365, 730), profDens, 'b-', 'LineWidth', 2, 'DisplayName', 'Profile'); hold on; grid on; xlim([0, 300]);

xlabel('Posizione'); ylabel('Intensità'); legend('show');