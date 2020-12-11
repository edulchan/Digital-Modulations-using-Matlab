function z=receiver_impairments(r,g,phi,dc_i,dc_q)
%Function to add receiver impairments to the IQ branches
%[z]=iq_imbalance(r,g,phi) introduces DC and IQ imbalances
%  between the inphase and quadrature components of the complex
%  baseband signal r. The model parameter g represent the gain
%  mismatch between the IQ branches of the receiver and the
%  parameter 'phi' represents the phase error of the local
%  oscillator (in degrees). The DC biases associated with each
%  I,Q path are represented by the paramters dc_i and dc_q.

k = iq_imbalance(r,g,phi); %Add IQ imbalance
z = dc_impairment(k,dc_i,dc_q); %Add DC impairment
end