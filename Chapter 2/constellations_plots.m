clear;clc;
N=1000;%Number of symbols to transmit, keep it small and adequate
fc=10; OF=8;%carrier frequency and oversampling factor

a = rand(N,1)>0.5; %random symbols from 0's and 1's - input to the modulations
[s_qpsk,t_qpsk,I_qpsk,Q_qpsk] = qpsk_mod(a,fc,OF); %QPSK
[s_oqpsk,t_oqpsk,I_oqpsk,Q_oqpsk] = oqpsk_mod(a,fc,OF); %O-QPSK
[s_piBy4,t_piBy4,I_piBy4,Q_piBy4] = piBy4_dqpsk_mod(a,fc,OF); %pi/4-DQPSK
[s_msk,t_msk,I_msk,Q_msk] = msk_mod(a,fc,OF); %MSK

Ts = 1/(fc*OF); Tsym = Ts*OF;%sampling time and symbol time
t_pulse = -10*Tsym:Ts:10*Tsym;%timebase for Raised Cosine function
rcPulse = raisedCosineFunction(0.3,Tsym,t_pulse);%RC function with 0.3 roll-off

iRC_qpsk = conv(I_qpsk,rcPulse,'same');%RC pulse shaped QPSK I channel
qRC_qpsk = conv(Q_qpsk,rcPulse,'same');%RC pulse shaped QPSK Q channel
iRC_oqpsk = conv(I_oqpsk,rcPulse,'same');%RC pulse shaped O-QPSK I channel
qRC_oqpsk = conv(Q_oqpsk,rcPulse,'same');%RC pulse shaped O-QPSK Q channel
iRC_piBy4 = conv(I_piBy4,rcPulse,'same');%RC pulse shaped pi/4-DQPSK I channel
qRC_piBy4 = conv(Q_piBy4,rcPulse,'same');%RC pulse shaped pi/4-DQPSK Q channel

%Plot constellations
subplot(2,2,1);plot(iRC_qpsk,qRC_qpsk); %RC shaped QPSK
title('QPSK, RC \alpha=0.3');xlabel('I(t)');ylabel('Q(t)');
subplot(2,2,2);plot(iRC_oqpsk,qRC_oqpsk); %RC shaped O-QPSK
title('O-QPSK, RC \alpha=0.3');xlabel('I(t)');ylabel('Q(t)');
subplot(2,2,3);plot(iRC_piBy4,qRC_piBy4); %RC shaped pi/4 DQPSK
title('\pi/4-QPSK, RC \alpha=0.3');xlabel('I(t)');ylabel('Q(t)');
subplot(2,2,4);plot(I_msk(20:end-20),Q_msk(20:end-20)); %For MSK modulation
title('MSK');xlabel('I(t)');ylabel('Q(t)');