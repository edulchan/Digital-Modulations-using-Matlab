function [ a_cap,x,y ] = piBy4_dqpsk_Diff_decoding(w,z)
%Phase Mapper for pi/4-DQPSK modulation
% w - differentially coded I-channel bits at the receiver
% z - differentially coded Q-channel bits at the receiver
% a_cap - binary bit stream after differential decoding

if length(w)~=length(z), error('Length mismatch between w and z'); end

x = zeros(1,length(w)-1);y = zeros(1,length(w)-1);

for k=1:length(w)-1
    x(k) = w(k+1)*w(k) + z(k+1)*z(k);
    y(k) = z(k+1)*w(k) - w(k+1)*z(k);
end
a_cap = zeros(1,2*length(x));
a_cap(1:2:end) = x > 0; %odd bits
a_cap(2:2:end) = y > 0; %even bits
end