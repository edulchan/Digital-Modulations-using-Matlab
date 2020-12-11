%Eb/N0 Vs BER for BPSK over Rician Fading Channel with AWGN noise
clc; clear all;
%--------Inputs-------------------------------------------------
N=10^6; %Number of data samples to send across the Rician Channel
EbN0dB=0:2:20; %Eb/N0 in dB overwhich the performance has to be simulated
K_factors=[0 2 5 10 20 30 10000]; %a list of Ricial K factors to simulate
%--------------------------------------------------------------

a=rand(1,N)>0.5; %data generation
s=2*a-1; %BPSK modulation

simBER_ricean=zeros(1,length(EbN0dB));%Place holder for BER values for each Eb/N0

plotStyle={'b*-','ro-','kx-','gs-','md-','cp-','yv-'};
for index =1:length(K_factors)
    
    kappa=K_factors(index);
    S=sqrt(1/(kappa+1));%power of scattered components
    A=sqrt(kappa/(kappa+1));%power of LOS components
    
    for i=1:length(EbN0dB)
        g_t=(randn(1,N)+1i*randn(1,N)); %Rayleigh Fading
        h=(A+S*g_t); %Rician Fading from Rayleigh Fading
        
        %Adding noise with variance according to the required Es/N0
        Esym=sum(abs(s).^2)/(length(s)); %actual symbol energy from generated samples
        N0=Esym/10^(EbN0dB(i)/10); %Find the noise spectral density
        noiseSigma = sqrt(N0/2); %Standard deviation for AWGN Noise
        n = noiseSigma*(randn(1,N)+1i*randn(1,N)); %Add noise in IQ plane.
        
        y_ricean=h.*s+n; %received signal through Rician channel
        
        %---------------Receiver--------------------
        y_ricean_cap=y_ricean./h; %Equalizer, assuming h is accurately at receiver
        r_ricean=real(y_ricean_cap)>0; %threshold detector for BPSK
        simBER_ricean(i)=sum(xor(a,r_ricean));%calculate total bit Errors
    end
    simBER_ricean=simBER_ricean/N;%Bit Error rates;
    semilogy(EbN0dB,simBER_ricean,plotStyle{index},'LineWidth',1.0);hold on
    legendInfo{index} = ['K = ' num2str(K_factors(index))];
end
axis([0 20 10^-5 10^0]);legend(legendInfo);
title('Performance of BPSK over Rician Channels with AWGN noise');
xlabel('Eb/N0(dB)');ylabel('Pb -Bit Error Rate');
