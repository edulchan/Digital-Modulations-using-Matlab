function [ak_cap] = bpsk_demod(r_bb,L)
%Function to demodulate an BPSK(baseband) signal
%r_bb - received signal at the receiver front end (baseband)
%N - number of symbols transmitted
%L - oversampling factor (Tsym/Ts)
%ak_cap - detected binary stream
x=real(r_bb); %I arm
x = conv(x,ones(1,L));%integrate for L (Tb) duration
x = x(L:L:end);%I arm - sample at every L
ak_cap = (x > 0).'; %threshold detector
end