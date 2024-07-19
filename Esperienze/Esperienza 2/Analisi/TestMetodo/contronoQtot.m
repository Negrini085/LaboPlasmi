%-------------------------------------------------------------------------%
%           Metodo per confrontare la carica totale del plasma            %
%                 calcolata dalla scarica ramp totale                     %
%-------------------------------------------------------------------------%

% Il confronto è fatto su un singolo segnale di scarica ramp, ci aspettiamo
% di ottenere indicativamente lo stesso valore di carica totale in uscita

% Apro il file, carico i vettori e riscalo opportunamente
data = fopen('/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 2/Dati/Signals/scarica_ramp_totale/no_off/segnale02.txt', 'rt');
N = 3; filescan = textscan(data,'%f %f','HeaderLines',N);
t = filescan {1,1}; v = filescan {1,2}; t = 1e-6 * t; v = - v;

% Effettuo smoothing del segnale
v_smooth = smooth(v, 100);
        
% Valuto quanto valga l'offset del segnale (per fare questo
% considero il valor medio delle prime 1000 celle del segnale e lo
% sottraggo a tutta la successiva scarica
offset = mean(v_smooth(1:1001));
v_smooth = v_smooth - offset;
        
dt = (t(35133) - t(35122))/10; res  = 1e6; cap = 4.393e-10;

% METODO UNO --> Integro il segnale totale e poi tengo conto degli efetti
% capacitivi solamente sulla coda della scarica stessa
car = sum(v_smooth) * dt/res + mean(v_smooth(end-100:end)) * cap;
disp(['La carica integrando il segnale totale risulta essere pari a: ' num2str(car, 4) ' C'])


% METODO DUE --> Integro il segnale solo fino al picco, quando la carica è
% tutta uscita, e poi considero gli effetti capacitivi
[maxV, ind] = max(v_smooth);
car = sum(v_smooth(1:ind)) * dt/res + maxV * cap;
disp(['La carica fermandosi al picco risulta essere pari a: ' num2str(car, 4) ' C'])