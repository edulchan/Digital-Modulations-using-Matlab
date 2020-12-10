L=50;%oversampling factor
Tb=0.5;%bit period in seconds
fs=L/Tb;%sampling frequency in Hertz
fc=2/Tb; %carrier frequency
N = 8;%number of bits to transmit
h=0.5; %modulation index
b=2*(rand(N,1)>0.5)-1;%random information sequence in +1/-1 format
b=repmat(b,1,L).';%oversampling by L samples per bit
b=b(:).';%serialize
theta= pi*h/Tb*filter(1,[1 -1],b,0)/fs;%use FIR integrator filter
t=0:1/fs:Tb*N-1/fs; %time base
s = cos(2*pi*fc*t + theta); %CPFSK signal
subplot(3,1,1);plot(t,b);xlabel('t');ylabel('b(t)');
subplot(3,1,2);plot(t,theta);xlabel('t');ylabel('\theta(t)');
subplot(3,1,3);plot(t,s);xlabel('t');ylabel('s(t)');