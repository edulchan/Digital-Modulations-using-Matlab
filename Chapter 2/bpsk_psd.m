% PSD of BPSK signal
clear;clc;
N=100000;%Number of symbols, should be suffiently high
L=8;%oversampling factor,use L = Fs/Fc, where Fs >> 2xFc
Fc=800; %carrier frequency
Fs=L*Fc;%sampling frequency

d = rand(N,1)>0.5; %random symbols from 0's and 1's - input to MSK
[s_bb,t]= bpsk_mod(d,L); %BPSK modulation(waveform) - baseband
s = s_bb.*cos(2*pi*Fc*t/Fs);%BPSK with carrier

ns = max(size(s));
na = 16;%averaging factor (to calculate 16-times avraged spectrum)
w = hanning(floor(ns/na));%Hanning window
[Pss,f]=pwelch(s,w,0,[],Fs,'twosided'); %Welch PSD estimate with Hanning window and no overlap
indices = find(f>=Fc & f<4*Fc); %To plot PSD from Fc to 4*Fc
Pss=Pss(indices)/Pss(indices(1)); %normalized psd with respect to the value at Fc
plot(f(indices),10*log10(Pss),'b');
xlabel('Frequency (Hz)'); ylabel('PSD in dB');