function [h_eq,MSE,optDelay]=mmse_equalizer(h_c,snr,N,delay)
% Delay optimized MMSE Equalizer.
%   [h_eq,MSE]=mmse_equalizer(h_c,snr,N,delay) designs a MMSE equalizer
%   h_eq for given channel impulse response h_c, input 'snr' (dB), the
%   desired length of the equalizer N and equalizer delay (delay). It
%   also returns the Mean Square Error (MSE) and the optimal delay
%   (optDelay) of  the designed equalizer.
%
%   [h_eq,MSE,optDelay]=mmse_equalizer(h_c,snr,N) designs a DELAY
%   OPTIMIZED MMSE FORCING equalizer h_eq for given channel impulse
%   response h_c, input 'snr' (dB) and the desired length of the
%   equalizer N. It also returns the Mean Square Error (MSE) and the
%   optimal delay (optDelay) of the  designed equalizer.

    h_c=h_c(:);%channel matrix to solve for simultaneous equations
    L=length(h_c); %length of CIR
    H=convMatrix(h_c,N); %construct (L+N-1)x(N-1) matrix - see chapter
    %'Essentials of Signal processing'-'Methods to compute convolution'
    
    gamma = 10^(-snr/10); %inverse of SNR
    %compute optimum delay
    [~,optDelay] = max(diag(H*inv(conj(H')*H+gamma*eye(N))*conj(H'))); 
    optDelay=optDelay-1; %to account for Matlab's index starting from 1
    n0=optDelay;
    
     if nargin==4,
        if delay >=(L+N-1), error('Too large delay'); end
        n0=delay;
     end    
    d=zeros(N+L-1,1);
    d(n0+1)=1; %optimized position of equalizer delay
    h_eq=inv(conj(H')*H+gamma*eye(N))*conj(H')*d; %Least Squares solution
    MSE=(1-d'*H*inv(conj(H')*H+gamma*eye(N))*conj(H')*d);%assume var(a)=1
end
