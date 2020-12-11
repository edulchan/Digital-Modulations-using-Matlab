function [a_cap] = oqpsk_demod(r,N,fc,OF)
%Function to demodulate a bandpass O-QPSK signal
%r - received signal at the receiver front end
%N - number of symbols transmitted
%fc - carrier frequency in Hertz
%OF - oversampling factor (multiples of fc) - at least 4 is better
%L - upsampling factor on the inphase and quadrature arms
%a_cap - detected binary stream
fs = OF*fc; %sampling frequency
L = 2*OF; %samples in 2Tb duration
t=(0:1:(N+1)*OF-1)/fs; %time base

x=r.*cos(2*pi*fc*t); %I arm
y=-r.*sin(2*pi*fc*t); %Q arm
x = conv(x,ones(1,L));%integrate for L (Tsym=2*Tb) duration
y = conv(y,ones(1,L));%integrate for L (Tsym=2*Tb) duration
x = x(L:L:end-L);%I arm - sample at the end of every symbol
%Q arm - sample at end of every symbol starting L+L/2th sample
y = y(L+L/2:L:end-L/2);

a_cap = zeros(N,1);
a_cap(1:2:end) = x.' > 0; %even bits
a_cap(2:2:end) = y.' > 0; %odd bits

doPlot=0; %To plot constellation at the receiver
if doPlot==1, figure; plot(x(1:200),y(1:200),'o');end