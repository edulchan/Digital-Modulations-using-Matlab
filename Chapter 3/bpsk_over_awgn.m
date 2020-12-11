% Demonstration of Eb/N0 Vs SER for baseband BPSK modulation scheme
clear all;clc;
%---------Input Fields------------------------
N=1000000;%Number of symbols to transmit
EbN0dB = -4:2:20; % Eb/N0 range in dB for simulation

%-----------------Transmitter---------------------
a= randi([0,1],1,N); %uniformly distributed random 1's and 0's
s = 2*a-1; %BPSK Mapping

SER = zeros(length(EbN0dB),1); %Place holder for SER values for each Eb/N0
EbN0lin = 10.^(EbN0dB/10); %Converting Eb/N0 from dB to linear scale
for i=1:1:length(EbN0dB),
    %Compute and add channel noise for given Eb/N0
    Esym=sum(abs(s).^2)/(length(s)); %actual symbol energy from generated samples
    N0=Esym/EbN0lin(i); %find the noise spectral density
    noiseSigma = sqrt(N0/2); %standard deviation for AWGN Noise
    n = noiseSigma*(randn(1,N)+1i*randn(1,N));
    y=s+n;%received signal = signal+awgn noise
    %---------------Receiver--------------------
    acap=(y>=0);%threshold detection
    SER(i)=sum((a~=acap))/N;%------ Symbol Error Rate Computation-------
end
%------Theoretical Symbol Error Rate-------------
theoreticalSER = 0.5*erfc(sqrt(EbN0lin));
%-------------Plotting---------------------------
semilogy(EbN0dB,SER,'k*'); hold on;
semilogy(EbN0dB,theoreticalSER,'r-');
set(gca,'XLim',[-4 12]);set(gca,'YLim',[1E-6 1E0]);set(gca,'XTick',-4:2:12);
title('Probability of Symbol Error for BPSK signals');
xlabel('E_b/N_0 (dB)');ylabel('Probability of Symbol Error - P_s');
legend('Simulated', 'Theoretical');grid on;