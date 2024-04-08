%--------------------------------------------------%
%                    Compito 6                     %
%--------------------------------------------------%

% Creare una funzione che consenta in modo automatico di aprire un immagine
% e crearne un surface-plot nel momento in cui con editor classici non sia
% possibile visualizzarla correttamente ---- Le dimensioni tipiche delle
% immagini scattate in laboratorio sono 512 righe e 688 colonne

function img = OpenImage(name, width, height, titolo)

    img = imread(name); img = double(img); [row col] = size(img);

    % Controllo sulle dimensioni: ho caricato l'immagine corretta??
    if row == height
        if col == width
            disp("Il caricamento dell'immagine è avvenuto correttamente")
        else
            disp("L'immagine caricata ha una larghezza differente da quella dichiarata!!")
        end
    else
        disp("L'immagine caricata ha un'altezza differente da quella dichiarata!!")
    end

    % Creo il plot richiesto: dato che tutte le immagini che utilizzeremo
    % saranno di plasma con la colonna indicativamente posta al centro
    % dell'immagine stessa utilizzo il metodo fancy e faccio variare gli
    % assi da -col/2 a col/2 e da -row/2 a row/2
    figure;
    [X, Y] = meshgrid(linspace(-col/2, col/2, col), linspace(-row/2, row/2, row));
    colormap('jet'); surface(X, Y, img,'FaceAlpha',1,'LineStyle','none','FaceColor','flat');
    title(titolo); axis([ -col/2 col/2 -row/2 row/2]); daspect([1 1 4]); colorbar; xlabel("Colonne"); ylabel("Righe");

end

prova = OpenImage('plasma.tiff', 688, 512, 'Plasma');