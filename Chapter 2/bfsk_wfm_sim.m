%Eb/N0 Vs BER for BFSK mod/coherent-demod (waveform simulation)
clearvars; clc;
N=100000;%Number of bits to transmit
EbN0dB = -4:2:10; % Eb/N0 range in dB for simulation
Fc = 400; %center carrier frequency f_c- integral multiple of 1/Tb
fsk_type = 'COHERENT'; %COHERENT/NONCOHERENT FSK generation at Tx
h = 1; %modulation index
% h should be minimum 0.5 for coherent FSK or multiples of 0.5
%h should be minimum 1 for non-coherent FSK or multiples of 1
L = 40; %oversampling factor

Fs = 8*Fc; %sampling frequency for discrete-time simulation
Tb = L/Fs;% bit period, f_c is integral multiple of 1/Tb
Fd = h/Tb;%Frequency separation

EbN0lin = 10.^(EbN0dB/10); %converting dB values to linear scale
BER_coherent = zeros(length(EbN0dB),1); %BER values for each Eb/N0
BER_nonCoherent = BER_coherent;

%-----------------Transmitter---------------------
a = rand(1,N)>0.5; %random bits - input to BFSK modulator
[s,t,phase]=bfsk_mod(a,Fc,Fd,L,Fs,fsk_type); %BFSK modulation

for i=1:length(EbN0dB)
    Eb=L*sum(abs(s).^2)/(length(s)); %compute energy per bit
    N0= Eb/EbN0lin(i); %required noise spectral density from Eb/N0
    n = sqrt(N0/2)*(randn(1,length(s)));%computed noise
    r = s + n;%add noise
    %---------------Receiver--------------------
    if strcmpi(fsk_type,'COHERENT')
        %coherent FSK could be demodulated coherently or non-coherently
        a_cap1 =  bfsk_coherent_demod(r,Fc,Fd,L,Fs,phase);%coherent detection
        a_cap2 =  bfsk_noncoherent_demod(r,Fc,Fd,L,Fs);%noncoherent detection
        BER_coherent(i) = sum(a~=a_cap1)/N;%BER for coherent case
        BER_nonCoherent(i) = sum(a~=a_cap2)/N;%BER for non-coherent case
    end
    if strcmpi(fsk_type,'NONCOHERENT')
        %non-coherent FSK can only non-coherently demodulated
        a_cap2 =  bfsk_noncoherent_demod(r,Fc,Fd,L,Fs);%noncoherent detection
        BER_nonCoherent(i) = sum(a~=a_cap2)/N;%BER for non-coherent case
    end
end
%------Theoretical Bit Error Rate-------------
coherent = 0.5*erfc(sqrt(EbN0lin/2));%Theoretical BER - coherent case
nonCoherent = 0.5*exp(-EbN0lin/2);%Theoretical BER - non-coherent case
%-------------Plot performance curve------------------------
figure;
if strcmpi(fsk_type,'COHERENT')
    semilogy(EbN0dB,BER_coherent,'k*'); hold on; %sim BER
    semilogy(EbN0dB,BER_nonCoherent,'m*'); %sim BER
    semilogy(EbN0dB,coherent,'r-');
    semilogy(EbN0dB,nonCoherent,'b-');
    title('Probability of Bit Error for coherent BFSK modulation');
    legend('Sim-coherent demod','Sim-noncoherent demod','theory-coherent demod','theory-noncoherent demod');
end
if strcmpi(fsk_type,'NONCOHERENT')
    semilogy(EbN0dB,BER_nonCoherent,'m*'); hold on;%sim BER
    semilogy(EbN0dB,nonCoherent,'b-');
    title('Probability of Bit Error for non-coherent BFSK modulation');
    legend('Sim-noncoherent demod','theory-noncoherent demod');
end
xlabel('E_b/N_0 (dB)');ylabel('Probability of Bit Error - P_b');