%Performance simulation of pi/4-DQPSK modulation (waveform simulation)
clear;clc;
N=100000;%Number of symbols to transmit
EbN0dB = 0:2:14; % Eb/N0 range in dB for simulation
fc=800;%carrier frequency in Hertz
OF =16; %oversampling factor, sampling frequency will be fs=OF*fc

EbN0lin = 10.^(EbN0dB/10); %converting dB values to linear scale
BER = zeros(length(EbN0dB),1); %SER values for each Eb/N0

a = rand(N,1)>0.5; %random source symbols from 0's and 1's
[s,t] = piBy4_dqpsk_mod(a,fc,OF);%dqpsk modulation

for i=1:length(EbN0dB)
    Eb=OF*sum(abs(s).^2)/(length(s)); %OF is the over sampling factor
    N0= Eb/EbN0lin(i); %required noise spectral density from Eb/N0
    n = sqrt(N0/2)*(randn(1,length(s)));%computed noise
    r = s + n; %noisy received signal
    [a_cap] = piBy4_dqpsk_demod(r,fc,OF);%Differential coherent demod
    BER(i) = sum(a~=a_cap.')/N;%Symbol Error Rate Computation
end

x = sqrt(4*EbN0lin)*sin(pi/(4*sqrt(2)));
theoreticalBER = 0.5*erfc(x/sqrt(2));%Theoretical Bit Error Rate
figure;semilogy(EbN0dB,BER,'k*','LineWidth',1.5); %simulated BER
hold on; semilogy(EbN0dB,theoreticalBER,'r-','LineWidth',1.5);
title('Probability of Bit Error for \pi/4-DQPSK');
xlabel('E_b/N_0 (dB)');ylabel('Probability of Bit Error - P_b');
legend('Simulated', 'Theoretical');grid on;
