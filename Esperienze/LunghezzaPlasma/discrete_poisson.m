%--------------------------------------------------------------%
%         Risoluzione del problema di Poisson discreto         %
%--------------------------------------------------------------%

close all
clear all
clc


%---------------------------------------------------------%
%        Function to compute signal FFT amplitudes        %
%---------------------------------------------------------%
function ampl = signal_DFT(segnale)
    % Calcolo le dimensioni del campione preso in considerazione per l'
    % analisi in FFT e faccio la FFT
    M = 2 * ceil(length(segnale)/2);
    fou = fft(segnale, M);
    
    % Normalizzo e considero il modulo
    fou = fou/M;
    power = fou.*conj(fou);
    ampl = sqrt(power);
end


%---------------------------------------------------------%
%        Function to compute matrix FFT amplitudes        %
%---------------------------------------------------------%
function ampl = matrix_DFT(m)
    % Calcolo le dimensioni del campione preso in considerazione per l'
    % analisi in FFT e faccio la FFT
    dim = size(m);
    M = 2 * ceil(dim(1) * dim(2)/2);
    fou = fft(m);
    
    % Normalizzo e considero il modulo
    fou = fou/M;
    power = fou.*conj(fou);
    ampl = sqrt(power);
end



%---------------------------------------------------------%
%        Function to compute matrix FFT amplitudes        %
%---------------------------------------------------------%
function ampl = matrix_IDFT(m)
    % Calcolo le dimensioni del campione preso in considerazione per l'
    % analisi in FFT e faccio la FFT
    dim = size(m);
    M = 2 * ceil(dim(1) * dim(2)/2);
    fou = ifft(m);
    
    % Normalizzo e considero il modulo
    fou = fou/M;
    power = fou.*conj(fou);
    ampl = sqrt(power);
end



%---------------------------------------------------------%
%        Function to change from cartesian to polar       %
%---------------------------------------------------------%
function polar = cambio_coord(image, xr, yr, radius)
    
    % Numero celle per la griglia polare
    nr = radius + 1; nt = floor(0.785 * radius);
    
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



%-------------------------------------------------------------%
%   Function to solve linear system with tridiagonal matrix   %
%-------------------------------------------------------------%
function result = thomas(matrix, known)
    dim = size(matrix);
    matrix = double(matrix); known = double(known);

    % Controllo quali siano le dimensioni della matrice in analisi
    if dim(1) ~= dim(2) 
        disp("La matrice fornita all'algoritmo di Thomas non è quadrata.")
    end

    if dim(2) ~= length(known)
        disp("Matrice e vettore non hanno dimensioni corrette per il prodotto matriciale riga per colonna.")
    end

    result = zeros(1, length(known));

    % Effettuo l'iterazione, sia sulla matrice che sui termini noti
    for i=1:(dim(1)-1)
        fact = (matrix(i+1, i)/matrix(i, i));
        matrix(i+1, :) = matrix(i+1, :) - fact * matrix(i, :);      % Cambio il valore dell'(i+1)-esima riga
        known(i+1) = known(i+1) - fact * known(i);                  % Cambio il valore dell'(i+1)-esimo termine noto
    end

    % Svolgo l'effettivo calcolo per il risultato
    result(length(known)) = known(length(known))/matrix(length(known), length(known));
    for i=1:(length(known)-1)
        result(length(known)-i) = (known(length(known)-i) - ...
            matrix(length(known)-i, length(known)-i+1) * result(length(known)-i + 1))/matrix(length(known)-i, length(known)-i);
    end

end



%----------------------------------------------------------%
%        Function to solve discrete Poisson problem        %
%----------------------------------------------------------%
function potential = discretePoisson(nr, nt, rho, bc)
    
    % Valuto quale sia la matrice dei termini noti: essa è la trasformata
    % di fourier della matrice densità alla quale viene aggiunta una
    % colonna che consente di tenere conto delle boundary conditions
    dr = 45e-3/nr; dt = 2*pi/nt; eps0 = 8.854187817e-12;
    if length(rho(:, 1)) ~= length(bc)
        disp("Dimensione della matrice densità e della boundary condition non compatibili")
    end
    term_noti = -fft(rho)/eps0; term_noti(:, nr +1) = fft(bc); 
    pot_fft = zeros(size(term_noti)); 


    % Itero sul numero di partizioni angolari utilizzate per discretizzare
    % il dominio su cui vogliamo risolvere il problema di Poisson
    mat_lineare = zeros(nr+1, nr+1);
    for m=0:nt-1

        % Costruzione della matrice associata al problema nel caso di m=0
        if m == 0
            mat_lineare(1, 1) = -4/(dr^2); mat_lineare(1, 2) = 4/(dr^2);

            for j=2:nr
                mat_lineare(j, j-1) = (1/(dr^2) - 1/(2 * (j-1) * dr^2));
                mat_lineare(j, j) = -2/(dr^2);
                mat_lineare(j, j+1) = (1/(dr^2) + 1/(2 * (j-1) * dr^2));
            end

            mat_lineare(nr+1, nr+1) = 1;
        end

        % Costruzione della matrice associata al problema nel caso di m!=0
        if m ~= 0
            mat_lineare(1, 1) = 1;
            
            bm2 = (sin(m * dt/2)/(dt/2))^2;
            for j=2:nr
                mat_lineare(j, j-1) = (1/(dr^2) - 1/(2 * (j-1) * dr^2));
                mat_lineare(j, j) = -(2/(dr^2) - bm2/(((j-1) * dr)^2));
                mat_lineare(j, j+1) = (1/(dr^2) + 1/(2 * (j-1) * dr^2));
            end
            
            mat_lineare(nr+1, nr+1) = 1;
        end

        % Risoluzione del sistema lineare mediante l'algoritmo di thomas 
        % (qui sto valutando l'entità delle phi^tilde_m alle varie posizioni
        % radiali)
        ris = thomas(mat_lineare, term_noti(m+1, :)');
        pot_fft(m+1, :) = ris; 
    end
    potential = ifft(pot_fft);

end


%-------------------------------------------------------------------------%
%                         Problema di Laplace                             %
%-------------------------------------------------------------------------%
nr = 419; nth = 328;
dens_nulla = zeros(1024, 1224); dens_nulla = double(dens_nulla);
im_polare = cambio_coord(dens_nulla, 502, 602, nr-1); 
im_polare(nth+1,:) = im_polare(1,:); 

theta = 0:2*pi/nth:2*pi; bc = sin(theta); 

pot = discretePoisson(nr, nth, im_polare, bc'); pot = imag(pot);

% Stampo le immagini di plasma prodotte
r = linspace(0,1,420);
th =linspace(0,2*pi,329);

[R,Th] = meshgrid(r,th);
[x,y] = pol2cart(Th, R);

figure(1);
colormap('jet'); surface(x, y, im_polare,'FaceAlpha',1,'LineStyle','none','FaceColor','flat'); hold on;
title('Densità nulla'); daspect([1 1 1e-10]); colorbar; objrho = colorbar;

figure(2);
colormap('jet'); surface(x, y, pot,'FaceAlpha',1,'LineStyle','none','FaceColor','flat'); hold on;
title('Soluzione problema Laplace'); daspect([1 1 1]); colorbar; objrho = colorbar;



%-------------------------------------------------------------------------%
%                         Problema di Poisson                             %
%-------------------------------------------------------------------------%

% Carico immagine da cui andrò a determinare l'andamento del potenziale
% all'interno della trappola
path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Dati/CAMimages/calibrazione/PlasmaPulite/plasma019.tif';
nr = 419; nth = floor(0.785 * nr);
im_plasma = double(imread(path)); 
im_polare = cambio_coord(im_plasma, 502, 602, nr-1); 
im_polare(nth+1,:) = im_polare(1,:); 

% Determino quale sia la densità superficiale del plasma, andando
% inizialmente a supporre che il plasma sia esattamente lungo 81 cm, ossia
% la distanza fra i potenziali confinanti (elettrodi C1 e C7)
k_factor = -3.9922e-17; Lp = 0.81; l_pixel = 1.0739e-4;
im_polare = im_polare * k_factor/Lp; bc = zeros(nth + 1, 1);
potenziale = discretePoisson(nr, nth, im_polare, bc); potenziale = imag(potenziale);

% Faccio il plot del'immagine appena prodotta in coordinate polari
r = linspace(0,1,nr+1) * l_pixel;
th =linspace(0,2*pi,nth+1);

[R,Th] = meshgrid(r,th);
[x,y] = pol2cart(Th, R);

figure(3);
colormap('jet'); surface(x, y, im_polare,'FaceAlpha',1,'LineStyle','none','FaceColor','flat'); hold on;
title('Densità superficiale: esperienza 1'); daspect([1 1 1e-10]); colorbar; objrho = colorbar;

figure(4);
colormap('jet'); surface(x, y, potenziale,'FaceAlpha',1,'LineStyle','none','FaceColor','flat'); hold on;
title('Potenziale di plasma: esperienza 1'); daspect([1 1 1e4]); colorbar; objrho = colorbar;
