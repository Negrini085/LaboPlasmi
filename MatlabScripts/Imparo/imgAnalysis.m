close all
clear all
clc

%------------------------------------------------------------%
%               Immagine per lo studio del plasma            %
%------------------------------------------------------------%
figure(1)
% Ciò che plottiamo ora è una superficie in uno spazio a tre dimensioni
% L'ordinata è legata all'intensità della luce uscente che viene catturata
% dalla camera ccd: il comando per effettuare il plot necessario è surface
M = imread("plasma.tiff");  M = double(M);
% Rendo M a valori double perchè se no rischio di perdere dell'informazione
% nel momento in cui faccio delle operazioni sui pixels (come per esempio divisioni 
% o altre operazioni di questo genere, che se fatte su interi non sono 
% rappresentative della vera operazione in atto)
[row col] = size(M);
colormap('jet') % Scelgo quale sia la scala di colori da utilizzare
surface(M,'FaceAlpha',1,'LineStyle','none','FaceColor','flat');
% Comando per stampare la superficie: dato che non sono specificate x ed y, 
% per definire le ascisse e le ordinate dei punti verranno considerati gli
% indici di riga e di colonna della matrice M
% Le opzioni 'FaceAlpha', 1, sono legate all'opacità dell'immagine, in
% particolare verrà settata all'unità, quindi la superficie non risulterà
% per nulla trasparente
% Le opzioni 'LineStyle', 'none' fanno sì che non venga disegnata alcuna
% linea delimitante le facce: questo è necessario perchè essendo i pixel
% molto piccoli ciò che vedremmo sarebbe un'immagine nera
% Le opzioni 'FaceColor','flat' fanno sì che ogni faccia sia colorata tutta
% dello stesso colore: questo serve perchè noi vogliamo ottenere delle
% misure precise sulle dimensioni della trappola e del plasma e colori
% sfumati non ci aiuterebbero
axis([1 col 1 row]); % Fisso i limiti degli assi: da 1 a col & da 1 a row 
daspect([1 1 4]);   % Imposto i rapporti fra gli assi: in questo caso le udm sono uguali per asse x ed y
colorbar    % Aggiungo la colorbar a bordo del plot
xlabel("Colonne")
ylabel("Righe")
title("Intensità catturata: non centrata")


%------------------------------------------------------------%
%              Versione più carina e sviluppata              %
%------------------------------------------------------------%
figure(2)
y = linspace(-row/2, row/2, row);   % Linspace consente di generare dei valori separati da intervalli regolari
x = linspace(-col/2, col/2, col);   % Input sono: inizio della scala, fine della scala e numero di passi da effettuare
[X, Y] = meshgrid(x,y);   % Creo una griglia di valori, non voglio più utilizzare gli indici per i plot
colormap('jet')
surface(X, Y, M,'FaceAlpha',1,'LineStyle','none','FaceColor','flat');
axis([-col/2 col/2 -row/2 row/2]);
daspect([1 1 4]);
colorbar
xlabel("Colonne")
ylabel("Righe")
title("Intensità catturata: centrata")