function [ u,v ] = piBy4_dqpsk_Diff_encoding(a)
%Phase Mapper for pi/4-DQPSK modulation
% a - input stream of binary bits
% u - differentially coded I-channel bits
% v - differentially coded Q-channel bits

if mod(length(a),2), error('Length of binary stream must be even');end
I = a(1:2:end);%odd bit stream
Q = a(2:2:end);%even bit stream
%club 2-bits to form a symbol and use it as index for dTheta table
m = 2*I+Q;
dTheta = [-3*pi/4, 3*pi/4, -pi/4, pi/4]; %LUT for pi/4-DQPSK

u = zeros(length(m)+1,1);v = zeros(length(m)+1,1);
u(1)=1; v(1)=0;%initial conditions for uk and vk

for k=1:length(m)
    u(k+1) = u(k) * cos(dTheta(m(k)+1)) -  v(k) * sin(dTheta(m(k)+1)); 
    v(k+1) = u(k) * sin(dTheta(m(k)+1)) +  v(k) * cos(dTheta(m(k)+1));
end
figure; plot(v,u);%constellation plot
end