% February 2014 ELTRAP electrostatic potential

% enter electrode potentials [V]
% prompt is a cell array containing strings
% (which will be the labels of each input box)
prompt={'SH','C8','C7','C6','S4','C5','S2','C4','S8','C2','C1','GND'};
% assign default values (optional, but possibly saves time)
default={'0','-10','0','0','0','0','0','0','0','0','-10','0'};
%dialogue title
dlgtitle = 'Electrode voltages';
% answer will contain the inputs in string format
answer=inputdlg(prompt,dlgtitle,[1 50],default);
% convert values from strings to numbers (voltages)
v(1)=str2num(answer{1});
v(2)=str2num(answer{2});
v(3)=str2num(answer{3});
v(4)=str2num(answer{4});
v(5)=str2num(answer{5});
v(6)=str2num(answer{6});
v(7)=str2num(answer{7});
v(8)=str2num(answer{8});
v(9)=str2num(answer{9});
v(10)=str2num(answer{10});
v(11)=str2num(answer{11});
v(12)=str2num(answer{12});

% enter radial position for V calculation and plot color
prompt1={'Radial position','Plot color'};
default1={'0.000','b'};
answer1=inputdlg(prompt1,'Plot parameters',1,default1);
% save values
r=str2num(answer1{1});

% lengths - inner electrodes shortened 1 mm for the gaps
z(1)=0; z(2)=z(1)+149.5e-3;             % SH
z(3)=z(2)+1e-3; z(4)=z(3)+89e-3;        % C8
z(5)=z(4)+1e-3; z(6)=z(5)+89e-3;        % C7
z(7)=z(6)+1e-3; z(8)=z(7)+89e-3;        % C6
z(9)=z(8)+1e-3; z(10)=z(9)+149e-3;      % S4
z(11)=z(10)+1e-3; z(12)=z(11)+89e-3;    % C5
z(13)=z(12)+1e-3; z(14)=z(13)+149e-3;   % S2
z(15)=z(14)+1e-3; z(16)=z(15)+89e-3;    % C4
z(17)=z(16)+1e-3; z(18)=z(17)+149e-3;   % S8
z(19)=z(18)+1e-3; z(20)=z(19)+89e-3;    % C2
z(21)=z(20)+1e-3; z(22)=z(21)+89e-3;    % C1
z(23)=z(22)+1e-3; z(24)=z(23)+89.5e-3;  % GND


N=12; % number of electrodes
Nmax=3000; % truncation of the series
pace=.5e-4;
zx=z(1):pace:z(24);
L=z(24);
Rw=0.045;
%r=0.042;

term1=0;
phi=zeros(1,length(zx));

for n=1:Nmax
    kn=n*pi/L;
    kn2=kn^2;
    term1=(v(1)*cos(kn*z(1))-v(N)*cos(kn*z(2*N)))/kn;
    term2=0;
    
    for i=1:N-1
        term2=term2+((v(i+1)-v(i))/(z(2*i+1)-z(2*i))*(sin(kn*z(2*i+1))-sin(kn*z(2*i)))/kn2);
    end
    phi=phi+(term1+term2)*besseli(0,kn*r)/besseli(0,kn*Rw)/L*2*sin(kn*zx);
end

plot(zx-L/2,phi,answer1{2}); hold on; grid on
xlim([-1.05*L/2 1.05*L/2])
%xlim([-0.25 0.15])
%y=phi';
%fid=fopen('phi.txt','w');
%fprintf(fid,'%6.6e\n',y);
%fclose(fid)
