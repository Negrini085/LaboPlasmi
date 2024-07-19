%-------------------------------------------------------------------------%
%                AUTORISONANZA ---> DIFFERENZA DI FASE                    %
%-------------------------------------------------------------------------%

close all
clear all
clc

% Una delle caratteristiche principali durante il phase locking è che la
% differenza di fase fra forzante ed oscillazione del modo uno di diocotron
% rimane indicativamente costante. Se si dovesse effettuare un plot di
% Delta Phi in funzione del tempo ciò che si osserverebbe è una regione con
% distribuzione stocastica dell'osservabile in questione, legata ad un
% aggancio non ancora avvenuto, seguita da una regione pressochè costante
% con leggere oscillazioni dovute ad un tentativo del plasma di
% stabilizzarsi sul nuovo stato indicato dalla forzante.

% Per valutare la differenza di fase si utilizza l'operazione logica xor,
% applicata dopo aver avuto l'accortezza di quadratizzare le forme d'onda
% facendo tuttavia attenzione a non porre un filtro solamente su positive &
% negative, poichè se no il rumore elettronico avrebbe un'elevata influenza
% sullo studio in questione.


% Funzione che restituisce il risultato dell'operazione logica XOR
function res = XOR(sign1, sign2)
    res = zeros(1, length(sign1));
    res(sign1 .* sign2 == -1) = 1;
end

% Funzione per valutare la differenza di fase: prende in ingresso due
% vettori, che sono i segnali sui quali applicare l'operazione logica, e
% restituisce la differenza di fase
function phaseDiff = phaseDiffXOR(sign1, sign2)
    if length(sign1) ~= length(sign2)
        error("I segnali forniti come input per l'operazione logica XOR sono di lunghezza differente")
    end

    resXOR = XOR(sign1, sign2);
    phaseDiff = pi * sum(resXOR)/length(resXOR);
end


% ESEMPIO DI AGGANCIO DELLA COLONNA DI PLASMA: Vpp = 150 mV
path = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 3/Dati/Signals/aggancio_150mV/segnale02.txt';
data = fopen(path, 'rt');
N = 3; filescan = textscan(data,'%f %f %f','HeaderLines',N);
t = filescan {1,1}; vSett = filescan {1,2}; vDrive = filescan{1, 3};

% Preparo i segnali al plot
settOff = mean(vSett(1:40000)); driveOff = mean(vDrive(1:40000));
vSett = vSett - settOff; vDrive = vDrive - driveOff;
vSett = smooth(vSett, 100); vDrive = smooth(vDrive, 100); 
vSett =vSett(t<199.9); vDrive = vDrive(t<199.9); t = t(t<199.9);

% Per output con forme d'onda corrette
vSettN = vSett; vDriveN = vDrive;

% Rendo quadrate le forme d'onda (devo anche ricordarmi delle udm per
% capire che "valore" assegnare al filtro sul rumore)
vDrive(vDrive > 0.1) = 1; vDrive(vDrive < -0.1) = -1;
vSett(vSett > 0.0001) = 1; vSett(vSett < -0.0001) = -1;


% VERIFICA OPERAZIONE LOGICA XOR
% Calcolo l'operazione XOR per la regione che stiamo prendendo in
% considerazione e restituisco la differenza di fase
opLog = XOR(vSett(70000:71000), vDrive(70000:71000));

figure('Renderer', 'painters', 'Position', [10 10 800 700]);
subplot(3, 1, 1);
plot(t(70000:71000), vSett(70000:71000), 'r-'); hold on; grid on; ylim([-1.2 1.2]);
title('Indotto: quadrata'); ylabel('Potenziale (V)');

subplot(3, 1, 2);
plot(t(70000:71000), vDrive(70000:71000), 'y-'); hold on; grid on; ylim([-1.2 1.2]);
title('Forzante: quadrata'); ylabel('Potenziale (mV)');

subplot(3, 1, 3);
plot(t(70000:71000), opLog, 'y-'); hold on; grid on; ylim([-0.2 1.2]);
title('Risultato XOR'); ylabel('Potenziale (mV)'); xlabel('Tempo (ms)');



% STUDIO DELLA DIFFERENZA DI FASE
phDiff = zeros(1, length(vDrive)-1000);

for i=1:length(phDiff)
    phDiff(i) = phaseDiffXOR(vDrive(i:1000+i), vSett(i:1000+i));
end

figure('Renderer', 'painters', 'Position', [10 10 600 700]);
subplot(2, 1, 1);
plot(t(500:length(vSett)-500), vSettN(500:length(vSett)-500), 'r-'); hold on; grid on; ylim([-0.25 0.25]);
plot(t(500:length(vDrive)-500), vDriveN(500:length(vDrive)-500) * 1e-3, 'y-'); hold on; grid on; ylim([-0.25 0.25]);
title('Segnali'); ylabel('Potenziale (V)'); legend('Indotto', 'Drive', 'Location','southeast');

subplot(2, 1, 2);
plot(t(501:length(vDrive)-500), phDiff, 'b-'); hold on; grid on; ylim([-0.2 3.3]);
title('Forzante: quadrata'); ylabel('Differenza di Fase'); xlabel('Tempo (ms)')
