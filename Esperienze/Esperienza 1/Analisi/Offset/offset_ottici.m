%-------------------------------------------------------------------------%
%                     Prova di studio degli offset                        %
%-------------------------------------------------------------------------%
path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 1/Dati/Signals/series1_200ms/run1/';

M = zeros(3, 3);

for i=1:3
    for j=1:3
        M(i, j) = 3 * (i-1) + j;
    end
end
sum(M')