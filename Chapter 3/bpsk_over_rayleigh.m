% Demonstration of Eb/N0 Vs BER for baseband BPSK modulation scheme over Rayleigh Fading
clear all; clc;
%---------Input Fields------------------------
N=1000000;%Number of symbols to transmit
EbN0dB = -4:2:20; % Eb/N0 range in dB for simulation
M=2; %2-PSK

%-----Initialization of various parameters----
EbN0lin = 10.^(EbN0dB/10); %Converting to linear scale
BER_rayleigh = zeros(length(EbN0lin),1); %Place holder for BER values for each Eb/N0
BER_awgn = BER_rayleigh; %Place holder for BER values for each Eb/N0

%-----------------Transmitter---------------------
a= randi([0,1],1,N); %uniformly distributed random 1's and 0's
s = 2*a-1; %BPSK Mapping

for i=1:1:length(EbN0lin),
    %----------------Channel---------------------
    %Adding noise with variance according to the required Es/N0
    Esym=sum(abs(s).^2)/(length(s)); %actual symbol energy from generated samples
    N0=Esym/EbN0lin(i); %Find the noise spectral density
    noiseSigma = sqrt(N0/2); %Standard deviation for AWGN Noise
    n = noiseSigma*(randn(1,N)+1i*randn(1,N));%computed noise

    h=1/sqrt(2)*(randn(1,N)+1i*randn(1,N)); %Rayleigh Flat Fading - single tap

    y_rayleigh=h.*s+n;%received signal through Rayleigh flat Fading and AWGN Noise
    y_awgn=s+n;%received signal through AWGN Channel

    %---------------Receiver--------------------
    yRayleighEqualized=y_rayleigh./h;%Equalizer for Rayleigh Channel
    aCapRayleigh=(yRayleighEqualized>=0);%detection for signal via Rayleigh channel
    aCapAWGN=(y_awgn>=0);%detection for signal via AWGN channel

    %------ Bit Error Rate Computation-------
    BER_rayleigh(i)=sum((a~=aCapRayleigh))/N;
    BER_awgn(i)=sum((a~=aCapAWGN))/N;
end
%------Theoretical Bit Error Rate-------------
theoretical_rayleigh=0.5*(1-sqrt(EbN0lin./(1+EbN0lin)));
theoretical_awgn = 0.5*erfc(sqrt(EbN0lin));
%-------------Plotting---------------------------
figure();set(gcf,'Color',[1 1 1]);
semilogy(EbN0dB,theoretical_rayleigh,'r-');hold on;semilogy(EbN0dB,BER_rayleigh,'k*'); 
semilogy(EbN0dB,theoretical_awgn,'g-');semilogy(EbN0dB,BER_awgn,'b*'); grid on;
set(gca,'XLim',[-4 12]);set(gca,'YLim',[1E-6 1E0]);set(gca,'XTick',-4:2:12);
title('Probability of Bit Error for BPSK signals over Rayleigh and AWGN Channels','fontsize',12);
xlabel('E_b/N_0 (dB)');ylabel('Probability of Bit Error - P_b');
h_legend=legend( 'Rayleigh fading-theoretical','Rayleigh fading-simulated','AWGN channel-theoretical','AWGN channel-simulated');
