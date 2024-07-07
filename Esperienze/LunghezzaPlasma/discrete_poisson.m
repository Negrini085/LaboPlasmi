%-------------------------------------------------------------------------%
%        Algoritmo per risolvere il problema di Poisson discreto          %
%-------------------------------------------------------------------------%

close all
clear all

%-------------------------------------------------------------------------%
%           Funzione per effettuare il cambio di coordinate da            %
%                         cartesiane a polari                             %
%-------------------------------------------------------------------------%
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


%-------------------------------------------------------------------------%
%        Funzione per risolvere un sistema tridiagonale trattando         %
%                    le sole diagonali principali                         %
%-------------------------------------------------------------------------%
function res = thomasDiag(a, b, c, n)

    if (length(a) ~= (length(b) - 1)) | (length(c) ~= (length(b)-1))
        disp("Dimensioni delle diagonali errate: controllare come vengono passati gli argomenti");
    end

    for i=1:length(a)
        b(i+1) = b(i+1) - c(i) * a(i)/b(i);  
        n(i+1) = n(i+1) - c(i) * n(i)/b(i);
        c(i) = 0;
    end
    
    res = zeros(length(b), 1);
    res(length(b)) = n(length(b))/b(length(b));
    for i=1:length(b)-1
        res(length(b)-i) = (n(length(b)-i) - a(length(b)-i)*res(length(b)-i+1))/b(length(b)-i);
    end
end



%-------------------------------------------------------------------------%
%                Funzione per effettivamente risolvere il                 %
%                          problema di Poisson                            %
%-------------------------------------------------------------------------%
function pot = discrPoisson(rho, bc)

    % Controllo le dimensioni dei vettori forniti
    dim = size(rho); nth = dim(1); nr = dim(2);

    if dim(1) ~= length(bc)
        disp("Dimensioni matrice densità e boundary condition non compatibili")
    end


    % Valuto quale sia la matrice dei termini noti: la fft effettua la
    % trasformata di Fourier per colonne e quindi per come lavoriamo, ossia
    % angoli x posizioni radiali dovrebbe fare al caso nostro. Dobbiamo
    % anche imporre le BC in modo opportuno, ossia tale per cui consentano
    % di determinare il valore delle componenti della trasformata di
    % Fourier del potenziale sulle pareti della trappola
    eps0 = 8.854e-12; term_noti = -fft(rho)/eps0; 
    term_noti(:, nr+1) = fft(bc); 
    dr = 45e-3/nr; dt = 2*pi/nth; pot = zeros(nth, nr+1);


    % Devo risolvere il problema m volte in modo tale da determinare in
    % tutto il dominio quanto valga il potenziale: dobbiamo stare attenti a
    % quale valore forniamo come input del thomas solver, dato che tutte le
    % matrici con cui stiamo lavorando sono angolo x posizione radiale
    for m=0:(nth-1)

        diag1 = zeros(1, nr);
        diag2 = zeros(1, nr);
        diagP = zeros(1, nr+1);

        % Caso con m = 0, In questo caso dobbiamo porre particolare
        % attenzione alla costruzione della matrice per il thomas solver
        % dato che è l'unico caso che si discosta, per natura fisica, da
        % tutte le altre matrici
        if m == 0
            diagP(1) = - 4/(dr^2);
            diag1(1) = 4/(dr^2);

            for j=2:nr
                diagP(j) = - 2/(dr^2);
                diag1(j) = 1/(dr^2) + 1/(2 * (j-1) * dr^2);
                diag2(j-1) = 1/(dr^2) - 1/(2 * (j-1) * dr^2);
            end

            diagP(nr+1) = 1;
            diag2(nr) = 0;
        end


        if m ~= 0
            diagP(1) = 1;
            diag1(1) = 0;
            
            bm2 = (sin(m*dt/2)/(dt/2))^2;
            for j=2:nr
                diagP(j) = - 2/(dr^2) - bm2/((2 *(j-1) * dr)^2);
                diag1(j) = 1/(dr^2) + 1/(2 * (j-1) * dr^2);
                diag2(j-1) = 1/(dr^2) - 1/(2 * (j-1) * dr^2);
            end

            diagP(nr+1) = 1;
            diag2(nr) = 0;
        end

        % Risolvo il problema utilizzando l'algoritmo di thomas
        pot(m+1, :) = thomasDiag(diag1, diagP, diag2, term_noti(m+1, :));
    end

    % Faccio l'anti-trasformata e risolvo
    pot = ifft(pot);
end


%-------------------------------------------------------------------------%
%                         Problema di Laplace                             %
%-------------------------------------------------------------------------%

% Densità del plasma presente nella trappola nulla
nr = 419; nth = 328;
dens_nulla = zeros(1024, 1224); dens_nulla = double(dens_nulla);
im_polare = cambio_coord(dens_nulla, 502, 602, nr-1); 

% Boundary condition
theta = 0:2*pi/nth:2*pi*(1-1/nth) ; bc = sin(4*theta);

% Determinazione del potenziale
pot = discrPoisson(im_polare, bc); 
pot = real(pot); pot(nth+1, :) = pot(1, :);

% Stampo le immagini di plasma prodotte
r = linspace(0,1,420);
th =linspace(0,2*pi,329);

[R,Th] = meshgrid(r,th);
[x,y] = pol2cart(Th, R);

figure(1);
im_polare(:, nr+1) = im_polare(:, nr);
im_polare(nth+1, :) = im_polare(1, :);
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
path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Dati/CAMimages/series2_300ms/plasma010.tif';
nr = 419; nth = floor(0.785 * nr); l_pixel = 45e-3/nr;
k_factor = -4.263e-17; Lp = 0.81; rw = 45e-3;

% Determino quale sia la densità superficiale del plasma, andando
% inizialmente a supporre che il plasma sia esattamente lungo 81 cm, ossia
% la distanza fra i potenziali confinanti (elettrodi C1 e C7)
im_plasma = double(imread(path)); 
im_plasma = im_plasma * k_factor/(l_pixel^2 * Lp);
pla_polare = cambio_coord(im_plasma, 502, 602, nr-1); 

bc = zeros(nth, 1);
potenziale = discrPoisson(pla_polare, bc); potenziale = real(potenziale);

% Faccio il plot del'immagine appena prodotta in coordinate polari
r = linspace(0,1,nr+1);
th =linspace(0,2*pi,nth+1);

[R,Th] = meshgrid(r,th);
[x,y] = pol2cart(Th, R);

figure(3);
pla_polare(:, nr+1) = pla_polare(:, nr);
pla_polare(nth+1, :) = pla_polare(1, :);
colormap('jet'); surface(x, y, pla_polare,'FaceAlpha',1,'LineStyle','none','FaceColor','flat'); hold on;
title('Densità di carica','FontSize', 20); daspect([1 1 1e-10]);
cb = colorbar(); ylabel(cb,'C/m^3','FontSize',15,'Rotation',270);

figure(4);
potenziale(nth+1, :) = potenziale(1,:);
colormap('jet'); surface(x, y, potenziale,'FaceAlpha',1,'LineStyle','none','FaceColor','flat'); hold on;
title('Potenziale di plasma', 'FontSize', 20); daspect([1 1 40]);
cb = colorbar(); ylabel(cb,'V','FontSize',15,'Rotation',270);
