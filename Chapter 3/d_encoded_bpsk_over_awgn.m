% Demonstration of Eb/N0 Vs SER for baseband differentially encoded BPSK
clear all;clc;
%---------Input Fields------------------------
N=1000000;%Number of symbols to transmit
EbN0dB = -4:2:20; % Eb/N0 range in dB for simulation

%-----------------Transmitter---------------------
m = rand(1,N)>0.5; %random symbols from 0's and 1's
b = filter(1,[1 -1],m,0); %IIR filter implementing the differential encoding
b = mod(b,2); %XOR operation is equivalent to modulo-2 and binary negation
s = 2*b-1; %BPSK antipodal Mapping

SER = zeros(length(EbN0dB),1); %Place holder for SER values for each Eb/N0
EbN0lin = 10.^(EbN0dB/10); %Converting Eb/N0 from dB to linear scale
for i=1:1:length(EbN0dB),
    %Compute and add channel noise for given Eb/N0
    Esym=sum(abs(s).^2)/length(s); %calculate actual symbol energy from generated samples
    N0=Esym/EbN0lin(i); %find the noise spectral density
    noiseSigma = sqrt(N0/2); %standard deviation for AWGN Noise
    n = noiseSigma*(randn(1,N)+1i*randn(1,N));
    y=s+n;%received signal = signal+awgn noise
    %---------------Receiver--------------------
    bCap=(y>=0);%threshold detection (BPSK demod)
    mCap = filter([1 1],1,bCap,0); %FIR filter implementing the differential decoding
    mCap= mod(mCap,2); %binary messages, therefore modulo-2
    SER(i)=sum((m~=mCap))/N;%------ Symbol Error Rate Computation-------
end
%------Theoretical Symbol Error Rate-------------
theoreticalSER_DPSK = erfc(sqrt(EbN0lin)).*(1-0.5*erfc(sqrt(EbN0lin)));%Theoretical symbol error rate for DPSK
theoreticalSER_BPSK = 0.5*erfc(sqrt(EbN0lin));%Theoretical symbol error rate for BPSK
%-------------Plotting---------------------------
semilogy(EbN0dB,SER,'k*'); hold on;
semilogy(EbN0dB,theoreticalSER_DPSK,'r-','LineWidth',1.0);
semilogy(EbN0dB,theoreticalSER_BPSK,'b-','LineWidth',1.0);
set(gca,'XLim',[-4 12]);set(gca,'YLim',[1E-6 1E0]);set(gca,'XTick',-4:2:12);
title('Probability of Symbol Error for BPSK signals');
xlabel('E_b/N_0 (dB)');ylabel('Probability of Symbol Error - P_s');
legend('Simulated', 'Theoretical');grid on;
