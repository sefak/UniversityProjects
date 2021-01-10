snr_db =  0:2:20;
N = [1 5 10 20];
cons=exp(1j*(2*pi*[0:3]/4+pi/4)); % constellation diagram
%theta = [pi/4, 3*pi/4, 5*pi/4, 7*pi/4]; % constellation diagram
fc = 1e9; % carrier frequency
T = 1e-6; % symboling period is 1msec
precision = 1e-8; % the time unit is 1e-8 sec
trial = 1000; % # of trials to run the code
t = 0:precision:T-precision; 
len = length(t);
span = 6; % it spans one left and one right symbol
gt = rcosdesign(0.5, span, len/2,'normal'); % raised cosine pulse shaping filter
gt(end)=[];
gt_center = gt((span*len/2)/2-len/2+1:(span*len/2)/2+len/2);

phase_shift = pi/4; % it is given as pi/4 in the homework and it is assumed that phase shift is positive

errors = zeros(length(N),length(snr_db));
detectedPhases = zeros(length(N),length(snr_db));

for nN = 1:length(N)
    pilotsymbols = cons(1).*ones(1,N(nN));
    for nSNR = 1:length(snr_db)
        en = 10^(snr_db(nSNR)/10); % convert SNR from unit db to normal numbers
        sigma = 1/sqrt(en); % standard deviation of AWGN noise
        error=0;
        for ntrial = 1:trial
            rlt = zeros(1,len*(length(pilotsymbols)+2)); % most left and right is for the tails of gt
            for nPilot=1:length(pilotsymbols)
                noise=sigma/sqrt(2)*[randn(1, len*3) + 1j*randn(1,len*3)];
                rlt(1+len*(nPilot-1):len*nPilot+2*len) = rlt(1+len*(nPilot-1):len*(nPilot)+2*len)+gt.*pilotsymbols(nPilot).*exp(1j*phase_shift)+noise;
            end
            rlt([1:len end-len+1:end]) = []; % the tail on the begining and end are removed
            %rlt = awgn(rlt, snr_db(nSNR), 'measured');
            
            % calculation of yk's
            yk = zeros(1,length(pilotsymbols));
            for nk = 1:length(pilotsymbols)
                yk(nk)=sum(rlt(1+len*(nk-1):len*nk).*gt_center)./len; % integration is taken numerically
            end

            % the formula derived in the class is used.
            detectedPhase = atan(imag(sum(yk.*conj(pilotsymbols)))/real(sum(yk.*conj(pilotsymbols))));
            if detectedPhase <-0.1*pi
                % it is assumed that positive phase shift occurs
                detectedPhase = detectedPhase + pi; % since arctan gives angle [-pi/2 pi/2], to make it positive pi sould be added 
            end
            error=error+abs(detectedPhase-phase_shift);
            detectedPhases(nN,nSNR) = detectedPhases(nN,nSNR) + detectedPhase; 
        end
        errors(nN,nSNR)=error/trial/pi;
        detectedPhases(nN,nSNR) = detectedPhases(nN,nSNR)/trial
    end

end

%representing the result
figure();
plot(snr_db, errors(1,:));hold on;
plot(snr_db, errors(2,:));hold on;
plot(snr_db, errors(3,:));hold on;
plot(snr_db, errors(4,:));hold on;
grid on;
axis square;
legend('N=1','N=5','N=10','N=20');
xlabel 'SNR (dB)';
ylabel 'Error Phase Estimation (pi)';
set(gca,'FontSize',13);
set(gca,'Xtick',0:2:20);

