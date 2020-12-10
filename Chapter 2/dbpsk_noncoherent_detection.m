%Coherent detection D-BPSK with phase ambiguity in local oscillator
clear all;clc;
%---------Input Fields------------------------
N=100000;%Number of symbols to transmit
EbN0dB = -4:2:14; % Eb/N0 range in dB for simulation
%------Parameters to generate BPSK waveform---
L=8;%oversampling factor,L=Tb/Ts (Tb=bit period,Ts=sampling period)
%if a carrier is used, use L = Fs/Fc, where Fs >> 2xFc
Fc=800; %carrier frequency
Fs=L*Fc;%sampling frequency

EbN0lin = 10.^(EbN0dB/10); %converting dB values to linear scale
BER_suboptimum = zeros(length(EbN0dB),1);%SER sub-optimum receiver
BER_optimum = zeros(length(EbN0dB),1);%SER ptimum receiver

%-----------------Transmitter---------------------
a = rand(N,1)>0.5; %random symbols from 0's and 1's
b = filter(1,[1 -1],a,1);%IIR filter for differential encoding
b = mod(b,2); %XOR operation is equivalent to modulo-2
[s_bb,t]= bpsk_mod(b,L); %BPSK modulation(waveform) - baseband
s = s_bb.*cos(2*pi*Fc*t/Fs); %DPSK with carrier

for i=1:length(EbN0dB),
    %Compute and add AWGN noise
    Esym=L*sum(abs(s).^2)/length(s); %actual symbol energy
    N0= Esym/EbN0lin(i); %Find the noise spectral density
    n=sqrt(N0/2)*(randn(1,length(s))+1i*randn(1,length(s)));%noise
    %Due to oversampling the signal of noise is sqrt(LN0/2).
    
    r = s + n;%received signal with noise
    
    %----------suboptimum receiver---------------
    p=real(r).*cos(2*pi*Fc*t/Fs);%demodulate to baseband using BPF
    
    w0=[p zeros(1,L)];%append L samples on one arm for equal lengths
    w1=[zeros(1,L) p];%delay the other arm by Tb (L samples)
    w = w0.*w1;%multiplier
    z = conv(w,ones(1,L));%integrator from kTb to (K+1)Tb (L samples)
    u = z(L:L:end-L);%sampler t=kTb
    a_cap = u.'<0;%decision
    BER_suboptimum(i) = sum(a~=a_cap)/N;%BER for suboptimum receiver
    
    %-----------optimum receiver--------------
    p=real(r).*cos(2*pi*Fc*t/Fs); %multiply I arm by cos
    q=imag(r).*sin(2*pi*Fc*t/Fs); %multiply Q arm by sin
    
    x = conv(p,ones(1,L));%integrate I-arm by Tb duration (L samples)
    y = conv(q,ones(1,L));%integrate Q-arm by Tb duration (L samples)
    xk = x(L:L:end);%Sample every Lth sample
    yk = y(L:L:end);%Sample every Lth sample
    
    w0 = xk(1:end-1);%non delayed version on I-arm
    w1 = xk(2:end);%1 bit delay on I-arm
    z0 = yk(1:end-1);%non delayed version on Q-arm
    z1 = yk(2:end);%1 bit delay on Q-arm
    
    u =w0.*w1 + z0.*z1;%decision statistic
    a_cap=u.'<0;%threshold detection
    BER_optimum(i) = sum(a(2:end)~=a_cap)/N;%BER for optimum receiver
    
end
%------Theoretical Bit/Symbol Error Rates-------------
theory_DBPSK_optimum = 0.5.*exp(-EbN0lin);
theory_DBPSK_suboptimum = 0.5.*exp(-0.76*EbN0lin);
theory_DBPSK_coherent=erfc(sqrt(EbN0lin)).*(1-0.5*erfc(sqrt(EbN0lin)));
theory_BPSK_conventional = 0.5*erfc(sqrt(EbN0lin));
%-------------Plotting---------------------------
figure;semilogy(EbN0dB,BER_suboptimum,'k*','LineWidth',1.0);
hold on;semilogy(EbN0dB,BER_optimum,'b*','LineWidth',1.0);
semilogy(EbN0dB,theory_DBPSK_suboptimum,'m-','LineWidth',1.0);
semilogy(EbN0dB,theory_DBPSK_optimum,'r-','LineWidth',1.0);
semilogy(EbN0dB,theory_DBPSK_coherent,'k-','LineWidth',1.0);
semilogy(EbN0dB,theory_BPSK_conventional,'b-','LineWidth',1.0);
set(gca,'XLim',[-4 12]);set(gca,'YLim',[1E-6 1E0]);
set(gca,'XTick',-4:2:12);title('Probability of D-BPSK over AWGN');
xlabel('E_b/N_0 (dB)');ylabel('Probability of Bit Error - P_b');
legend('DBPSK subopt (sim)','DBPSK opt (sim)','DBPSK subopt (theory)','DBPSK opt (theory)','coherent DEBPSK','coherent BPSK');