% Demonstration of Eb/N0 Vs SER for baseband MSK/OQPSK schemes
clear;clc;
N=100000;%Number of symbols to transmit
EbN0dB = -4:2:10; % Eb/N0 range in dB for simulation
fc=100;%carrier frequency in Hertz
OF =16; %oversampling factor, sampling frequency will be fs=OF*fc

EbN0lin = 10.^(EbN0dB/10); %converting dB values to linear scale
BER = zeros(length(EbN0dB),1); %SER values for each Eb/N0

a = rand(N,1)>0.5; %random symbols from 0's and 1's - input to QPSK
[s,t] = oqpsk_mod(a,fc,OF);%OQPSK modulation

for i=1:length(EbN0dB)
    Eb=OF*sum(abs(s).^2)/(length(s)); %compute energy per bit
    N0= Eb/EbN0lin(i); %required noise spectral density from Eb/N0
    n = sqrt(N0/2)*(randn(1,length(s)));%computed noise
    r = s + n;
    a_cap = oqpsk_demod(r,N,fc,OF);%OQPSK demodulation
    BER(i) = sum(a~=a_cap)/N;%Symbol Error Rate Computation
end
%------Theoretical Bit Error Rate-------------
theoreticalBER = 0.5*erfc(sqrt(EbN0lin));%Theoretical BER
%-------------Plot performance curve------------------------
figure;semilogy(EbN0dB,BER,'k*','LineWidth',1.5); %simulated BER
hold on; semilogy(EbN0dB,theoreticalBER,'r-','LineWidth',1.5);
title('Probability of Bit Error for QPSK modulation');
xlabel('E_b/N_0 (dB)');ylabel('Probability of Bit Error - P_b');
legend('Simulated', 'Theoretical');grid on;