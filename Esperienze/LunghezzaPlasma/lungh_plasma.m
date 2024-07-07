%-------------------------------------------------------------------------%
%                 Calcolo della lunghezza del plasma                      %
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
%            Funzione per la determinazione delle intersezioni            %
%                     con il potenziale della trappola                    %             
%-------------------------------------------------------------------------%
function zpos = pot_ELTRAP(v, offset, v_plasma)

    % lengths - inner electrodes shortened 1 mm for the gaps
    z(1)=0; z(2)=z(1)+149.5e-3;             % SH
    z(3)=z(2)+1e-3; z(4)=z(3)+89e-3;        % C8
    z(5)=z(4)+1e-3; z(6)=z(5)+89e-3;        % C7    
    z(7)=z(6)+1e-3; z(8)=z(7)+89e-3;        % C6
    z(9)=z(8)+1e-3; z(10)=z(9)+149e-3;      % S4
    z(11)=z(10)+1e-3; z(12)=z(11)+89e-3;    % C5
    z(13)=z(12)+1e-3; z(14)=z(13)+149e-3;   % S2
    z(15)=z(14)+1e-3; z(16)=z(15)+89e-3;    % C4
    z(17)=z(16)+1e-3; z(18)=z(17)+149e-3;   % S8
    z(19)=z(18)+1e-3; z(20)=z(19)+89e-3;    % C2
    z(21)=z(20)+1e-3; z(22)=z(21)+89e-3;    % C1
    z(23)=z(22)+1e-3; z(24)=z(23)+89.5e-3;  % GND


    N=12; % number of electrodes
    Nmax=3000; % truncation of the series
    pace=.5e-4;
    zx=z(1):pace:z(24);
    L=z(24);
    Rw=0.045;

    term1=0; phi=zeros(1,length(zx));

    % Actual potential computation
    for n=1:Nmax
        kn=n*pi/L;
        kn2=kn^2;
        term1=(v(1)*cos(kn*z(1))-v(N)*cos(kn*z(2*N)))/kn;
        term2=0;
    
        for i=1:N-1
            term2=term2+((v(i+1)-v(i))/(z(2*i+1)-z(2*i))*(sin(kn*z(2*i+1))-sin(kn*z(2*i)))/kn2);
        end
        phi=phi+(term1+term2)*besseli(0,kn*offset)/besseli(0,kn*Rw)/L*2*sin(kn*zx);
    end

    % Looping over array, we keep track of every intersection
    conta = 0;
    for i=2:length(phi)
        if ((v_plasma > phi(i-1)) && (v_plasma < phi(i))) | ((v_plasma < phi(i-1)) && (v_plasma > phi(i)))
            conta = conta + 1;
            zpos(conta) = zx(i-1) + (zx(i) - zx(i-1))/(phi(i) - phi(i-1)) * (v_plasma - phi(i-1));
        end        
    end
end

% Potenziali dei vari elettrodi costituenti la trappola
prompt={'SH','C8','C7','C6','S4','C5','S2','C4','S8','C2','C1','GND'};
default={'0','0','-160','0','0','0','0','0','0','0','-160','0'};
dlgtitle = 'Electrode voltages';
answer=inputdlg(prompt,dlgtitle,[1 50],default);
v(1)=str2num(answer{1});
v(2)=str2num(answer{2});
v(3)=str2num(answer{3});
v(4)=str2num(answer{4});
v(5)=str2num(answer{5});
v(6)=str2num(answer{6});
v(7)=str2num(answer{7});
v(8)=str2num(answer{8});
v(9)=str2num(answer{9});
v(10)=str2num(answer{10});
v(11)=str2num(answer{11});
v(12)=str2num(answer{12});

% Leggo l'immagine necessaria per la determinazione del valore del
% potenziale di plasma
path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Dati/CAMimages/plasma_pulite/plasma010.tif';
im_plasma = double(imread(path)); 

% Altri parametri necessari per la determinazione della lunghezza di plasma
% (nr, offset, rw, kfactor, Lp)
prompt1={'rw','nr','Lp','offset','kfactor', 'N_it'};
default1={'0.045','419','0.81','0','-4.263e-17', '10'};
dlgtitle1 = 'Electrode voltages';
answer1=inputdlg(prompt1,dlgtitle1,[1 50],default1);

rw = str2num(answer1{1});
nr = str2num(answer1{2});
Lp = str2num(answer1{3});
off_pl = str2num(answer1{4});
k_factor = str2num(answer1{5});
N_it = str2num(answer1{6});

% Variabili necessarie per il corretto calcolo della densità del plasma
% presente nella trappola
nth = floor(0.785 * nr); l_pixel = rw/nr;
bc = zeros(nth, 1);

for i=1:N_it
    disp(['Calcolo lunghezza di plasma: iterazione ' num2str(i)])
    % Creazione dell'immagine polare di plasma (con anche opportuna 
    % normalizzazione del contenuto dei pixels)
    appo = im_plasma * k_factor/(l_pixel^2 * Lp);
    pla_polare = cambio_coord(appo, 502, 602, nr-1); 

    % Determinazione del potenziale e valutazione del minimo del plasma 
    % (necessario per il calcolo della lunghezza)
    pot = discrPoisson(pla_polare, bc);
    min_pot = min(min(real(pot)));

    % Intersezione ed aggiornamento del valore della lunghezza di plasma
    inte = pot_ELTRAP(v, off_pl, min_pot);
    Lp = inte(3) - inte(2);
end

disp(["La lunghezza del plasma è pari a " num2str(Lp)])