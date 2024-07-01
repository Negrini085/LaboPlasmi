%-------------------------------------------------------------------------%
%                  Calcolo della temperatura di plasma                    %
%-------------------------------------------------------------------------%

close all
clear all
clc

% Calcolo della temperatura di plasma: per determinarla ci avvaliamo delle 
% scariche ottenute con graduale abbassamento della barriera di potenziale.
% In scala logaritmica, il coefficiente angolare della retta che si ottiene 
% fittando sulla prima regione della scarica, è pari all'opposto dell'
% inverso della temperatura parallela. Vogliamo determinare la temperatura 
% parallela per diversi intervalli di scarica (sempre posti nella regione 
% iniziale della scarica totale)

% Funzione che consente di determinare quale sia il rumore medio da
% sottrarre alla scarica: per fare questo mediamo sui campioni di rumore
% zoom che abbiamo preso in fase di raccolta dati.
function rumSign = signalNoise(path, name, n, udmv)

    rumSign = 0;
    for i=1:n

        % Apro il file, carico i vettori e riscalo opportunamente
        data = fopen([path '/' name sprintf('%02i', i) '.txt'], 'rt');
        N = 3; filescan = textscan(data,'%f %f','HeaderLines',N);
        v = filescan {1,2}; v = - udmv * v;

        % Sommo membro a membro le varie istanze di rumore zoom ottenute in
        % fase di calibrazione
        rumSign = rumSign + v;
    end
    
    % Faccio la media in modo tale da restituire il rumore medio
    rumSign = rumSign/n;
end



% Funzione per stampare a video il grafico del fit
function grafico_T(t, v, v_fit)
    figure;
    plot(t, v, 'g-'); hold on; grid on;
    plot(t, v_fit, 'r-', 'LineWidth', 2); hold on; grid on;
    legend('Discharge', 'Fit'); xlabel('Energia(eV)'); ylabel('log(Q_e/Q_t)'); title('Stima temperatura')
end



% Funzione per l'effettivo calcolo della temperatura parallela di plasma.
% Consente di effettuare il fit specificando limite minimo e limite massimo
% della carica uscita in modo tale da selezionare la regione desiderata.
function temp = tempPlasma(path, path_rum, pathOut, name, n, cap, qmin, qmax, qtot, udmt, udmv)

    % Determino se i limiti dell'intervallo su cui vogliamo fare il fit
    % lineare siano ammessi oppure no
    if (qmin < 0.1) | (qmin > 1)
        error('Il valore %d è al di fuori dell''intervallo [0.1, 1]. Interruzione della funzione.', qmin);
    end

    if (qmax < 1) | (qmax > 10)
        error('Il valore %d è al di fuori dell''intervallo [1, 10]. Interruzione della funzione.', qmax);
    end

    % Contenitori per salvataggio in memoria delle stime di temperatura e
    % stream per stampare le varie stime effettuate
    temp = zeros(n, 1);
    new_data = fopen([pathOut num2str(qmin/100) '_' num2str(qmax/100) '.txt' ],'w');
    fprintf(new_data, '%s \n', 'Numero segnale     Temperatura valutata');

    % Valuto quale sia il rumore da sottrarre ai segnali di scarica zoomati
    v_noise = signalNoise(path_rum, name, n, udmv);
   
    % Dato che ho 20 segnali di scarica zoomati, siamo interessati  
    for i=1:n

        % Leggo il file che contiene lo zoom della scarica
        data = fopen([path '/' name sprintf('%02i', i) '.txt'], 'rt');
        N = 3; filescan = textscan(data,'%f %f','HeaderLines',N);
        t = filescan {1,1}; v = filescan {1,2}; t = t * udmt; v = -udmv * v;

        % Sottraggo il rumore dal segnale appena letto e poi effettuo lo
        % smoothing su 100 cellette adiacenti
        v = v - v_noise;
        v = smooth(v, 100);
         
        % Lavoro sul vettore delle differenze di potenziale in modo tale
        % che ogni celletta contenga la carica associata ad un tale segnale
        % in corrente
        res = 1e6; dt = (t(35123) - t(35112))/10; car = v * dt/res;

        % Creo la carica cumulata, devo però tenere anche conto della
        % carica che è stata intrappolata nella capacità parassita presente
        % nel circuito
        chCum = cumsum(car) + cap * v;

        % Ora che ho la carica cumulata, quello che mi manca da fare è
        % selezionare la regione di cui mi interessa effettivamente di fare
        % il fit. Prima di effettuare questo passaggio, devo però vedere se
        % con la richiesta di limite superiore qmax selezionata
        % dall'utente sto andando oltre alla regione interessata dallo zoom
        [v_max, ind] = max(v);
        if chCum(ind) < qtot * qmax/100
            error('Limite superiore troppo grande, si prega di ridurlo');
        end

        ch_fit = chCum(((qtot * (qmin/100)) < chCum) &  (chCum < qtot * (qmax/100)));
        t_fit = t(((qtot * (qmin/100)) < chCum) &  (chCum < qtot * (qmax/100)));
        
        
        % Devo determinare l'ascissa del fit lineare: tale quantità è
        % l'energia "di uscita" delle particelle.
        cAng = 0.5/2e-6;
        en = 100 - cAng * (t_fit + 5e-5);


        % Effettuo il fit e determino la stima della temperatura partendo
        % dal coefficiente angolare ottenuto. Tale valore viene sia salvato
        % per essere stampato a video, che stampato in un file
        myfit = polyfit(en, log(ch_fit/qtot), 1); 
        temp(i) = -1/myfit(1);

        if i == 3
            grafico_T(en,log(ch_fit/qtot), polyval(myfit, en))
        end

        fprintf(new_data,  '%s \n', [num2str(i) '    ' num2str(temp(i))]);
    end
end
    

n = 20; udmt = 1e-6; udmv = 1e-3; name = 'segnale';
path_rum = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 2/Dati/Signals/rumore_zoom_bump/no_off';
path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 2/Dati/Signals/scarica_ramp_zoom/no_off';
path_out = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 2/Analisi/StudioTemperatura/Risultati/Temperatura/temp_';

prompt={'Capacity','Total charge','Lower bound','Upper bound'};
default={'4.393e-10','5.564e-10','0.5','3.5'};
dlgtitle = 'Temperature';
answer=inputdlg(prompt,dlgtitle,[1 50],default);
cap = str2num(answer{1});
qtot = str2num(answer{2});
qmin = str2num(answer{3});
qmax = str2num(answer{4});

stima_temp = tempPlasma(path, path_rum, path_out, name, n, cap, qmin, qmax, qtot, udmt, udmv);
disp(' ')
disp(['La temperatura media è pari a: ' num2str(mean(stima_temp), 4) ' +/- ' num2str(std(stima_temp), 4)])
