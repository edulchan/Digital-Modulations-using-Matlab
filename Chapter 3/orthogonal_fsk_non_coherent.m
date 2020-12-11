% Demonstration of Eb/N0 Vs BER for baseband M-orthogonal modulation scheme
clear all; clc;
%---------Input Fields------------------------
N=100000;%Number of symbols to transmit
EbN0dB = -4:2:14; % Eb/N0 range in dB for simulation
arrayofM=[2,4,8,16,32]; %M-level number of orthogonal basis functions
detectionType = 'COHERENT';%valid values : COHERENT/NON_COHERENT
%----------------------------------------------
plotColor =['b','g','r','c','m','k']; %For plotting
p=1; %For plot color index
legendStr={'Sim M=2','Theory M=2','Sim M=4','Theory M=4','Sim M=8','Theory M=8','Sim M=16','Theory M=16','Sim M=32','Theory M=32',};

for M = arrayofM %run this loop for each value of M
    k=log2(M); %Bits per symbol
    %-----------Data generation---------------------
    abits=rand(1,N*k)>=0.5; %Random Information bits (binary format)
    abitArray=reshape(abits,k,N).'; %Convert to row column format - Each row holds one symbol
    factors=2.^[numel(abitArray(1,:))-1:-1:0]; %Multiplication factors for binary to dec conversion
    aSyms=(abitArray*factors.').';%Converted from binary to integer - Symbols

    %---------------------------------------------------------------
    %M-orthogonal Modulator (non-coherent generation and detection)
    %---------------------------------------------------------------
    if strcmpi(detectionType,'COHERENT'),
        phi= zeros(1,M); %phase is zero for coherent detection
    else
        phi = 2*pi*rand(1,M);%M random phases in the interval (0,2pi) for non-coherent
    end
    
    ref = diag(exp(1i*phi));%for signal space representation with random phases
    s = ref(aSyms+1,:); %signal space representation of non-coherent form of orthogonal modulation
    %+1 is added for compatibility with Matlab Index

    EbN0lin = 10.^(EbN0dB/10);%Converting to linear scale
    EsN0lin=k*EbN0lin; %Converting Eb/N0 to Es/N0
    SER = zeros(length(EsN0lin),1); %Place holder for SER values for each Eb/N0
    BER = SER; Ps=SER; Pb=SER; %Place holder
    q=1;

    for EsN0=EsN0lin,
        %Adding noise with variance according to the required Es/N0
        Es=sum(sum(abs(s).^2))/(length(s)); %Calculate actual symbol energy from generated samples
        N0=Es/EsN0; %Find the noise spectral density
        noiseSigma = sqrt(N0/2); %Standard deviation for AWGN Noise
        
        if strcmpi(detectionType,'COHERENT'),
            noise = noiseSigma*(randn(N,M)); %Add noise across M dimensions (real values since phi=0)
        else
            noise = noiseSigma*(randn(N,M)+1i*randn(N,M)); %Add noise across M dimensions
        end

        y=s+noise;  %Channel - Adding AWGN Noise

        %--------Detection in the receiver----------
        if strcmpi(detectionType,'COHERENT'),
            [estimatedTxSymbols,aCapSyms]= minEuclideanDistance(y,ref); %minimum Euclidean distance
        else
            [maxVal,aCapSyms]= max(abs(y),[],2);  %max envelope for non-coherent detection
            aCapSyms = aCapSyms.';
        end
        
        SER(q)=sum((aSyms~=aCapSyms))/N; %Compute Symbol Error Rate
        aCapBits=dec2bin(aCapSyms-1) - '0';%-1 is added for Matlab index to symbol conversion
        aCapBits=reshape(aCapBits.',1,N*k);%Vector of sequence of decoded bits
        BER(q)=sum((abits~=aCapBits))/(N*k); %Compute Bit Error Rate

        if strcmpi(detectionType,'NON_COHERENT'),
            %compute theoretical BER only for non coherent case
            summ=0;
            for i=1:M-1,
               n=M-1; r=i; %for nCr formula
               summ=summ+(-1).^(i+1)./(i+1).*prod((n-r+1:n)./(1:r)).*exp(-i./(i+1).*EsN0);
            end
            Ps(q)=summ; %Theoretical BER for non-coherent detection
            Pb(q)=M/(2*M-2)*Ps(q);%Theoretical Bit error probability
        end        
        q=q+1;
        semilogy(EbN0dB,BER,[plotColor(p) '*']); hold on;    
        
        if strcmpi(detectionType,'NON_COHERENT'), 
           semilogy(EbN0dB,Pb,[plotColor(p) '-']); 
        else
           disp('Use BERTOOL or numerical methods to compute theoretical BER for coherent MFSK');
        end
    end
        p=p+1;    
end
legend(legendStr);grid on;
xlabel('Eb/N0(dB)');ylabel('Bit Error Rate (Pb)');title('Probability of Bit Error for M-Orthogonal signals');
