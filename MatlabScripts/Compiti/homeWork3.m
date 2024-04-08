%--------------------------------------------------%
%                    Compito 3                     %
%--------------------------------------------------%

close all
clear all
clc

% PUNTO 1 ---> Visualizza le tre immagini 'plasma.tiff', 'dark.tiff' e
% 'ring.tiff'
 
% IMMAGINE PLASMA
figure(1)
M1 = imread('plasma.tiff'); M1 = double(M1); [row1 col1] = size(M1); 
[X, Y] = meshgrid(linspace(-col1/2, col1/2, col1), linspace(-row1/2, row1/2, row1));
colormap('jet'); surface(X, Y, M1,'FaceAlpha',1,'LineStyle','none','FaceColor','flat');
title('Plasma'); axis([ -col1/2 col1/2 -row1/2 row1/2]); daspect([1 1 4]); colorbar; xlabel("Colonne"); ylabel("Righe");
% IMMAGINE RUMORE
figure(2)
M2 = imread('dark.tiff'); M2 = double(M2); [row2 col2] = size(M2);
[X, Y] = meshgrid(linspace(-col2/2, col2/2, col2), linspace(-row2/2, row2/2, row2));
colormap('jet'); surface(X, Y, M2,'FaceAlpha',1,'LineStyle','none','FaceColor','flat');
title('Rumore'); axis([-col2/2 col2/2 -row2/2 row2/2]); daspect([1 1 0.25]); colorbar; xlabel("Colonne"); ylabel("Righe");
% IMMAGINE ANELLO
figure(3)
M3 = imread('ring.tiff'); M3 = double(M3); [row3 col3] = size(M3);
[X, Y] = meshgrid(linspace(-col3/2, col3/2, col3), linspace(-row3/2, row3/2, row3));
colormap('jet'); surface(X, Y, M3,'FaceAlpha',1,'LineStyle','none','FaceColor','flat');
title('Dimensioni trappola'); axis([-col3/2 col3/2 -row3/2 row3/2]); daspect([1 1 2]); colorbar; xlabel("Colonne"); ylabel("Righe");



% PUNTO 2 ---> Inizio ad effettuare le analisi per comprendere quanto il
% rumore influenzi la buona riuscita dell'esperimento

% Sommo i valori nell'immagine con rumore e nell'immagine con plasma per
% vedere quale sia l'importanza del rumore stesso
I_rum = sum(sum(M2)); I_plasma = sum(sum(M1));
fprintf("Il rapporto fra intensità dell'immagine con plasma e l'intensità del rumore è pari a: %f\n", I_plasma/I_rum)

% Faccio la media del rumore per avere un idea di quanto è necessario
% sottrarre per avere un immagine pulita
rum = I_rum/(row2*col2);
fprintf("Il rumore medio risulta essere pari a: %f\n", rum)

% Prendo in carica le 80 foto scattate per modelizzare l'influenza del
% rumore: mi interessa valutare un'influenza media sulla qualità dell' 
% immagine per poter ricostruire il campione più veritiero possibile
appo = double(zeros(row1, col1));
rumore_medio = double(zeros(row1, col1));
for m = 1:80
    % Leggo immagine da file
    appo = imread(['/home/filippo/Desktop/CODICINI/LABO_PLASMI/MatlabScripts/Compiti/dark/ss_single_' num2str(m) '.tiff']);
    appo = double(appo);

    % Controllo se appo presenta delle entrate negative oppure no
    for i = 1:row1
        for j = 1:col1
            if appo(i,j) < 0
                appo(i, j) = 0;
            end
        end
    end

    % Procedo con la media
    rumore_medio = rumore_medio*(m-1)/m + appo/m;
end

% Stampo quanto ho ottenuto per la media dei vari pixel in modo tale da
% stimare il rumore medio
figure(4)
[X, Y] = meshgrid(linspace(-col1/2, col1/2, col1), linspace(-row1/2, row1/2, row1));
colormap('jet'); surface(X, Y, rumore_medio, 'FaceAlpha', 1 , 'LineStyle','none', 'FaceColor', 'flat');
title('Rumore medio'); axis([-col2/2 col2/2 -row2/2 row2/2]); daspect([1 1 0.25]); colorbar; xlabel("Colonne"); ylabel("Righe");



% PUNTO 3 ---> Lavorare con l'immagine dell'anello (che consiste nel prendere 
% l'immagine con il fosforo a potenziale positivo elevato per "strappare" degli
% elettroni dalla struttura metallica) per determinare quanto sia lungo un
% pixel

% VALORI DI RIFERIMENTO:
%        ---> Pixel alto: 201
%        ---> Pixel basso: -229

% Il cilindro preso in considerazione è largo 430 pixel: conoscendone il
% diametro nominale di 90 mm con una semplice conversione possiamo trovare
% la lunghezza in millimetri di un pixel
npixel = 430; largh = 90.0;
fprintf('\n'); disp(['La lunghezza di un pixel è pari a: ' num2str(largh/npixel) ' mm']); fprintf('\n');



% PUNTO 4 ---> Preparare una routine che consenta di settare a zero tutti i
% pixels che si trovano al di fuori della trappola 

% Per fare questo immagino che sia comodo far sì che il centro della
% trappola si trov esattamete in (0, 0) ---> Ho un indicazione riguardante
% le ordinate ,ma devo ora valutare quanto accada sulle ascisse

% VALORI DI RIFERIMENTO:
%        ---> Pixel sinistro: -222
%        ---> Pixel destro: 205

% Devo spostare di poco la griglia per poter fare quanto è necessario: in
% particolare devo spostare verso l'alto l'immagine di 14 pixel e devo
% invece spostrla verso destra di 9 pixel. Posso ottenere questo risultato
% creando una nuova griglia
appo = M3;
% Ciclo for per annullare valore all'esterno della trappola
for i = 1 : row1
    for j = 1 : col1
        % Controllo condizione logica riguardante la distanza dal centro
        % della trappola: il primo indice riguarda le righe, mentre il
        % secondo è relativo alle colonne. Nel caso preso in considerazione
        % il centro della trappola non è in (0,0), ma in (-14, -8) e per
        % questo motivo devo effettuare delle traslazioni dell'indice nel
        % calcolo del raggio.
        if sqrt((i-row1/2+14)^2 + (j-col1/2+8)^2) >= 215    
            appo(i, j) = 0;
        end
    end
end
figure(5)
[X, Y] = meshgrid(linspace(-col1/2 + 10, col1/2 + 10, col1), linspace(-row1/2 + 14, row1/2 + 14, row1));
colormap('jet'); surface(X, Y, appo, 'FaceAlpha', 1 , 'LineStyle','none', 'FaceColor', 'flat');
title('Ring: esterno nullo'); axis([-col1/2+8 col1/2+8 -row1/2+14 row1/2+14]); daspect([1 1 0.25]); colorbar; xlabel("Colonne"); ylabel("Righe");



% PUNTO 5 ---> Immagine correttamente analizzata: per prima cosa si sottrae
% il rumore medio, mentre in un secondo momento si pone a zero l'intensità
% di tutti quei pixel che si trovano al di fuori della trappola. L'ultimo
% step d'analisi consiste dell'identificare il rumore rimanente in modo
% tale da poterl sottrare ed ottenere un'immagine correttamente analizzata
% e processata.

% Primo step: sottraggo il rumore medio e pongo a zero qualsiasi pixel che
% dovesse avere dei valori negativi
M1 = M1 - rumore_medio;
for i = 1:row1
    for j = 1:col1
        if M1(i, j) < 0
            M1(i, j) = 0;
        end
    end
end

% Secondo step: annullo l'intensità di tutti i pixels che si trovano al di
% fuori della trappola.
for i = 1 : row1
    for j = 1 : col1
        if sqrt((i-row1/2+14)^2 + (j-col1/2+9)^2) >= 215    
            M1(i, j) = 0;
        end
    end
end

% Terzo step: sottraggo il rumore rimanente in modo tale da avere
% un'immagine il più pulita possibile (pongo a zero aventuali entrate negative)
rum_agg = mean(M1(242, 125:270));
for i = 1 : row1
    for j = 1 : col1
        M1(i, j) = M1(i, j) - rum_agg;
        if M1(i, j) < 0
            M1(i, j) = 0;
        end
    end
end

figure(6)
colormap('jet'); surface(X, Y, M1, 'FaceAlpha', 1, 'FaceColor','flat', 'LineStyle','none')
title('Immagine analizzata'); axis([-col1/2+9 col1/2+9 -row1/2+14 row1/2+14]); daspect([1 1 4]); colorbar; xlabel("Colonne"); ylabel("Righe");