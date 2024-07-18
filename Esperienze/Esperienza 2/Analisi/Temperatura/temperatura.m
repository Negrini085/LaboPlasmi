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
    plot(t, v, 'r.', 'MarkerSize', 10); hold on; grid on;
    plot(t, v_fit, 'g-', 'LineWidth', 2); hold on; grid on;
    legend('Discharge', 'Fit'); xlabel('Potenziale (V)'); ylabel('log(Q_e/Q_t)'); title('Stima temperatura')
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
        t = filescan {1,1}; v = filescan {1,2}; v = -udmv * v;
        
        % Sottraggo il rumore dal segnale appena letto e poi effettuo lo
        % smoothing su 100 cellette adiacenti
        vCum = v - v_noise; vCum = smooth(vCum, 100); dt = (t(1350) - t(1340))*1e-6/10;

        % Contenitori per i futuri sviluppi del codice, vogliamo calcolare
        % la cumulativa discretizzata
        chCum = zeros(1, 200); vConf = -99.5:0.5:0; res = 1e6;

        % Calcolo della cumulativa, sfrutto il fatto che i gradini hanno durata di
        % due microsecondi per creare un filtro che consenta di valutare la carica
        % uscita ad un certo istante di tempo e per un certo valore di potenziale
        % confinante
        for j=1:200
            chCum(j) = sum(vCum(t < 2*j) * dt/res) + cap * mean(vCum(2 * (j-1) < t & t < 2*j));
        end

        [chMax, ind] = max(chCum);
        vConf = vConf(1:ind); chCum = chCum(1:ind);

        % Ora che ho la carica cumulata, quello che mi manca da fare è
        % selezionare la regione di cui mi interessa effettivamente di fare
        % il fit. Prima di effettuare questo passaggio, devo però vedere se
        % con la richiesta di limite superiore qmax selezionata
        % dall'utente sto andando oltre alla regione interessata dallo zoom
        if chMax < qtot * qmax/100
            error('Limite superiore troppo grande, si prega di ridurlo');
        end

        % Lavoriamo ora in modo tale da determinare la temperatura del plasma
        % prendendo la seguente regione della carica cumulativa [0.5, 3.5]%.
        chFit = chCum(qmin/100 * qtot < chCum & chCum < qmax/100 * qtot);
        vFit = vConf(qmin/100 * qtot < chCum & chCum < qmax/100 * qtot);
        

        % Faccio il fit lineare nella regione interessata dal fenomeno
        myfit = polyfit(vFit, log(chFit/qtot), 1); 
        temp(i) = 1/myfit(1);

        if i == 3
            grafico_T(vFit,log(abs(chFit)/qtot), polyval(myfit, vFit))
        end

        fprintf(new_data,  '%s \n', [num2str(i) '    ' num2str(temp(i))]);
    end
end
    

n = 20; udmt = 1e-6; udmv = 1e-3; name = 'segnale';
path_rum = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 2/Dati/Signals/rumore_zoom_bump/no_off';
path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 2/Dati/Signals/scarica_ramp_zoom/no_off';
path_out = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 2/Analisi/Temperatura/Risultati/temp_';

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
