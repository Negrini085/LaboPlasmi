% Funzione per togliere gli offset ai segnali utilizzati per lo studio
% della temperatura del plasma (questo perchè per avere una miglior 
% risoluzione in fase di scarica abbiamo deciso di lavorare offsettando 
% artificialmente i segnali)
function noOffset(path, name, num, off, s_udmt, s_udmv)
    
    % Ciclo sul numero di segnali specificato
    for i=1:num

        % Leggo il file di input, con segnale da correggere 
        data = fopen(strcat(path, '/', name, sprintf('%02i', i),'.txt'), 'rt');
        N = 3; filescan = textscan(data,'%f %f','HeaderLines',N);
        t = filescan {1,1}; v = filescan {1,2};
        
        % Letto completamente il file, tolgo il valore di offset
        v = v - off;
        
        % Stampo a file il contenuto del file corretto per la presenza
        % dell'offset (non sovrascrivo, infatti ho delle altre cartelle 
        % chiamate no off)
        clean_data = fopen( strcat(path, '/no_off/', name, sprintf('%02i', i),'.txt' ),'w');
        
        % Intestazione file di output
        fprintf(clean_data, ['Tempo (' s_udmt ') \t Tensione (' s_udmv ')\n']);
        fprintf(clean_data, '\n');
        fprintf(clean_data, '\n');
        
        % Scrivi i dati nel file
        for j = 1:length(t)
            fprintf(clean_data, '%f\t%f\n', t(j), v(j));
        end

        fclose(clean_data);
        fclose(data);

    end
end

% In seguito riporto gli offset da sottrarre per i vari segnali presi in
% analisi:
%           ---> rumore_zoom_bump:        0 mV
%           ---> scarica_ramp_zoom:     180 mV
%           ---> rumore_zoom:           180 mV
%           ---> scarica_ramp_totale:   0.4 mV


path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 2/Dati/Signals/rumore_zoom_bump';
noOffset(path, 'segnale', 20, 0, 'us', 'mv')
disp("Terminata rimozione dell'offset per: rumore_zoom_bump")

path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 2/Dati/Signals/scarica_ramp_zoom';
noOffset(path, 'segnale', 20, 180, 'us', 'mv')
disp("Terminata rimozione dell'offset per: scarica_ramp_zoom")

path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 2/Dati/Signals/rumore_zoom';
noOffset(path, 'segnale', 20, 180, 'us', 'mv')
disp("Terminata rimozione dell'offset per: rumore_zoom")

path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 2/Dati/Signals/scarica_ramp_totale';
noOffset(path, 'segnale', 20, 0.4, 'us', 'V')
disp("Terminata rimozione dell'offset per: scarica_ramp_totale")

