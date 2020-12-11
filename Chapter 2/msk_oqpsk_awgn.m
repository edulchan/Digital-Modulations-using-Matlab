% Demonstration of Eb/N0 Vs SER for MSK(waveform simulation)
clear;clc;
%---------Input Fields------------------------
N=100000;%Number of symbols to transmit
EbN0dB = -10:2:10; % Eb/N0 range in dB for simulation

%------Parameters to generate MSK waveform---
Tsym=1; %Symbol duration in seconds
L=8;%oversampling factor, the sampling period will be Ts = Tsym/L

EbN0lin = 10.^(EbN0dB/10); %converting dB values to linear scale
SER = zeros(length(EbN0dB),1); %Place holder for SER values for each Eb/N0
%-----------------Transmitter---------------------
a = rand(N,1)>0.5; %random symbols from 0's and 1's - input to MSK
s= msk_mod(a,L);

for i=1:length(EbN0dB)
    Esym=sum(abs(s).^2)/(length(s)); %Calculate actual symbol energy
    N0= Esym/EbN0lin(i); %Find the noise spectral density
    n = sqrt(L*N0/2)*(randn(1,length(s))+1i*randn(1,length(s)));%computed noise
    %Due to oversampling the signal of noise is sqrt(LN0/2).
    r = s + n;
    %---------------Receiver--------------------
    a_cap = msk_demod(r,N,L);
    SER(i) = sum(a~=a_cap)/N;%Symbol Error Rate Computation
end
%------Theoretical Symbol Error Rate-------------
theoreticalSER = 0.5*erfc(sqrt(EbN0lin));%Theoretical symbol error rate
%-------------Plotting---------------------------
semilogy(EbN0dB,SER,'k*','LineWidth',1.5); hold on;%simulated SER
semilogy(EbN0dB,theoreticalSER,'r-','LineWidth',1.5);
set(gca,'XLim',[-4 12]);set(gca,'YLim',[1E-6 1E0]);set(gca,'XTick',-4:2:12);
title(['Probability of Bit Error for MSK']);
xlabel('E_b/N_0 (dB)');ylabel('Probability of Bit Error - P_b');
legend('Simulated', 'Theoretical');grid on;