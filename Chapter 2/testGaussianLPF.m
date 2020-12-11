clearvars; clc;
L = 100; %oversampling factor
Fb = 1e6; %bit rate
k = 3; %span length of gaussian pulse (bits periods)

Tb = 1/Fb; %bit period
Ts = Tb/L; %sampling period

%Gaussian Low pass Filters of different BT products
[h1,t1] = gaussianLPF(1,Tb,L,k); %BT=1
[h2,t2] = gaussianLPF(0.3,Tb,L,k); %BT=0.3
[h3,t3] = gaussianLPF(0.1,Tb,L,k); %BT=0.1

%create isolated rect pulse and filter them through the LPFs
t=-k*Tb:Ts:k*Tb; %truncated time limits for the rectangular pulse
p = (t > -Tb/2) .* (t <= Tb/2);  %centered rectangular pulse - p(t)
g1 = conv(h1,p,'full');g2 = conv(h2,p,'full');g3 = conv(h3,p,'full');

N=length(g1); t = (-N/2:1:N/2-1)/Ts;
subplot(1,2,1); plot(t1/Tb,h1,'b',t1/Tb,h2,'r',t1/Tb,h3,'k');axis tight;
legend('BT=1','BT=0.3','BT=0.1'); title('(a)');xlabel('t/Tb'); ylabel('h(t)');
subplot(1,2,2); plot(t/Tb,g1,'b',t/Tb,g2,'r',t/Tb,g3,'k'); axis tight;
legend('BT=1','BT=0.3','BT=0.1'); title('(b)'); xlabel('t/Tb'); ylabel('g(t)');