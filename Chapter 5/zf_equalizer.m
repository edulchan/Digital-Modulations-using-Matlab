function [h_eq,err,optDelay]=zf_equalizer(h_c,N,delay)
% Delay optimized Zero Forcing Equalizer.
%   [h_eq,err,optDelay]=zf_equalizer(h_c,N,delay) designs a
%   ZERO FORCING equalizer h_eq for given channel impulse
%   response h_c, the desired length of the equalizer N and
%   equalizer delay (delay). It also returns the equalizer
%   error (err) and the best optimal delay (optDelay)
%   that could work best for the designed equalizer
%
%   [h_eq,err,optDelay]=zf_equalizer(h_c,N) designs a
%   DELAY OPTIMIZED ZERO FORCING equalizer h_eq for given
%   channel impulse response h_c, the desired length of the
%   equalizer N. It also returns the equalizer error(err) and
%   the best optimal delay(optDelay).

    h_c=h_c(:); %Channel matrix to solve simultaneous equations
    L=length(h_c); %length of CIR
    H=convMatrix(h_c,N); %(L+N-1)x(N-1) matrix - see Chapter 1
    %section title -Methods to compute convolution
    
    %compute optimum delay based on MSE
    [~,optDelay] = max(diag(H*inv(conj(H')*H)*conj(H'))); 
    optDelay=optDelay-1;%Since Matlab index starts from 1
    n0=optDelay;
    
    if nargin==3,
        if delay >=(L+N-1), error('Too large delay'); end
        n0=delay;
    end
    d=zeros(N+L-1,1);
    d(n0+1)=1; %optimized position of equalizer delay
    h_eq=inv(conj(H')*H)*conj(H')*d;%Least Squares solution
    err=1-H(n0+1,:)*h_eq; %equalizer error (MSE)-reference [5]
    MSE=(1-d'*H*inv(conj(H')*H)*conj(H')*d);%MSE and err are equivalent
end
