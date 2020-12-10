% Coherent detection D-BPSK with phase ambiguity in local oscillator
clear;clc;
N=1000000;%Number of symbols to transmit
EbN0dB = -4:2:10; % Eb/N0 range in dB for simulation
L=16;%oversampling factor,L=Tb/Ts(Tb=bit period,Ts=sampling period)
%if a carrier is used, use L = Fs/Fc, where Fs >> 2xFc
Fc=800; %carrier frequency
Fs=L*Fc;%sampling frequency

EbN0lin = 10.^(EbN0dB/10); %converting dB values to linear scale
EsN0dB=10*log10(1)+EbN0dB; EsN0lin = 10.^(EsN0dB/10);
SER = zeros(length(EbN0dB),1);%for SER values for each Eb/N0

%-----------------Transmitter---------------------
ak = rand(N,1)>0.5; %random symbols from 0's and 1's
bk = filter(1,[1 -1],ak,0); %IIR filter for differential encoding
bk = mod(bk,2); %XOR operation is equivalent to modulo-2
[s_bb,t]= bpsk_mod(bk,L); %BPSK modulation(waveform) - baseband
s = s_bb.*cos(2*pi*Fc*t/Fs); %DPSK with carrier

for i=1:length(EbN0dB),
    Esym=sum(abs(s).^2)/length(s); %signal energy
    N0= Esym/EsN0lin(i); %Find the noise spectral density
    n=sqrt(L*N0/2)*(randn(1,length(s))+1i*randn(1,length(s)));
    r = s + n;%received signal with noise
    
    phaseAmbiguity=pi;%180* phase ambiguity of Costas loop
    r_bb=r.*cos(2*pi*Fc*t/Fs+phaseAmbiguity);%recoveredsignal
    b_cap=bpsk_demod(r_bb,L);%baseband correlation type demodulator
    a_cap=filter([1 1],1,b_cap); %FIR for differential decoding
    a_cap= mod(a_cap,2); %binary messages, therefore modulo-2
    SER(i) = sum(ak~=a_cap)/N;%Symbol Error Rate Computation
    
end
%------Theoretical Bit/Symbol Error Rates-------------
theorySER_DPSK = erfc(sqrt(EbN0lin)).*(1-0.5*erfc(sqrt(EbN0lin)));
theorySER_BPSK = 0.5*erfc(sqrt(EbN0lin));
%-------------Plots---------------------------
figure;semilogy(EbN0dB,SER,'k*'); hold on;
semilogy(EbN0dB,theorySER_DPSK,'r-');
semilogy(EbN0dB,theorySER_BPSK,'b-');
title('Probability of Bit Error for BPSK over AWGN');
xlabel('E_b/N_0 (dB)');ylabel('Probability of Bit Error - P_b');
legend('Coherent D-BPSK(sim)','Coherent D-BPSK(theory)','Conventional BPSK')