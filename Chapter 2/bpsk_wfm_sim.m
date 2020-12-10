% Demonstration of BPSK tx/rx chain (waveform simulation)
clearvars ; clc;
N=100000;%Number of symbols to transmit
EbN0dB = -4:2:10; % Eb/N0 range in dB for simulation
L=16;%oversampling factor,L=Tb/Ts(Tb=bit period,Ts=sampling period)
%if a carrier is used, use L = Fs/Fc, where Fs >> 2xFc
Fc=800; %carrier frequency
Fs=L*Fc;%sampling frequency

EbN0lin = 10.^(EbN0dB/10); %converting dB values to linear scale
BER = zeros(length(EbN0dB),1); %for SER values for each Eb/N0

%-----------------Transmitter---------------------
ak = rand(N,1)>0.5; %random symbols from 0's and 1's
[s_bb,t]= bpsk_mod(ak,L); %BPSK modulation(waveform) - baseband
s = s_bb.*cos(2*pi*Fc*t/Fs); %with carrier

%Waveforms at the transmitter
subplot(2,2,1);plot(t,s_bb);%baseband wfm zoomed to first 10 bits
xlabel('t(s)'); ylabel('s_{bb}(t)-baseband');xlim([0,10*L]);
subplot(2,2,2);plot(t,s); %transmitted wfm zoomed to first 10 bits
xlabel('t(s)'); ylabel('s(t)-with carrier');xlim([0,10*L]);
%signal constellation at transmitter
subplot(2,2,3);plot(real(s_bb),imag(s_bb),'o');
xlim([-1.5 1.5]); ylim([-1.5 1.5]);

for i=1:length(EbN0dB)
    Eb=L*sum(abs(s).^2)/length(s); %signal energy
    N0= Eb/EbN0lin(i); %Find the noise spectral density
    n = sqrt(N0/2)*randn(1,length(s));%computed noise
    
    r = s + n;%received signal with noise
    
    r_bb = r.*cos(2*pi*Fc*t/Fs);%recovered baseband signal
    ak_cap = bpsk_demod(r_bb,L);%baseband correlation demodulator
    BER(i) = sum(ak~=ak_cap)/N;%Symbol Error Rate Computation
    
    %Received signal waveform zoomed to first 10 bits
    subplot(2,2,4);plot(t,r);%received signal (with noise)
    xlabel('t(s)'); ylabel('r(t)');xlim([0,10*L]);
    pause;%wait for keypress
end
theoreticalBER = 0.5*erfc(sqrt(EbN0lin));%Theoretical bit error rate
%-------------Plots---------------------------
figure;semilogy(EbN0dB,BER,'k*'); %simulated BER
hold on;semilogy(EbN0dB,theoreticalBER,'r-');
xlabel('E_b/N_0 (dB)'); ylabel('Probability of Bit Error - P_b');
legend('Simulated', 'Theoretical');grid on;
title(['Probability of Bit Error for BPSK modulation']);