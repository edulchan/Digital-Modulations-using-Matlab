function [a_cap,x,y] = piBy4_dqpsk_demod(r,fc,OF)
%Function for differential coherent demodulation of pi/4-DQPSK signal
%r - received signal at the receiver front end
%fc - carrier frequency in Hertz
%OF - oversampling factor (multiples of fc) - at least 4 is better
%L - upsampling factor on the inphase and quadrature arms
%a_cap - detected binary stream
fs = OF*fc; %sampling frequency
L = 2*OF; %samples in 2Tb duration
t=0:1/fs:(length(r)-1)/fs;

w=r.*cos(2*pi*fc*t); %I arm
z=-r.*sin(2*pi*fc*t); %Q arm
w = conv(w,ones(1,L));%integrate for L (Tsym=2*Tb) duration
z = conv(z,ones(1,L));%integrate for L (Tsym=2*Tb) duration
w = w(L:L:end);%I arm - sample at every symbol instant Tsym
z = z(L:L:end);%Q arm - sample at every symbol instant Tsym

[a_cap,x,y] = piBy4_dqpsk_Diff_decoding(w,z);

doPlot=0; %To plot constellation at the receiver
if doPlot==1
    figure; plot(w(1:200),z(1:200),'o');
end