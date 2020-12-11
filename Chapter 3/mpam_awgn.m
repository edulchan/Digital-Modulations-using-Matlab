% Demonstration of Eb/N0 Vs SER for baseband M-PAM modulation scheme
clear all;clc;
%---------Input Fields------------------------
N=1000000;%Number of symbols to transmit
EbN0dB = -4:2:24; % Eb/N0 range in dB for simulation
arrayofM=[2 4 8 16]; %M-level PAM
%----------------------------------------------
plotColor =['b','g','r','c']; p=1; %For plot color index
legendStr={'Simulated-2PAM','Theoretical-2PAM','Simulated-4PAM','Theoretical-4PAM','Simulated-8PAM','Theoretical-8PAM','Simulated-16PAM','Theoretical-16PAM'};

for M = arrayofM    
    k=log2(M); %Bits per symbol
    m=1:1:M; Am=2*m-1-M; %All possibe amplitude levels
    a=ceil(M.*rand(1,N)); %random data symbols
    s = Am(a); %M-PAM transmission
    
    EbN0lin = 10.^(EbN0dB/10); %Converting to linear scale
    EsN0lin=k*EbN0lin; %Converting Eb/N0 to Es/N0
    SER = zeros(length(EsN0lin),1); %Place holder for SER values for each Eb/N0
    j=1;

    for i=EsN0lin,
        %Adding noise with variance according to the required Es/N0
        Es=sum(abs(s).^2)/(length(s)); %Calculate actual symbol energy
        N0=Es/i; %Find the noise spectral density
        noiseSigma = sqrt(N0/2); %Standard deviation for AWGN Noise
        n = noiseSigma*(randn(1,N));
        
        y=s+n;%Channel - Adding AWGN Noise
        
        [estimatedTxSymbols,aCap]= iqOptDetector(y,Am);%detection at receiver
        SER(j)=sum((a~=aCap))/N;%Symbol Error Rate computation
        j=j+1;
    end
    %Theoretical Symbol Error Rate
    theoreticalSER=2*(1-1/M)*0.5*erfc(sqrt(3*log2(M)/(M^2-1)*EbN0lin));
    semilogy(EbN0dB,SER,[plotColor(p) '*']); hold on;
    semilogy(EbN0dB,theoreticalSER,plotColor(p)); p=p+1;
end
legend(legendStr);xlabel('Eb/N0(dB)');ylabel('Symbol Error Rate (Ps)');
title('Probability of Symbol Error for M-PAM signals');
