function [s,t] = mpsk_mod(d,M,L)
%Function to modulate an incoming binary stream using conventional QPSK(baseband)
%d - input binary data stream (0's and 1's) to modulate
%M - number of signaling phases for selected M-PSK
%L - oversampling factor
%s - QPSK modulated signal(baseband)
%t - time base for the modulated signal
N = length(d); %number of symbols
n = log2(M);
ak = 2*d-1; %NRZ encoding 0-> -1, 1->+1
I = ak(1:2:end);%odd bit stream
Q = ak(2:2:end);%even bit stream
I=repmat(I,1,n*L).'; %odd bit stream at 1/nT baud
Q=repmat(Q,1,n*L).';%even bit stream at 1/nT baud
I = I(:).'; %serialize signal on I arm
Q = Q(:).'; %serialize signal on Q arm
t=0:N*L-1; %time base, L=Fs/Fc;
s = I.*cos(2*pi*t/L)-Q.*sin(2*pi*t/L); %QPSK modulated baseband signal
end