%-------------------------------------------------------------------------%
%                 Analisi dei segnali per la calibrazione                 %
%-------------------------------------------------------------------------%

close all
clear all
clc


% Funzione che consente di studiare quale sia lo smoothing ottimale da
% applicare: forniamo come parametri il cammino per giungere al file di
% nostro interesse ed il numero minimo di punti sui quali provare a fare lo
% Smoothig. Nella funzione è presente un ciclo che viene eseguito cinque
% volte 
function studioSmoothing(path, n_min)
    data = fopen(path, 'rt');
    N = 3; filescan = textscan(data,'%f %f','HeaderLines',N);
    t = filescan {1,1}; v = filescan {1,2};
    
    figure;
    plot(t, v, 'k-'); hold on; grid on;

    for m=1:5
        Navg = m * n_min + 1;      % Scelgo a runtime il numero di punti da considerare per lo smooth
        plot(t, smooth(v, Navg)); hold on; grid on;
    end
    legend('Data', ['N = ' num2str(n_min)], ['N = ' num2str(2*n_min)], ['N = ' num2str(3*n_min)],['N = ' num2str(4*n_min)] ,['N = ' num2str(5*n_min)])
    title('Studio smoothing')
end



% Funzione che consente di determinare quale sia la carica della scarica
% presa in analisi: il segnale deve essere fornito in modulo, poichè la
% funzione andrà a ricercare il massimo della differenza di potenziale
% presente. I parametri di input sono:
%       --> path per giungere ai segnali
%       --> radice del nome del file
%       --> numero di segnali
%       --> resistenza in gioco
%       --> udm tempo
%       --> udm potenziale
%       --> numero punti per smoothing
%       --> condizione se ionica o elettronica
% La funzione in questione restituisce un vettore i cui elementi sono le
% cariche degli n segnali presi in considerazione.
function car = carica_segnale(path, nome, n_sig, res, t_udm, v_udm, Navg, logic)
    car = zeros(n_sig, 1);
    for i=1:n_sig

        % Apro il file, carico i vettori e riscalo opportunamente
        data = fopen([path '/' nome sprintf('%02i', i) '.txt'], 'rt');
        N = 3; filescan = textscan(data,'%f %f','HeaderLines',N);
        t = filescan {1,1}; v = filescan {1,2}; t = t_udm * t; v = v_udm * v;

        if logic == 1
            v = -v;
        end
                
        % Effettuo smoothing del segnale e ne trovo il massimo: l'indice
        % della casella contenete tale valore verrà utilizzato per
        % effettuare lo studio del signal offset
        v_smooth = smooth(v, Navg);
        [v_max, ind] = max(v_smooth);
        
        % Calcolo l'offset: per fare questo lavoro prendiamo in
        % considerazione tutti quei valori di potenziale che corrispondono
        % a valori temporali precedenti a t(ind * 9/10)
        offset = mean(v_smooth(1:int32(ind * 9/10)));
        v_smooth = v_smooth - offset;

        % Calcolo la carica costituente il segnale: devo considerare due
        % contributi. Il primo è l'integrale della corrente passante per
        % l'oscilloscopio: tale valore deve essere corretto per il
        % potenziale rimanente (valutato come media degli ultimi 100 valori
        % presi)
        myfit = fit(t(ind + 200:int32(4/5 * length(t))), v_smooth(ind + 200:int32(4/5 * length(t))), 'exp1', 'Start', [-2.5, 200]); 
        myfit_coeff = coeffvalues(myfit);
        c = -1.0/(myfit_coeff(2) * res);

        dt = t(35123) - t(35122);
        car(i) = sum(v_smooth(t>0)) * dt/res + mean(v_smooth(end-100:end)) * c;

    end
end




                %------------------------------------%
                %       STUDIO SCARICA IONICA        %
                %------------------------------------%

% Dopo aver utilizzato la funzione per l'imposizione dello smoothing,
% decidiamo di lavorare considerando 100 punti per fare le medie che
% consentono di lisciare il segnale.
Navg = 100; nome = 'idischarge_';
path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Dati/Signals/calibration/idischarge';
car_ioni = carica_segnale(path, nome, 20, 1e6, 0.001, 0.001, 100, 0);
disp(['La carica media della popolazione ionica è pari a: ' num2str(mean(car_ioni), 4) ' C'])




                %------------------------------------%
                %     STUDIO SCARICA ELETTRONICA     %
                %------------------------------------%

% Dopo aver utilizzato la funzione per l'imposizione dello smoothing,
% decidiamo di lavorare considerando 100 punti per fare le medie che
% consentono di lisciare il segnale.
Navg = 100; nome = 'edischarge_';
path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Dati/Signals/calibration/edischarge';
car_ele = carica_segnale(path, nome, 26, 1e6, 0.001, 1, 100, 1);
disp(['La carica media della popolazione elettronica è pari a: ' num2str(-mean(car_ele), 4) ' C'])