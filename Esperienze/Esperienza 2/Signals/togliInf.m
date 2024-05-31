%-------------------------------------------------------%
%          Procedura per togliere gli infiniti          %
%-------------------------------------------------------%

base = '/home/filippo/Desktop/CODICINI/LABO_PLASMI/Esperienze/Esperienza 3/Signals/auto_risonanza/';
name = 'auto_risonanza_';
new_name = 'segnale';
nfiles = input('numer of file: \n');
max = 0;

 

for i = 1:nfiles

    filedata = fopen( strcat(base, name, num2str(i), '.txt'), 'r');
    new_data = fopen( strcat(base, new_name, sprintf('%02i', i),'.txt' ),'w');

    while ~feof(filedata)

        tline = num2str(fgetl(filedata));

        if contains( tline , '∞' )

            tline = replace(tline, '∞', int2str(max));

        end

        fprintf(new_data, '%s \n', tline);

    end
    
    disp(['Pulito file numero: ' num2str(i)])
    fclose("all");                          

end