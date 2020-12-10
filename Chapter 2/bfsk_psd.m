% PSD of BPSK signal
clear all; clc;
N=10000; %number of symbols to transmit
Fc = 400; %center carrier frequency f_c should integral multiple of 1/Tb
fsk_type = 'COHERENT'; %COHERENT or NONCOHERENT FSK generation at the transmitter
h = 1; %modulation index
L = 40; %oversampling factor

Fs = 8*Fc; %sampling frequency for discrete-time simulation
Tb = L/Fs;% bit period, f_c is integral multiple of 1/Tb
Fd = h/Tb;%Frequency separation

a = rand(1,N)>0.5; %random bits - input to BFSK modulator
[s,t]=bfsk_mod(a,Fc,Fd,L,Fs,fsk_type);
plotWelchPSD(s,Fs,Fc,'r','twosided')
xlim([0 Fs/2]) %zoom to 0 to Fs/2 portion
xlabel('Frequency (Hz'); ylabel('PSD (dB)'); title('BFSK Power Spectral Density');