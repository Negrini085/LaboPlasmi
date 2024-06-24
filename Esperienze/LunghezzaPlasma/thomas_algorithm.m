%-------------------------------------------------------------------------%
%                          Thomas agorithm                                %
%-------------------------------------------------------------------------%

close all
clear all
clc

function result = thomas(matrix, known)
    dim = size(matrix);
    matrix = double(matrix); known = double(known);

    % Controllo quali siano le dimensioni della matrice in analisi
    if dim(1) ~= dim(2) 
        disp("La matrice fornita all'algoritmo di Thomas non è quadrata.")
    end

    if dim(2) ~= length(known)
        disp("Matrice e vettore non hanno dimensioni corrette per il prodotto matriciale riga per colonna.")
    end

    result = zeros(1, length(known));

    % Effettuo l'iterazione, sia sulla matrice che sui termini noti
    for i=1:(dim(1)-1)
        fact = (matrix(i+1, i)/matrix(i, i));
        matrix(i+1, :) = matrix(i+1, :) - fact * matrix(i, :);      % Cambio il valore dell'(i+1)-esima riga
        known(i+1) = known(i+1) - fact * known(i);                  % Cambio il valore dell'(i+1)-esimo termine noto
    end

    % Svolgo l'effettivo calcolo per il risultato
    result(length(known)) = known(length(known))/matrix(length(known), length(known));
    for i=1:(length(known)-1)
        result(length(known)-i) = (known(length(known)-i) - ...
            matrix(length(known)-i, length(known)-i+1) * result(length(known)-i + 1))/matrix(length(known)-i, length(known)-i);
    end

end

% Prima casistica per benchmark del metodo
m = zeros(3);
m(1, :) = [2, 1, 0];
m(2, :) = [1, 2, 3];
m(3, :) = [0, 1, -1];

noti = [0, 0, 1];
thomas(m, noti)         % Funziona, daje roma daje


% Seconda casistica per benchmark del metodo
a = zeros(3);
a(1, :) = [2, 1, 0];
a(2, :) = [1, 2, 3];
a(3, :) = [0, 1, -1];

notii = [1, -1, 1];
thomas(a, notii)