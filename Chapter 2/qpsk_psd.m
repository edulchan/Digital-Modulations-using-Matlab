% PSD of QPSK signal
clear all;clc;
N=100000;%Number of symbols to transmit
Fc=800;%carrier frequency in Hertz
L =8; %oversampling factor,use L= Fs/Fc, where Fs >> 2xFc
Fs = Fc*L;

a = rand(N,1)>0.5; %random symbols from 0's and 1's - input to MSK
[s,t] = qpsk_mod(a,Fc,L);

ns = max(size(s));
na = 16;%averaging factor (to calculate 16-times avraged spectrum with pwelch)
w = hanning(floor(ns/na));%Hanning window
[Pss,f]=pwelch(s,w,0,[],Fs,'twosided'); %Welch PSD estimate with Hanning window and no overlap
indices = find(f>=Fc & f<4*Fc); %To plot PSD from Fc to 4*Fc
Pss=Pss(indices)/Pss(indices(1)); %normalized psd with respect to the value at Fc
plot(f(indices),10*log10(Pss),'r');
xlabel('Frequency (Hz)'); ylabel('PSD in dB');
