% Create a pifa antenna
% Generated by MATLAB(R) 9.11 and Antenna Toolbox 5.1.
% Generated on: 20-Dec-2021 17:47:33

%% Antenna Properties 
clear all
f = 2.1e9;
p = design(pifa, f);

% W = 0.0370;
% L = 0.0160;

W= 0.0351; 
L = 0.0158; 

% NON OPTIMIZED VALUES FOR MESH OPT
% W = 0.0372;
% L = 0.0160; 

h = 0.0008;
lambda0 = physconst('Lightspeed')/f; 
k0=2*pi/lambda0;
p.Length = L;
p.Width = W;
p.Height = h;
p.Substrate.Name = 'FR4';
p.Substrate.EpsilonR = 4.8;
p.Substrate.LossTangent = 0.026;
p.Substrate.Thickness = h;
p.ShortPinWidth = W;
p.PatchCenterOffset = [0 0];
Rr = (120*lambda0/W)*(1-(1/24)*(k0*h)^2)^(-1);
Rin = 50;
% FEED POINT 
lfeed= 0.0067;
wfeed = 0.0010;
% wfeed = 0;
% lfeed = (L/pi)*acos(sqrt(Rin/Rr)); 
p.FeedOffset = [lfeed-L/2 wfeed];

gpL = 0.0296;
gpW = 0.058; 
p.GroundPlaneLength = gpL;
p.GroundPlaneWidth = gpW;
p.Conductor.Name = 'Copper';
p.Conductor.Conductivity = 5.96*1e7;
p.Conductor.Thickness = 3.556e-05;

% p.FeedOffset = [L-lfeed 0];
% Show
figure;
show(p) 

%% MESH LEVEL TEST
%v = 0.0026:0.000025:0.0039;
v=linspace(0.0025,0.005,70);
smin = zeros(1,length(v));
%freqRange = 2e9:0.0025e9:2.2e9;
freqRange = linspace(1.5e9,2.4e9,80);
frequenza=zeros(1,length(v));

%%
tic
for i=1:length(v)
mesh(p,'MaxEdgeLength',v(i));
drawnow
s = sparameters(p,freqRange);
testo = strcat('\Gamma_{dB} for mesh ='," ", string(v(i)));
%figure();
%rfplot(s)
title(testo,'Interpreter','tex');
stringa_salvataggio=strcat('S11_mesh_',string(v(i)),'.mat');
save(stringa_salvataggio,'s')
slog=20*log10(abs(s.Parameters));
ssintax=slog(:,:);
frequenza(i)=s.Frequencies(ssintax==min(ssintax));
smin(i)=min(ssintax);
disp('Step: ');
disp(length(v)+1-i);
close all
end 
figure();
plot(v,smin);
toc
figure;
plot(v,frequenza);
title('Resonance F. vs mesh level')
figure;
plot(v,abs(frequenza-2.1e9));
%% 
% Define frequency range 
freqRange = 2e9:0.002e9:2.2e9;

% sparameter
figure();
mesh(p,'MaxEdgeLength',0.0035);
figure();

impedance(p, freqRange)
% xline(f,'b:');
% yline(50,'b:');
% yline(0, 'b:');
% testo = strcat('\Gamma_{dB} for L ='," ", L(i), " ",' and W ='," ", W(i));

%% IMPEDANCE MATCHING
% lfeed = 0.0060:0.0001:0.008;
wfeed = -0.005:0.0001:0.005;
figure();
mesh(p,'MaxEdgeLength',0.0035);
for i=1:length(wfeed)
p.FeedOffset = [lfeed-L/2 wfeed(i)];
% p.FeedOffset = [lfeed(i)-L/2 0];
freqRange = 2e9:0.002e9:2.2e9;
figure();
% sparameter
impedance(p, f);
title(string(wfeed(i)));
disp('Step: ');
disp(length(wfeed)-i);
end
disp('Done!');

%% GAIN PATTERNS  

PO = PatternPlotOptions;
PO.Transparency = 0.5;
% pattern(dipole, f, "patternOptions", PO);

%%% Specifica parametro desiderato
show(p);
G0 = pattern(p, f, 'Type', 'Gain');
figure();
%%
%%% Polarizzazioni: 'v', 'h', 'rcp', 'hcp'
pattern(p, f, 'Type', 'Gain', 'Polarization', 'v');
figure();
pattern(p, f, 'Type', 'Gain', 'Polarization', 'h');
figure();
pattern(p, f, 'Type', 'Gain', 'Polarization', 'rcp');
% figure();
% pattern(p, f, 'Type', 'Gain', 'Polarization', 'hcp');
% figure();
%% 

mesh(p, 'MaxEdgeLength',0.0035);
Spar = sparameters(p,f);
Gamma = abs(Spar.Parameters);
%% Antenna Analysis 
mesh(p, 'MaxEdgeLength',0.0035);
% Define plot frequency 
plotFrequency = 2.1*1e9;
% Define frequency range 
freqRange = 2e9:0.002e9:2.2e9;
% impedance
% figure;
% impedance(p, freqRange)
% % sparameter
% figure;
% s = sparameters(p, freqRange); 
% rfplot(s)
% pattern
figure;
pattern(p, plotFrequency)
% azimuth

%% 
figure;
plotFrequency = 2.1e9;
patternAzimuth(p, plotFrequency, 0, 'Azimuth', 0:5:360,'Type','Gain')
% elevation
figure;
pat_EL = patternElevation(p, plotFrequency,0,'Elevation',0:5:360)

%% 
% current
figure;
current(p, plotFrequency)

%% DIRECTIVITY 
pattern(p,f,'Type','directivity');
%% GAMMA PLOT 
% Define plot frequency 
plotFrequency = 2.1*1e9;
% Define frequency range 
freqRange = 2.0e9:0.0025e9:2.2e9;
mesh(p,'MaxEdgeLength',0.0032);
% sparameter
figure;
s = sparameters(p, freqRange); 
rfplot(s)

%% OPTIMAL MESH LEVEL  
plotFrequency = 2.1*1e9;
% Define frequency range 
v = 0.0025:0.0001:0.009;
smin = zeros(1,length(v));
freqRange = 2.0e9:0.0025e9:2.2e9;
%% 
tic
parfor i=1:length(v)
mesh(p,'MaxEdgeLength',v(i));
% sparameter
figure;
s = sparameters(p, freqRange); 
svar = 20*log10(abs(s.Parameters));
smin(1,i) = min(min(min(svar)));
disp('Step: ');
disp(length(v)-i);
end
figure();
plot(v,smin);
toc
% rfplot(s)

%% TIMER

%%
clear L W l 


W(1) = 0.0343;
L(1) = 0.0159;
% Γ = - 28.78 dB;

W(2) = 0.0346; 
L(2) = 0.0158;
% Γ = - 25.95 dB;

W(3)= 0.0347; 
L(3) = 0.0158; 
% Γ = - 25.86 dB;

W(4) = 0.0348; 
L(4) = 0.0158; 
% Γ = - 26.05 dB;

W(5)= 0.0346; 
L(5) = 0.0159; 
% Γ = - 24.43 dB;

W(6)= 0.0356; 
L(6) = 0.0159; 
% Γ = - 20.65 dB;

W(7)= 0.0355; 
L(7) = 0.0159; 
% Γ = - 24.43 dB;

W(8) = 0.0351; 
L(8) = 0.0158; 
% Γ = - 24.46 dB;

W(9) = 0.0357; 
L(9) = 0.0158; 
% Γ = - 23.57 dB;

W(10)= 0.0351; 
L(10) = 0.0158; 
% Γ = - 24.46 dB;

W(11) = 0.0360; 
L(11) = 0.0159; 
% Γ = - 25.92 dB;

W(12) = 0.0351; 
L(12) = 0.0158; 
% Γ = - 24.46 dB;

W(13) = 0.0363; 
L(13) = 0.0159; 
% Γ = - 23.41 dB;

W(14)= 0.0368; 
L(14) = 0.0159; 
% Γ = - 22.43 dB;

W(15)= 0.0374; 
L(15) = 0.0159; 
% Γ = - 21.04 dB;

W(16) = 0.0377; 
L(16) = 0.0159; 
% Γ = - 20.49 dB;

W(17)= 0.0380; 
L(17) = 0.0159; 
% Γ = - 20.19 dB;

W(18)= 0.0382; 
L(18) = 0.0158; 
% Γ = - 20.08 dB;

W(19)= 0.0475; 
L(19) = 0.0160; 
% Γ = - 21.37 dB;

W(20) = 0.0480; 
L(20) = 0.0160; 
% Γ = - 20.93 dB;

Rr = zeros(10,1);
l = zeros(10,1);
gpL = 0.0296;
gpW = 0.058; 



%% 

for i=2:3
Rr(i,1) = (120*lambda0/W(i))*(1-(1/24)*(k0*h)^2)^(-1);
Rin = 50;
l(i,1) = (L(i)/pi)*acos(sqrt(Rin/Rr(i,1))); %% now it's from the shortC

p.Length = L(i);
p.Width = W(i);
p.PatchCenterOffset = [0 0];
p.FeedOffset = [l(i,1)-L(i)/2 0];
p.ShortPinWidth = W(i);
p.GroundPlaneLength = gpL;
p.GroundPlaneWidth = gpW;
figure();
mesh(p, 'MaxEdgeLength',0.0035);
figure();
show(p);
% Define frequency range 
freqRange = 2e9:0.001e9:2.2e9;

% sparameter
s(i) = sparameters(p, freqRange); 
% testo = strcat('\Gamma_{dB} for L ='," ", L(i), " ",' and W ='," ", W(i));
figure();
rfplot(s(i))
end

disp('Done!'); 

%% 
testo = strcat('\Gamma_{dB} for L ='," ", string(L(i)), " ",' and W ='," ",string(W(i)));
figure();
rfplot(s)
title(testo,'Interpreter','tex');
stringa_salvataggio=strcat('S11_L_',string(L(i)),'_W_',string(W(i)));
save(stringa_salvataggio,'s')
%% clear figHandles 
% SAVINGS 
clear input_file
input_file={};

figHandles = findobj(0,'Type','figure');
for i = 1:(numel(figHandles))
%name=strcat('figure',num2str(i),'.pdf');
%saveas(figure(i),name,'pdf');
 name=strcat('figure',num2str(i),'.fig');
 saveas(figure(i),name,'fig');
saveas(figure(i),strcat('figure',num2str(i),get(figure(i), 'Name' )),'png');
input_file{i}=name;
end
%% CONTOURS 

figure();
contourf(W,L,Gamma);
colorbar;
figure();
contourf(W,L,20*log10(Gamma));
colorbar;




%%
clear L W l 
L = 0.0156:0.0001:0.0163;
W = 0.034:0.0001:0.049;

%% 
Rr = zeros(length(W),1);
l = zeros(length(L),length(W));
Gamma = zeros(length(L),length(W));
gpL = 0.029:0.0001:0.0297;
gpW = 0.044:0.0001:0.059; 

%% 
tic
disp('Total steps: ');
disp(length(L)*length(W));
for i=1:length(L)
    for j=1:length(W)
Rr(j,1) = (120*lambda0/W(j))*(1-(1/24)*(k0*h)^2)^(-1);
Rin = 50;
l(i,j) = (L(i)/pi)*acos(sqrt(Rin/Rr(j))); %% now it's from the shortC
    end
end

for i=1:length(L)
    for j=1:length(W)
    p.Length = L(i);
p.Width = W(j);
p.PatchCenterOffset = [0 0];
p.FeedOffset = [l(i,j)-L(i)/2 0];
p.ShortPinWidth = W(j);
p.GroundPlaneLength = gpL(i);
p.GroundPlaneWidth = gpW(j);
mesh(p, 'MaxEdgeLength',0.0035);
Spar = sparameters(p,f);
Gamma(i,j) = abs(Spar.Parameters);
disp('Step L: ');
disp(i);
disp('Step W: ');
disp(j);
    end
end
toc
