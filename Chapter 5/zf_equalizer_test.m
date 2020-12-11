clearvars; clc;
%System parameters
nSamp=5; %Number of samples per symbol determines baud rate Tsym
Fs=100; %Sampling Frequency of the system
Ts=1/Fs; %Sampling period
Tsym=nSamp*Ts;

%Define transfer function of the channel
k=6; %define limits for computing channel response
N0 = 0.01; %Standard deviation of AWGN channel noise
t = -k*Tsym:Ts:k*Tsym; %time base defined till +/-kTsym
h = 1./(1+(t/Tsym).^2); %channel model, replace with your own model
h = h + N0*randn(1,length(h)); %add Noise to the channel response
h_c= h(1:nSamp:end); %downsampling to represent the symbol rate sampler
t_inst=t(1:nSamp:end); %symbol sampling instants

figure;
plot(t,h); hold on; %channel response at all sampling instants
stem(t_inst,h_c,'r'); %channel response at symbol sampling instants
legend('channel response','at symbol samp instants');
title('Channel Model - Impulse response');
xlabel('Time (s)');ylabel('Amplitude');

%Equalizer Design Parameters
nTaps = 14; %Desired number of taps for equalizer filter

%design a delay optimized zero-forcing equalizer for the given channel
%and number of equalizer taps

%First find equalizer co-effs for given CIR
[h_eq,error,optDelay]=zf_equalizer(h_c,nTaps);
xn=h_c; %Test the equalizer with the channel response as input
yn=conv(h_eq,xn); %filter input through the equalizer
h_sys=conv(h_eq,h_c); %overall effect of channel and equalizer

disp(['ZF Equalizer Design: N=', num2str(nTaps),...
    ' Delay=',num2str(optDelay),' Error=', num2str(error)]);
disp('ZF equalizer weights:'); disp(h_eq)

%Compute & plot frequency resp. of channel, equalizer & overall system
[H_c,W]=freqz(h_c);     %frequency response of channel
[H_eq,W]=freqz(h_eq);   %frequency response of equalizer
[H_sys,W]=freqz(h_sys); %frequency response of overall system

%freq responses
figure; plot(W/pi,20*log10(abs(H_c)/max(abs(H_c))),'g'); hold on; 
plot(W/pi,20*log10(abs(H_eq)/max(abs(H_eq))),'r'); 
plot(W/pi,20*log10(abs(H_sys)/max(abs(H_sys))),'k');
legend('channel','ZF equalizer','overall system');
title('Frequency response'); ylabel('Magnitude (dB)');
xlabel('Normalized Frequency (x \pi rad/sample)');

figure; %Plot equalizer input and output (time-domain response)
subplot(1,2,1); stem(0:1:length(xn)-1,xn); title('Equalizer input'); 
xlabel('Samples'); ylabel('Amplitude');

subplot(1,2,2); stem(0:1:length(yn)-1,yn);
title(['Equalizer output- N=', num2str(nTaps),...
    ' Delay=',num2str(optDelay), ' Error=', num2str(error)]); 
xlabel('Samples'); ylabel('Amplitude');
