% Demonstration of Eb/N0 Vs SER for baseband GMSK modulation scheme
clearvars ;clc;
N=100000;%Number of symbols to transmit
EbN0dB = 0:2:18; % Eb/N0 range in dB for simulation
Fc = 800; % Carrier frequency in Hz (must be < fs/2 and > fg)
BT= 0.3; %Gaussian LPF's BT product
L = 16; %oversampling factor

EbN0lin = 10.^(EbN0dB/10); %converting dB values to linear scale
BER = zeros(length(EbN0dB),1); %SER values for each Eb/N0

%-----------------Transmitter---------------------
a = rand(N,1)>0.5; %random symbols for modulation
[s,t,s_complex] = gmsk_mod(a,Fc,L,BT);%GMSK modulation

for i=1:length(EbN0dB)
    Eb= sum(abs(s_complex).^2)/(length(s_complex)); %compute Energy
    N0= Eb/EbN0lin(i); %required noise spectral density from Eb/N0
    n = sqrt(N0/2)*(randn(size(s_complex))+1i*randn(size(s_complex)));
    r = s_complex + n ; %noise added baseband GMSK signal
    %---------------Receiver--------------------
    a_cap = gmsk_demod(r,L);%Baseband GMSK demodulation
    BER(i) = sum(a~=a_cap)/N;%Bit Error Rate Computation
end
figure;%Plot performance curves
semilogy(EbN0dB,BER,'g*-','LineWidth',1.5); hold on;%simulated BER
title('Probability of Bit Error for GMSK modulation');
xlabel('E_b/N_0 (dB)');ylabel('Probability of Bit Error - P_b');