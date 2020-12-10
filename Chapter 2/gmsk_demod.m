function a_cap = gmsk_demod(r,L)
%Function to demodulate a baseband GMSK signal
%r - received signal at the receiver front end (in complex form - I+jQ)
%L - oversampling factor
%a_cap - detected binary stream
I=real(r); Q = -imag(r); %I/Q streams
z1 = Q.*[zeros(L,1); I(1:length(I)-L)];
z2 = I.*[zeros(L,1); Q(1:length(I)-L)];
z = z1 - z2;
a_cap = z(2*L:L:end-L)>0;%sampling and hard decision
%sampling indices depends on the truncation length (k) of Gaussian LPF defined in the modulator
end