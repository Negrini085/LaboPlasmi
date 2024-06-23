%-------------------------------------------------------------------------%
%               Procedura per calcolare le intersezioni fra               %
%             potenziale della trappola e potenziale di plasma            %
%-------------------------------------------------------------------------%

close all
clear all
clc

% Funzione che restituisce le posizioni a cui è avvenuta l'intersezione
% ricercata ---> non è un algoritmo evidentemente ottimizzato, 

function [zpos, phi, zx] = pot_ELTRAP(v, offset, v_plasma)

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

% Test per fare bench-marking: scelgo come potenziale di plasma -70 eV per
% vedere le soluzioni trovate dall'algoritmo precedentemente implementato

% E' fondamentale scrivere correttamente il vettore con cui definiamo i
% valori dei potenziali confinanti: sgravare qui equivale a scrivere tutto
% completamente errato

% Per il potenziale confinante l'ordine da mantenere è il seguente:
% 'SH','C8','C7','C6','S4','C5','S2','C4','S8','C2','C1','GND'
v = zeros(1, 12); v(3) = -160; v(11) = -160; v_plasma = -70; off = 0;
[int_pot, pot, posz] = pot_ELTRAP(v, off, v_plasma); L = 1.32;


plot(posz - L/2, pot, 'b-', 'LineWidth', 2); hold on; grid on;
plot(int_pot - L/2, v_plasma, 'r.', 'MarkerSize', 20); hold on; grid on;
title('Potenziale confinante: determinazione intersezioni'); 
xlabel('Posizione assiale (m)'); ylabel('Potenziale confinante'); 
