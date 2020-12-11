% Demonstration of Eb/N0 Vs SER for baseband M-PSK modulation scheme
clear all;clc;
%---------Input Fields------------------------
nSym=100000;%Number of symbols to transmit
EbN0dB = -4:2:24; % Eb/N0 range in dB for simulation
arrayofM=[2,4,8,16,32]; %M-PSK
%----------------------------------------------
plotColor =['b','g','r','c','m']; p=1; %plot colors and variable for color index
legendStr={'Simulated-BPSK','Theoretical-BPSK','Simulated-QPSK','Theoretical-QPSK','Simulated-8PSK','Theoretical-8PSK','Simulated-16PSK','Theoretical-16PSK','Simulated-32PSK','Theoretical-32PSK'};

for M = arrayofM
    %-----Initialization of various parameters----
    k=log2(M); EsN0dB = 10*log10(k)+EbN0dB; %EsN0dB calculation
    SER_sim = zeros(1,length(EbN0dB));
    a=ceil(M.*rand(1,nSym));%Generating a uniformly distributed random symbols from 1:M
    [s,ref]=mpsk_modulator(M,a);%Mapping to M-PSK transmitter constellation
    j=1;
    for i=1:length(EsN0dB)
        [r,~] = add_awgn_noise(s,EsN0dB(i));%add AWGN noise
        [estimatedTxSymbols,acap]= iqOptDetector(r,ref);%Detection in the receiver - Euclidean distance
        SER_sim(j)=sum((a~=acap))/nSym;%symbol error rate computation
        j=j+1;
    end
    SER_theory = ser_awgn(EbN0dB,'mpsk',M); %theoretical SER
    semilogy(EbN0dB,SER_sim,[plotColor(p) '*']); hold on;
    semilogy(EbN0dB,SER_theory,plotColor(p)); p=p+1;
end
legend(legendStr);xlabel('Eb/N0(dB)');ylabel('Symbol Error Rate (Ps)');
title('Probability of Symbol Error for M-PSK signals');
