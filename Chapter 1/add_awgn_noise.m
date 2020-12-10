function [r,n] = add_awgn_noise(s,SNR_dB,samplesPerSymbol)
%Function to add AWGN to the given signal
%[r,n]= add_awgn_noise(s,SNR_dB) adds AWGN noise vector to signal 's' to generate a
%resulting signal vector 'r' of specified SNR in dB. It also returns the
%noise vector 'n' that is added to the signal 's'
%[r,n]= add_awgn_noise(s,SNR_dB,samplesPerSymbol) adds AWGN noise vector to signal 's' to generate a
%resulting signal vector 'r' of specified SNR in dB. The samplesPerSymbol specifies the oversampling
%ratio used in the system. It also returns the noise vector 'n' that is added to the signal 's'
L=length(s); s_temp=s;
if iscolumn(s), s=s.'; end
SNR = 10^(SNR_dB/10); %SNR to linear scale
if nargin==2, samplesPerSymbol=1; end %if third argument is not given, set it to 1
Esym=samplesPerSymbol*sum(abs(s).^2)/(L); %Calculate actual symbol energy
N0=Esym/SNR; %Find the noise spectral density
if(isreal(s))
    noiseSigma = sqrt(N0/2);%Standard deviation for AWGN Noise when x is real
    n = noiseSigma*randn(1,L);%computed noise
else
    noiseSigma=sqrt(N0/2);%Standard deviation for AWGN Noise when x is complex
    n = noiseSigma*(randn(1,L)+1i*randn(1,L));%computed noise
end
r = s + n; %received signal
if iscolumn(s_temp), r=r.'; end    %return r in original format as that of s
end