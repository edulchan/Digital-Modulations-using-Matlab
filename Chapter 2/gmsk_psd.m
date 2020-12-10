% PSD of GMSK signals with various BT products
clearvars; clc;
N=10000;%Number of symbols to transmit
Fc=800;%carrier frequency in Hertz
L =16; %oversampling factor,use L= Fs/Fc, where Fs >> 2xFc
Fs = L*Fc;
 
a = rand(N,1)>0.5; %random symbols input to modulator
s1= gmsk_mod(a,Fc,L,0.3); %BT_b=0.3
s2 = gmsk_mod(a,Fc,L,0.5); %BT_b=0.5
s3 = gmsk_mod(a,Fc,L,0.7); %BT_b=0.7
s4 = gmsk_mod(a,Fc,L,10000); %BT_b=10000 (very large value-MSK)
 
%see section - 'Power Spectral Density plots' for definition
figure; plotWelchPSD(s1,Fs,Fc,'r'); hold on;
plotWelchPSD(s2,Fs,Fc,'b');
plotWelchPSD(s3,Fs,Fc,'m');
plotWelchPSD(s4,Fs,Fc,'k');
xlabel('f-f_c'); ylabel('PSD (dB)');
legend('BT_b=0.3','BT_b=0.5','BT_b=1','BT_b=\infty');