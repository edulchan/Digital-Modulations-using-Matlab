function [H]=convMatrix(h,p)
%Construct the convolution matrix of size (N+p-1)x p from the input
%matrix h of size N.
%typical usage: convolution of signal x and channel h is computed as
%   x=[1 2 3 4]; h=[1 2 3]
%   H=convMatrix(h,length(x))%convolution matrix
%   y=H*x'  %equivalent to conv(h,x)
    h=h(:).';
    col=[h zeros(1,p-1)]; row=[h(1) zeros(1,p-1)];
    H=toeplitz(col,row);
end