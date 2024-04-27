%-------------------------------------------------------------------%
%                  ANALISI ALTERNATIVA DEL SEGNALE                  %
%-------------------------------------------------------------------%

close all
clear all
clc



%---------------------------------------------------------------%
%                       CARICA DEGLI IONI                       %
%---------------------------------------------------------------%

% Procediamo al calcolo della carica della popolazione ionica presente
% all'interno della trappola: devo effettuare lo smoothing, togliere
% l'offset dai vari segnali ed effettuare il calcolo della carica

disp('++++++++++++++++++++++++++++++++++++++++++++++++++')
disp('+  Calcolo della carica degli ioni intrappolati  +')
disp('++++++++++++++++++++++++++++++++++++++++++++++++++')

% PUNTO 1 ---> Studio il numero di punti necessari per lo smoothing
path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 0/Dati/Signals/ion_discharge/cdisch/cdisch_09.txt';
data = fopen(path, 'rt');
N = 3; filescan = textscan(data,'%f %f','HeaderLines',N);
t = filescan {1,1}; v = filescan {1,2};

scelta_smooth = zeros(5, length(v));
for m=1:5
    Navg = m * 50 + 1;      % Scelgo a runtime il numero di punti da considerare per lo smooth
    scelta_smooth(m, :) = smooth(v,Navg);
end

figure;
plot(t, v, 'k-'); hold on; grid on;
plot(t, scelta_smooth(1, :), 'r-'); hold on; grid on;
plot(t, scelta_smooth(2, :), 'g-'); hold on; grid on;
plot(t, scelta_smooth(3, :), 'b-'); hold on; grid on;
plot(t, scelta_smooth(4, :), 'c-'); hold on; grid on;
plot(t, scelta_smooth(5, :), 'y-'); hold on; grid on;
legend('Data', 'N = 50', 'N = 100', 'N = 150', 'N = 200', 'N = 250')
xlabel('Tempo (ms)'); ylabel('Potenziale (mV)'); title('Confronto fra smoothing: scarica ionica')



% PUNTO 2 ---> Effettuo il calcolo della carica esplicito, per determinare
%              quanto sia popolosa la popolazione ionica
Navg = 100; res = 1e6;
vsign_max = zeros(33, 1); capacity = zeros(33, 1); car_ioni = zeros(33, 1);

for i=1:33
    if i ~= 10 && i ~= 31
        path = ['/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 0/Dati/Signals/ion_discharge/cdisch/cdisch_' sprintf('%02i', i) '.txt'];
        data = fopen(path, 'rt');
        N = 3; filescan = textscan(data,'%f %f','HeaderLines',N);
        t = filescan {1,1}; v = filescan {1,2}; t = 0.001 * t; v = 0.001 * v;


        %-----------------------------------------------------%
        %           Effettuo smoothing del segnale            %
        %       Trovo il massimo valore del potenziale        %
        %-----------------------------------------------------%
        v_smooth = smooth(v, Navg);
        [vsign_max(i) ind] = max(v_smooth);
        vsign_max(i) = 0.001* vsign_max(i);


        %------------------------------------------------------%
        %             Effettuo calcolo dell'offset             %
        %------------------------------------------------------%
        offset_ionsig = mean(v_smooth(1:int32(ind * 9/10)));
        v_smooth = v_smooth - offset_ionsig;
        

        %------------------------------------------------------%
        %     Calcolo la carica della popolazione ionica       %
        %------------------------------------------------------%
        
        % Effettuo fit esponenziale per la determinazione del tempo
        % caratteristico del decadimento da cui ricavare la capacità e di
        % conseguenza la carica degli ioni intrappolati
        myfit = fit(t(ind:70000), v_smooth(ind:70000), 'exp1', 'Start', [-2.5, 200]); 
        myfit_coeff = coeffvalues(myfit);
        capacity(i) = -1.0/(myfit_coeff(2) * res);

        dt = t(35123) - t(35122);

        car_ioni(i) = sum(v_smooth(t>0)) * dt/res + mean(v_smooth(end-100:end)) * capacity(i);
        
    end
end

fprintf('\n')
car_ioni = car_ioni(car_ioni>0);
disp(['La carica media della popolazione ionica è pari a: ' num2str(mean(car_ioni), 4) ' C'])





%---------------------------------------------------------------%
%                    CARICA DEGLI ELETTRONI                     %
%---------------------------------------------------------------%

% Procediamo al calcolo della carica della popolazione elettronica presente
% all'interno della trappola: devo effettuare lo smoothing, togliere
% l'offset dai vari segnali ed effettuare il calcolo della carica

fprintf('\n\n')
disp('++++++++++++++++++++++++++++++++++++++++++++++++++')
disp('+  Calcolo della carica elettronica del plasma   +')
disp('++++++++++++++++++++++++++++++++++++++++++++++++++')

% PUNTO 1 ---> Studio il numero di punti necessari per lo smoothing
path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 0/Dati/Signals/electron_discharge/rcdisch/rcdisch/rcdisch_09.txt';
data = fopen(path, 'rt');
N = 3; filescan = textscan(data,'%f %f','HeaderLines',N);
t = filescan {1,1}; v = filescan {1,2};

scelta_smooth = zeros(5, length(v));
for m=1:5
    Navg = m * 50 + 1;      % Scelgo a runtime il numero di punti da considerare per lo smooth
    scelta_smooth(m, :) = smooth(v,Navg);
end

figure;
plot(t, v, 'k-'); hold on; grid on;
plot(t, scelta_smooth(1, :), 'r-'); hold on; grid on;
plot(t, scelta_smooth(2, :), 'g-'); hold on; grid on;
plot(t, scelta_smooth(3, :), 'b-'); hold on; grid on;
plot(t, scelta_smooth(4, :), 'c-'); hold on; grid on;
plot(t, scelta_smooth(5, :), 'y-'); hold on; grid on;
legend('Data', 'N = 50', 'N = 100', 'N = 150', 'N = 200', 'N = 250')
xlabel('Tempo (ms)'); ylabel('Potenziale (mV)'); title('Confronto fra smoothing: scarica elettronica')



% PUNTO 2 ---> Effettuo il calcolo della carica esplicito, per determinare
%              quanto sia popolosa la popolazione ionica
Navg = 100; res = 1e6;
vsign_min = zeros(33, 1); capacity = zeros(33, 1); car_ele = zeros(33, 1);

for i=1:33
    if i ~= 31
        path = ['/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 0/Dati/Signals/electron_discharge/rcdisch/rcdisch/rcdisch_' sprintf('%02i', i) '.txt'];
        data = fopen(path, 'rt');
        N = 3; filescan = textscan(data,'%f %f','HeaderLines',N);
        t = filescan {1,1}; v = filescan {1,2}; t = 0.001 * t;


        %-----------------------------------------------------%
        %           Effettuo smoothing del segnale            %
        %        Trovo il minimo valore del potenziale        %
        %-----------------------------------------------------%
        v_smooth = smooth(v, Navg);
        [vsign_min(i) ind] = min(v_smooth);


        %------------------------------------------------------%
        %             Effettuo calcolo dell'offset             %
        %------------------------------------------------------%
        offset_elesig = mean(v_smooth(1:int32(ind * 9/10)));
        v_smooth = v_smooth - offset_elesig;
        

        %------------------------------------------------------%
        %     Calcolo la carica della popolazione ionica       %
        %------------------------------------------------------%
        
        % Effettuo fit esponenziale per la determinazione del tempo
        % caratteristico del decadimento da cui ricavare la capacità e di
        % conseguenza la carica degli ioni intrappolati
        tmin = 0.0002; tmax = 0.0008; 
        indx = find(t>tmin & t<tmax);
        myfit = fit(t(indx), v_smooth(indx), 'exp1', 'Start', [-2.5, 200]); 
        myfit_coeff = coeffvalues(myfit);
        capacity(i) = -1.0/(myfit_coeff(2) * res);

        dt = t(35123) - t(35122);

        car_ele(i) = sum(v_smooth(t>0)) * dt/res + mean(v_smooth(end-50:end)) * capacity(i);
    end
end

fprintf('\n')
car_ele = car_ele(car_ele<0);
disp(['La carica media della popolazione elettronica è pari a: ' num2str(mean(car_ele) - mean(car_ioni), 4) ' C'])