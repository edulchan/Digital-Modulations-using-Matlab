function [s,t,I,Q] = qpsk_mod(a,fc,OF)
%Function to modulate an incoming binary stream using conventional QPSK
%a - input binary data stream (0's and 1's) to modulate
%fc - carrier frequency in Hertz
%OF - oversampling factor (multiples of fc) - at least 4 is better
%s - QPSK modulated signal with carrier
%t - time base for the carrier modulated signal
%I - unmodulated I channel (no carrier)
%Q - unmodulated I channel (no carrier)
L = 2*OF; %number of samples in each symbol (QPSK has 2 bits per symbol)

ak = 2*a-1; %NRZ encoding 0-> -1, 1->+1
I = ak(1:2:end);Q = ak(2:2:end);%even and odd bit streams
I=repmat(I,1,L).'; Q=repmat(Q,1,L).';%even and odd bit streams at 1/2Tb baud
I = I(:).'; Q = Q(:).'; %serialize

fs = OF*fc; %sampling frequency
t=0:1/fs:(length(I)-1)/fs; %time base
iChannel = I.*cos(2*pi*fc*t);qChannel = -Q.*sin(2*pi*fc*t);
s = iChannel + qChannel; %QPSK modulated baseband signal

doPlot=1; %switch this off if you do not intend to see waveform plots
if doPlot==1%Waveforms at the transmitter
figure;subplot(3,2,1);plot(t,I);%baseband waveform on I arm zoomed to first few symbols
xlabel('t'); ylabel('I(t)-baseband');xlim([0,10*L/fs]);
subplot(3,2,2);plot(t,Q);%baseband waveform on Q arm zoomed to first few symbols
xlabel('t'); ylabel('Q(t)-baseband');xlim([0,10*L/fs]);
subplot(3,2,3);plot(t,iChannel,'r');%I(t) with carrier
xlabel('t'); ylabel('I(t)-with carrier');xlim([0,10*L/fs]);
subplot(3,2,4);plot(t,qChannel,'r');%Q(t) with carrier
xlabel('t'); ylabel('Q(t)-with carrier');xlim([0,10*L/fs]);
subplot(3,1,3);plot(t,s); %QPSK waveform zoomed to first few symbols
xlabel('t'); ylabel('s(t)');xlim([0,10*L/fs]);
end
