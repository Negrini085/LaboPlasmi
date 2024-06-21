%-------------------------------------------------------------------------%
%           Cambio di coordinate --> da cartesiane a cilindriche          %
%-------------------------------------------------------------------------%

close all
clear all
clc

function polar = cambio_coord(image, xr, yr, radius)
    
    % Numero celle per la griglia polare
    nr = radius; nt = floor(0.785 * radius);
    
    % Faccio l'interpolazione bilineare
    polar = zeros(nt, nr);
    for m=0:(nt-1)
        for n=0:nr
            
            % Calcolo le coordinate dell'asse della trappola
            xp = n * cos(2*m*pi/nt) + xr;
            yp = n * sin(2*m*pi/nt) + yr;

            % Determino gli strumenti che mi consentiranno di effettuare
            % l'interpolazione bilineare
            fxp = floor(xp); fyp = floor(yp);
            dx = xp-fxp; dy = yp - fyp;
            
            % Faccio l'interpolazione bilineare
            polar(m+1, n+1) = image(fxp, fyp) * (1 - dx) * (1-dy) + image(fxp + 1, fyp) * dx * (1 - dy) + image(fxp, fyp + 1) * (1 - dx) * dy + image(fxp + 1, fyp + 1) * dx * dy;
        end
    end
end

% Faccio del benchmarking per vedere se il metodo per il cambio di
% coordinate è corretto oppure no. Utilizzo un'immagine di plasma pulito
% prodotta in fase di calibrazione
path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Dati/CAMimages/calibrazione/PlasmaPulite/plasma019.tif';
nr = 419; nth = floor(0.785 * nr);
im_plasma = imread(path); 
im_polare = cambio_coord(im_plasma, 502, 602, 419); 
im_polare(nth+1,:) = im_polare(1,:); 

% Faccio il plot del'immagine appena prodotta in coordinate polari
figure(1);

r = linspace(0,1,nr+1);
th =linspace(0,2*pi,nth+1);

[R,Th] = meshgrid(r,th);
[x,y] = pol2cart(Th,R);
colormap('jet'); surface(x,y, im_polare,'FaceAlpha',1,'LineStyle','none','FaceColor','flat'); hold on;
title('Immagine di plasma pulita: coordinate polari'); daspect([1 1 1]); colorbar; objrho = colorbar;
