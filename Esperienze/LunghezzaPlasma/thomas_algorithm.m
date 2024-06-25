%-------------------------------------------------------------------------%
%                          Thomas agorithm                                %
%-------------------------------------------------------------------------%

close all
clear all
clc

%-------------------------------------------------------------------------%
%        Funzione per risolvere un sistema tridiagonale trattando         %
%                   la matrice nella sua interezza                        %
%-------------------------------------------------------------------------%
function result = thomasMat(matrix, known)
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


%-------------------------------------------------------------------------%
%        Funzione per risolvere un sistema tridiagonale trattando         %
%                    le sole diagonali principali                         %
%-------------------------------------------------------------------------%
function res = thomasDiag(a, b, c, n)
    if (length(a) ~= (length(b) - 1)) | (length(c) ~= (length(b)-1))
        disp("Dimensioni delle diagonali errate: controllare come vengono passati gli argomenti");
    end

    for i=1:length(a)
        fact = c(i)/b(i);
        c(i) = 0; b(i+1) = b(i+1) - fact * a(i);
        n(i+1) = n(i+1) - fact * n(i);
    end
    
    res = zeros(length(b), 1);
    res(length(b)) = n(length(b))/b(length(b));
    for i=1:length(b)-1
        res(length(b)-i) = (n(length(b)-i) - a(length(b)-i)*res(length(b)-i+1))/b(length(b)-i);
    end
end

%-------------------------------------------------------------------------%
%                           Test per thomasMat                            %
%-------------------------------------------------------------------------%

% Prima casistica per benchmark del metodo
m = zeros(3);
m(1, :) = [2, 1, 0];
m(2, :) = [1, 2, 3];
m(3, :) = [0, 1, -1];

noti = [0, 0, 1];
thomasMat(m, noti)         % Funziona, daje roma daje


% Seconda casistica per benchmark del metodo
a = zeros(3);
a(1, :) = [2, 1, 0];
a(2, :) = [1, 2, 3];
a(3, :) = [0, 1, -1];

notii = [1, -1, 1];
thomasMat(a, notii)


% Terza casistica per benchmark del metodo
b = zeros(4);
b(1, :) = [1, -3, 0, 0];
b(2, :) = [1, -1, 1, 0];
b(3, :) = [0, 3, 1, 1];
b(4, :) = [0, 0, 1, 2];

notiii = [1, 2, 4, 0];
thomasMat(b, notiii)


%-------------------------------------------------------------------------%
%                          Test per thomasDiag                            %
%-------------------------------------------------------------------------%

diag1 = [1, 3]; diagP = [2, 2, -1];
diag2 = [1, 1]; known = [0, 0, 1];

thomasDiag(diag1, diagP, diag2, known)


diag1 = [1, 3]; diagP = [2, 2, -1];
diag2 = [1, 1]; known = [1, -1, 1];

thomasDiag(diag1, diagP, diag2, known)


diag1 = [-3, 1, 1]; diagP = [1, -1, 1, 2];
diag2 = [1, 3, 1]; known = [1, 2, 4, 0];

thomasDiag(diag1, diagP, diag2, known)