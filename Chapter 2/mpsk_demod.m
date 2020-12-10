function [d_cap] = mpsk_demod(r,M,N,L)
%Function to demodulate a conventional QPSK(baseband) signal
%r - received signal at the receiver front end (baseband)
%M - number of signaling phases for selected M-PSK
%N - number of symbols transmitted
%L - oversampling factor
%d_cap - detected binary stream
t=0:N*L-1; %time base, L=Fs/Fc;
x=r.*cos(2*pi*t/L); %I arm
y=-r.*sin(2*pi*t/L); %Q arm
x = conv(x,ones(1,L));%integrate for 2L duration
y = conv(y,ones(1,L));%integrate for 2L duration
x = x(L:2*L:end);%I arm - sample at every 2L
y = y(L:2*L:end);%Q arm - sample at every 2L
d_cap = zeros(N,1);
d_cap(1:2:end) = x.' > 0; %odd bits
d_cap(2:2:end) = y.' > 0; %even bits
end