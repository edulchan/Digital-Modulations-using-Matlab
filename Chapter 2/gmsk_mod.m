function [s,t,s_complex] = gmsk_mod(a,Fc,L,BT)
%Function to modulate a binary stream using GMSK modulation
%a - input binary data stream (0's and 1's) to modulate
%Fc - RF carrier frequency in Hertz
%L - oversampling factor
%BT - BT product (bandwidth x bit period) for GMSK
%s - GMSK modulated signal with carrier
%t - time base for the carrier modulated signal
%s_complex - baseband GMSK signal (I+jQ)
Fs = L*Fc; Ts=1/Fs;Tb = L*Ts; %derived waveform timing parameters
a=a(:); %serialize input stream
ck = 2*a-1;%NRZ format
ct = kron(ck,ones(L,1));%Convert to waveform using oversampling factor

k=1;%truncation length for Gaussian LPF
ht = gaussianLPF(BT,Tb,L,k); %Gaussian LPF with BT=0.25
bt = conv(ht,ct,'full'); %convolve with Gaussian LPF
%delay = (length(h)-1)/2; %FIR filters group delay
%gt = gt(delay+1:end-delay);%remove unwanted portions in filter output
bt = bt/max(abs(bt));%normalize the output of Gaussian LPF to +/-1
phi = filter(1,[1,-1],bt*Ts);
phi = phi *0.5*pi/Tb; %h=0.5 - %integrate to get phase information

I = cos(phi); Q = sin(phi); %cross-correlated baseband I/Q signals
s_complex = I - 1i*Q; %complex baseband representation

t=((0:1:length(I)-1)*Ts).'; %for RF carrier
iChannel = I.*cos(2*pi*Fc*t); qChannel = Q.*sin(2*pi*Fc*t);
s =(iChannel - qChannel).'; %real signal - with RF carrier

doPlot=1;
if doPlot==1, figure;
    subplot(2,4,1);plot((0:1:length(ct)-1)*Ts,ct);title('c(t)');
    subplot(2,4,2);plot(-k*Tb:Ts:k*Tb,ht);title(['h(t)-BT_b=',num2str(BT)])
    subplot(2,4,5);plot((0:1:length(bt)-1)*Ts,bt);title('b(t)');
    subplot(2,4,6);plot((0:1:length(phi)-1)*Ts,phi);title('\phi(t)');
    subplot(2,4,3);plot(t,I,'--');hold on;plot(t,iChannel,'r');
    xlim([0,10*Tb]);title('I(t)cos(2 \pi f_c t)');
    subplot(2,4,4);plot(t,Q,'--');hold on;plot(t,qChannel,'r');
    xlim([0,10*Tb]);title('Q(t)sin(2 \pi f_c t)');
    subplot(2,4,7);plot(t,s);title('s(t)');xlim([0,10*Tb]);
    subplot(2,4,8); plot(I,Q);title('constellation');
end
end