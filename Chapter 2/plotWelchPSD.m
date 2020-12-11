function [Pss,f]=plotWelchPSD(SIGNAL,Fs,Fc,COLOR)
%Plot PSD of a carrier modulated SIGNAL using Welch estimate
% SIGNAL - signal vector for which the PSD is plotted
% Fs - Sampling Frequency of the SIGNAL
% Fc - Center-carrier frequency of the SIGNAL
% COLOR - color character for the plot
ns = max(size(SIGNAL));
na = 16;%averaging factor to plot averaged welch spectrum
w = hanning(floor(ns/na));%Hanning window
%Welch PSD estimate with Hanning window and no overlap
[Pss,f]=pwelch(SIGNAL,w,0,[],Fs,'twosided'); 
indices = find(f>=Fc & f<4*Fc); %To plot PSD from Fc to 4*Fc
Pss=Pss(indices)/Pss(indices(1)); %normalized psd w.r.t Fc
plot(f(indices)-Fc,10*log10(Pss),COLOR);%normalize frequency axis
end