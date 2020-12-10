function a_cap = bfsk_coherent_demod(r,Fc,Fd,L,Fs,phase)
%Coherent demodulation of BFSK modulated signal
%r - BFSK modulated signal at the receiver
%Fc - center frequency of the carrier in Hertz
%Fd - frequency separation measured from Fc
%L - number of samples in 1-bit period
%Fs - Sampling frequency for discrete-time simulation
%phase - initial phase generated at the transmitter
%a_cap - data bits after demodulation
t = (0:1:length(r)-1)/Fs; %time base
x = r.*(cos(2*pi*(Fc+Fd/2)*t+phase)-cos(2*pi*(Fc-Fd/2)*t+phase));
y = conv(x,ones(1,L)); %integrate from 0 to Tb
a_cap = y(L:L:end)>0;%sample at every sampling instant and detect
end
 
