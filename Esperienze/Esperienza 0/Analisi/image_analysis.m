%---------------------------------------------------------------%
%    Analisi del rumore legato all'utilizzo della camera CCD    %
%---------------------------------------------------------------%

close all
clear all
clc

% PUNTO 1 ---> Stampo a video un'immagine scattata a trappola vuota e con
%              fosforo a potenziale di terra: ciò che stiamo osservando è
%              il rumore dovuto alla camera e ai vari circuiti elettronici
%              in gioco.

path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 0/Dati/CAMimages/dark2x2/dark023.tif';
M = imread(path); [row col] = size(M); M = double(M); [row col] = size(M); 
[X, Y] = meshgrid(linspace(-col/2, col/2, col), linspace(-row/2, row/2, row));
colormap('jet'); surface(X, Y, M,'FaceAlpha',1,'LineStyle','none','FaceColor','flat');
title('Rumore'); axis([ -col/2 col/2 -row/2 row/2]); daspect([1 1 1]); caxis([0 25]);
colorbar; xlabel("Colonne"); ylabel("Righe");



% PUNTO 2 ---> Faccio una media delle varie immagini di rumore per avere
%              una stima del rumore medio causato dalla camera ed evitare
%              di conseguenza delle sistematiche sperimentali

mean = zeros(1024, 1224); mean = double(mean);

for i=1:80
    if i<10
        path = ['/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 0/Dati/CAMimages/dark2x2/dark00' num2str(i) '.tif'];
    else
        path = ['/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 0/Dati/CAMimages/dark2x2/dark0' num2str(i) '.tif'];
    end
    
    appo = imread(path); appo = double(appo);
    mean = mean * (i-1)/i + appo/i;
end
figure;
[X, Y] = meshgrid(linspace(-col/2, col/2, col), linspace(-row/2, row/2, row));
colormap('jet'); surface(X, Y, mean,'FaceAlpha',1,'LineStyle','none','FaceColor','flat');
title('Rumore medio'); axis([ -col/2 col/2 -row/2 row/2]); daspect([1 1 1]); caxis([0 15]);
colorbar; xlabel("Colonne"); ylabel("Righe");



% PUNTO 3 ---> Effettuo un plot dell'immagine ad anello per valutare quanto
%              sia lungo un pixel: sarebbe ottimale effettuare la media
%              delle stime prodotte utilizzando le differenti immagini
%              scattate. Una volta effettuata la stima commento le righe di
%              codice necessarie per la produzione delle immagini, in modo
%              tale da non effettuare output inutili

figure;
M = imread('/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 0/Dati/CAMimages/ring2x2/ring0.tif'); 
[row col] = size(M); M = double(M); [row col] = size(M); 
[X, Y] = meshgrid(linspace(-col/2, col/2, col), linspace(-row/2, row/2, row));
colormap('jet'); surface(X, Y, M,'FaceAlpha',1,'LineStyle','none','FaceColor','flat');
title('Anello 1'); axis([ -col/2 col/2 -row/2 row/2]); daspect([1 1 1]); caxis([0 25]);
colorbar; xlabel("Colonne"); ylabel("Righe");

% VALORI DI RIFERIMENTO:
%        ---> Pixel alto:        408
%        ---> Pixel basso:      -429
%        ---> Pixel destro:     -419
%        ---> Pixel sinistro:    419

%figure;
%M = imread('/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 0/Dati/CAMimages/ring2x2/ring1.tif'); 
%[row col] = size(M); M = double(M); [row col] = size(M); 
%[X, Y] = meshgrid(linspace(-col/2, col/2, col), linspace(-row/2, row/2, row));
%colormap('jet'); surface(X, Y, M,'FaceAlpha',1,'LineStyle','none','FaceColor','flat');
%title('Anello 2'); axis([ -col/2 col/2 -row/2 row/2]); daspect([1 1 1]); caxis([0 25]);
%colorbar; xlabel("Colonne"); ylabel("Righe");

% VALORI DI RIFERIMENTO:
%        ---> Pixel alto:        409
%        ---> Pixel basso:      -429
%        ---> Pixel destro:     -419
%        ---> Pixel sinistro:    419

%figure;
%M = imread('/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 0/Dati/CAMimages/ring2x2/ring2.tif'); 
%[row col] = size(M); M = double(M); [row col] = size(M); 
%[X, Y] = meshgrid(linspace(-col/2, col/2, col), linspace(-row/2, row/2, row));
%colormap('jet'); surface(X, Y, M,'FaceAlpha',1,'LineStyle','none','FaceColor','flat');
%title('Anello 3'); axis([ -col/2 col/2 -row/2 row/2]); daspect([1 1 1]); caxis([0 25]);
%colorbar; xlabel("Colonne"); ylabel("Righe");

% VALORI DI RIFERIMENTO:
%        ---> Pixel alto:        409
%        ---> Pixel basso:      -429 
%        ---> Pixel destro:     -419
%        ---> Pixel sinistro:    419

% Ho trovato che l'intero diametro della trappola è costituito da 409 + 429
% pixels: l'immagine risulta essere centrata lungo le ascisse, mentre è
% leggermente fuoriasse per quanto riguarda l'asse y! Di seguito il calcolo
% per la lunghezza del singolo pixel.
lungh_pixel = 90.0/(409+429);
disp(['Un singolo pixel nelle immagini prese in considerazione è lungo: ' num2str(lungh_pixel, 3) ' mm'])



% PUNTO 4 ---> Lavoro con l'immagine della sezione della trappola in modo
%              tale da porre a zero il valore di tutti quei pixels che si
%              trovano al di fuori della trappola. Questo è un passaggio
%              necessario per la creazione di delle immagini di plasma
%              pulite: anche in questo caso andrò poi a commentare le righe
%              di codice utilizzate in quanto non è necessario che siano
%              presenti in fase finale.
%img = imread('/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 0/Dati/CAMimages/ring2x2/ring0.tif');
%[row col] = size(img); img = double(img); 

%for i = 1:row
%    for j = 1:col

        % Sono fuori oppure dentro la trappola??
%        if sqrt((i - row/2 + 10)^2 + (j - col/2)^2) > 419
%            img(i, j) = 0;
%        end
%    end
%end

%figure;
%[X, Y] = meshgrid(linspace(-col/2, col/2, col), linspace(-row/2+10, row/2+10, row));
%colormap('jet'); surface(X, Y, img,'FaceAlpha',1,'LineStyle','none','FaceColor','flat');
%title('Foto pulite: intensità pixel esterni nulle'); axis([ -col/2 col/2 -row/2+10 row/2+10]); 
%daspect([1 1 1]); caxis([0 25]); colorbar; xlabel("Ascisse"); ylabel("Ordinate");



% PUNTO 5 ---> Lavoro in modo tale da pulire le immagini di plasma che
%              abbiamo scattato: dobbiamo sottrarre il rumore medio,
%              azzerare le intensità dei pixel esterni e togliere il rumore
%              aggiuntivo dovuto alle riflessioni all'interno della
%              trappola: potrebbe aver senso fare una funzione, inoltre
%              devo verificare a livello visivo se il plasma è stato
%              prodotto bene oppure no (sono sicuro che almeno una immagine
%              sia cannata).
conta = 1; intensita_media = 0.0;
for i=1:33
    if i<10
        path = ['/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 0/Dati/CAMimages/plasma/plasma00' num2str(i) '.tif'];
    else
        path = ['/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 0/Dati/CAMimages/plasma/plasma0' num2str(i) '.tif'];
    end
    
    % Scarto l'immagine di plasma che è venuta male
    if i~=7

        % Leggo l'immagine e tolgo il rumore elettronico legato allo
        % strumento che viene utilizzato: se alcune entrate dei pixel
        % risultano essere negative, poniamo di default a zero il valore
        % dell'intensità.
        M = imread(path); M = double(M); 
        M = M - mean; [row col] = size(M);
        for h = 1:row
            for k = 1:col
                if M(h, k) < 0
                    M(h, k) = 0;
                end
            end
        end
        
        % Pongo a zero i valori dei pixel al di fuori della trappola di
        % Penning: così facendo non ho dell'informazione legata al rumore
        % elettronico della camera e posso concentrarmi solamente sul
        % plasma
        for h = 1:row
            for k = 1:col
                % Sono fuori oppure dentro la trappola??
                if sqrt((h - row/2 + 10)^2 + (k - col/2)^2) > 419
                    M(h, k) = 0;
                end
            end
        end

        % Fornisco una stima delle dimensioni del plasma: indicativamente 
        % abbiamo che il plasma ha un raggio di 300 pixels. Possiamo
        % togliere il rumore aggiuntivo dovuto alle riflessioni sui bordi
        % della trappola
        media_rifl = 0.0; appo = 1;
        for h = 1:row
            for k = 1:col
                rag = sqrt((h - row/2 + 10)^2 + (k - col/2)^2);
                if  rag < 419 && rag > 300
                    media_rifl = media_rifl * double(appo - 1)/appo + M(h, k)/double(appo); 
                    appo = appo + 1;
                end
            end
        end
        
        for h = 1:row
            for k = 1:col
                rag = sqrt((h - row/2 + 10)^2 + (k - col/2)^2);
                if  rag < 419 && rag > 300
                    M(h, k) = M(h, k) - media_rifl;
                    if M(h, k) < 0
                        M(h, k) = 0;
                    end
                end
            end
        end
        
        % Ho effettuato le necessarie migliorie alle immagini di plasma
        % scattate con la camera ccd: voglio ora procedere salvandole a
        % file in modo tale da avere a disposizione, volendo, le immagini
        % correttamente elaborate.
        M = uint16(M); path = ['/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 0/Analisi/PlasmaPulite/plasma_pulita' num2str(conta) '.tif'];
        imwrite(M, path); 
        
        % Valuto quale sia la somma dei valori dei pixel per le 32 immagine
        % pulite ottenute scartando l'immagine 7
        intensita = sum(sum(M));
        intensita_media = intensita_media * (conta - 1.0)/conta + intensita/conta;         
        conta = conta + 1;
    end

end

figure;
M = imread('/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 0/Analisi/PlasmaPulite/plasma_pulita17.tif'); 
[row col] = size(M); M = double(M); [row col] = size(M); 
[X, Y] = meshgrid(linspace(-col/2, col/2, col), linspace(-row/2, row/2, row));
colormap('jet'); surface(X, Y, M,'FaceAlpha',1,'LineStyle','none','FaceColor','flat');
title('Immagine di plasma: assenza rumore'); axis([ -col/2 col/2 -row/2 row/2]); daspect([1 1 1]); 
colorbar; xlabel("Colonne"); ylabel("Righe");

fprintf('\n')
disp(["L'intensità media dell'immagine di plasma sul campione di 32 scatti effettuati è" num2str(intensita_media, 4)])