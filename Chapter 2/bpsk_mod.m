function [s_bb,t] = bpsk_mod(ak,L)
%Function to modulate an incoming binary stream using BPSK(baseband)
%ak - input binary data stream (0's and 1's) to modulate
%L - oversampling factor (Tb/Ts)
%s_bb - BPSK modulated signal(baseband)
%t - generated time base for the modulated signal
N = length(ak); %number of symbols
a = 2*ak-1; %BPSK modulation
ai=repmat(a,1,L).'; %bit stream at Tb baud with rect pulse shape
ai = ai(:).';%serialize
t=0:N*L-1; %time base
s_bb = ai;%BPSK modulated baseband signal
end