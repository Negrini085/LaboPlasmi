%--------------------------------------------------------------%
%         Risoluzione del problema di Poisson discreto         %
%--------------------------------------------------------------%

close all
clear all
clc

%--------------------------------------------------%
%        Function to compute FFT amplitudes        %
%--------------------------------------------------%
function power = signal_DFT(segnale)
    % Calcolo le dimensioni del campione preso in considerazione per l'
    % analisi in FFT e faccio la FFT
    M = 2 * ceil(length(segnale)/2);
    fou = fft(segnale, M);
    
    % Normalizzo e considero il modulo
    fou = fou/M;
    power = fou.*conj(fou);
end



%---------------------------------------------------------%
%        Function to change from cartesian to polar       %
%---------------------------------------------------------%
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

%-------------------------------------------------------------%
%   Function to solve linear system with tridiagonal matrix   %
%-------------------------------------------------------------%
function result = thomas(matrix, known)
    dim = size(matrix);

    % Controllo quali siano le dimensioni della matrice in analisi
    if dim(1) ~= dim(2) 
        disp("La matrice fornita all'algoritmo di Thomas non è quadrata.")
    end

    if dim(2) ~= length(known)
        disp("Matrice e vettore non hanno dimensioni corrette per il prodotto matriciale riga per colonna.")
    end
    result = zeros(length(known), 1);

    % Effettuo l'iterazione, sia sulla matrice che sui termini noti
    for i=1:(dim(1)-1)
        matrix(i+1, :) = matrix(i+1, :) - (matrix(i+1, i)/matrix(i, i)) * matrix(i, :);      % Cambio il valore dell'(i+1)-esima riga
        known(i+1) = known(i+1) - (matrix(i+1, i)/matrix(i, i)) * known(i);                  % Cambio il valore dell'(i+1)-esimo termine noto
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
function potential = discretePoisson(nr, nt, rho)
    dr = 0.045/nr; dt = 2*pi/nt;
    potential = zeros(nt, nr + 1);
        
    % Ciclo sul numero di intervalli angolari rispetto ai quali ho fatto la DFT
    for m=0:(nt-1)

        % Costruisco la matrice del sistema lineare che devo andare a
        % risolvere utilizzando l'algoritmo di Thomas
        mat_lin = zeros(nr+1, nr+1);
        if m == 0
            mat_lin(1, 1) = -4/((dr)^2); mat_lin(1, 2) = 4/((dr)^2);

            for j=2:nr
                mat_lin(j, j-1) = 1/(dr^2) - 1/(2*(j-1)*(dr)^2);
                mat_lin(j, j) = -2/(dr^2);
                mat_lin(j, j+1) = 1/(dr^2) + 1/(2*(j-1)*(dr)^2);
            end
        end
        if m ~= 0
            mat_lin(1, 1) = 1;
            
            beta2_m = (sin(m * dt/2)/(dt/2))^2;
            for j=2:nr
                mat_lin(j, j-1) = 1/(dr^2) - 1/(2*(j-1)*(dr)^2);
                mat_lin(j, j) = -2/(dr^2) - beta2_m/(((j-1)*dr)^2);
                mat_lin(j, j+1) = 1/(dr^2) + 1/(2*(j-1)*(dr)^2);
            end
        end

        mat_lin(nr+1, nr+1) = 1;

        % Una volta costruita la matrice, devo valutare quale sia la
        % corretta DFT della densità di carica in modo tale da poter
        % applicare l'algoritmo di thomas
        dens_DFT = sqrt(signal_DFT(rho(m+1,:)));
        eps0 = 8.854187817e-12; dens_DFT = -dens_DFT/eps0;
        pot_DFT = thomas(mat_lin, dens_DFT);

        % Faccio l'anti-trasformata in modo tale da ritornare in campo
        % reale
        pot_IDFT = ifft(pot_DFT);
        potential(m+1, :) = pot_IDFT;
    end
end

% Carico immagine da cui andrò a determinare l'andamento del potenziale
% all'interno della trappola
path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Dati/CAMimages/calibrazione/PlasmaPulite/plasma019.tif';
nr = 419; nth = floor(0.785 * nr);
im_plasma = double(imread(path)); 
im_polare = cambio_coord(im_plasma, 502, 602, 419); 
im_polare(nth+1,:) = im_polare(1,:); 

% Determino quale sia la densità superficiale del plasma, andando
% inizialmente a supporre che il plasma sia esattamente lungo 81 cm, ossia
% la distanza fra i potenziali confinanti (elettrodi C1 e C7)
k_factor = 3.9922e-17; Lp = 0.81; 
im_polare = im_polare * k_factor/Lp;
potenziale = discretePoisson(nr, nth, im_polare); potenziale = abs(potenziale);
potenziale(nth+1,:) = potenziale(1,:);

% Faccio il plot del'immagine appena prodotta in coordinate polari
figure(1);

r = linspace(0,1,nr+1);
th =linspace(0,2*pi,nth+1);

[R,Th] = meshgrid(r,th);
[x,y] = pol2cart(Th,R);

colormap('jet'); surface(x,y, potenziale,'FaceAlpha',1,'LineStyle','none','FaceColor','flat'); hold on;
title('Potenziale di plasma: esperienza 1'); daspect([1 1 1]); colorbar; objrho = colorbar;