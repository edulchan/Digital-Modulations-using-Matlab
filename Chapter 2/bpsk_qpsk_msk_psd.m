%Compare PSDs of bandpass MSK QPSK BPSK signals
clear;clc;
N=100000;%Number of symbols to transmit
Fc=800;OF =8;%carrier frequency and oversamping factor
Fs = Fc*OF;%sampling frequency

a = rand(N,1)>0.5; %random symbols to modulate

[s_bb,t]= bpsk_mod(a,OF); %BPSK modulation(waveform) - baseband
s_bpsk = s_bb.*cos(2*pi*Fc*t/Fs);%BPSK with carrier

s_qpsk = qpsk_mod(a,Fc,OF); %conventional QPSK
s_msk = msk_mod(a,Fc,OF);%MSK signal

%Compute and plot PSDs for each of the modulated versions
plotWelchPSD(s_bpsk,Fs,Fc,'b'); hold on;
plotWelchPSD(s_qpsk,Fs,Fc,'r');
plotWelchPSD(s_msk,Fs,Fc,'k');
legend('BPSK','QPSK','MSK');xlabel('f-f_c'),ylabel('PSD');