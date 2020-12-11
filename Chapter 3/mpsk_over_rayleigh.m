clear all; clc;
%--------Simulation parameters----------------
nSym=10^5; %Number of MPSK Symbols to transmit
EbN0dB = -15:2:20; % bit to noise ratio
MOD_TYPE='MPSK'; %modulation type - 'MPSK' or 'MQAM'
arrayOfM=[2,4,8,16,32,64]; %array of modulation orders

plotColor =['b','g','r','c','m','k']; p=1;
legendString = cell(1,length(arrayOfM)*2); %for legend entries

for M=arrayOfM,    
    k=log2(M); %number of bits per modulated symbol
    EsN0dB = 10*log10(k)+EbN0dB; % converting to symbol energy to noise ratio
    symErrors= zeros(1,length(EsN0dB)); %to store symbol errors
    
    for i=1:length(EsN0dB),%Monte Carlo Simulation
        %-----------------Transmitter--------------------
        d=ceil(M.*rand(1,nSym));%uniformly distributed random data symbols from 1:M
        [s,ref]=modulation_mapper(MOD_TYPE,M,d);
        
        %-------------- Channel ----------------
        h = 1/sqrt(2)*(randn(1,nSym)+1i*randn(1,nSym)); %CIR - 1 tap Rayleigh fading filter
        hs = h.*s; %Rayleigh flat fading effect on the modulated symbols
        r = add_awgn_noise(hs,EsN0dB(i));%add AWGN noise r = h*s+n
        
        %-----------------Receiver----------------------
        y = r./h; %single tap inverting equalizer
        [~,dcap]= iqOptDetector(y,ref);%Optimum IQ detector
        
        %----------------Error counter------------------
        symErrors(i)=sum(d~=dcap);%Count number of symbol errors
    end
    simulatedSER = symErrors/nSym;
    theoreticalSER=ser_rayleigh(EbN0dB,MOD_TYPE,M);
    plot(EbN0dB,log10(simulatedSER),[plotColor(p) 'O']);hold on;
    plot(EbN0dB,log10(theoreticalSER),[plotColor(p) '-']);
    legendString{2*p-1}=['Sim ',num2str(M),'-PSK'];
    legendString{2*p}=['Theory ',num2str(M),'-PSK']; p=p+1;
end
legend(legendString); 
title(['Performance of ',MOD_TYPE,' in Rayleigh flat fading']);
xlabel('Eb/N0 (dB)');ylabel('Symbol Error Rate - P_s');grid on;
