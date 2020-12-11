function [s,t,U,V] = piBy4_dqpsk_mod( a,fc,OF )
%Perform pi/4 DQPSK modulation
%a - input binary data stream (0's and 1's) to modulate
%fc - carrier frequency in Hertz
%OF - oversampling factor
%s - pi/4-DQPSK modulated signal with carrier
%t - time base for the carrier modulated signal
%U - differentially coded I-channel waveform (no carrier)
%V - differentially coded Q-channel waveform (no carrier)

[u,v]=piBy4_dqpsk_Diff_encoding(a);%Differential Encoding for pi/4 QPSK
%Waveform formation (similar to conventional QPSK)
L = 2*OF; %number of samples in each symbol (QPSK has 2 bits/symbol)
U=repmat(u,1,L).'; %odd bit stream at 1/2Tb baud
V=repmat(v,1,L).';%even bit stream at 1/2Tb baud
U = U(:).'; %serialize signal on I arm
V = V(:).'; %serialize signal on Q arm

fs = OF*fc; %sampling frequency
t=0:1/fs:(length(U)-1)/fs; %time base
iChannel = U.*cos(2*pi*fc*t);
qChannel = -V.*sin(2*pi*fc*t);
s = iChannel + qChannel; 

doPlot=1; %switch this off if you do not intend to see waveform plots
if doPlot==1%Waveforms at the transmitter
figure;
subplot(3,2,1);plot(t,U);%zoomed baseband wfm on I arm
xlabel('t'); ylabel('U(t)-baseband');xlim([0,10*L/fs]);
subplot(3,2,2);plot(t,V);%zoomed baseband wfm on Q arm
xlabel('t'); ylabel('V(t)-baseband');xlim([0,10*L/fs]);
subplot(3,2,3);plot(t,iChannel,'r');%U(t) with carrier
xlabel('t'); ylabel('U(t)-with carrier');xlim([0,10*L/fs]);
subplot(3,2,4);plot(t,qChannel,'r');%V(t) with carrier
xlabel('t'); ylabel('V(t)-with carrier');xlim([0,10*L/fs]);
subplot(3,1,3);plot(t,s); %QPSK waveform zoomed to first few symbols
xlabel('t'); ylabel('s(t)');xlim([0,10*L/fs]);
end
end