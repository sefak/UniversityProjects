snr_db = 0:2:30; % since there is only error due to quantization, to larger snr values makes more sense
N = [1 5 10 20];
cons=exp(1j*(2*pi*[0:3]/4+pi/4)); % constellation diagram
%theta = [pi/4, 3*pi/4, 5*pi/4, 7*pi/4]; % constellation diagram
fc = 1e9; % carrier frequency
T = 1e-6; % symboling period is 1msec
precision = 1e-8; % the time unit is 1e-8 sec
trial = 100; % # of trials to run the code 
t = 0:precision:T-precision; 
len = length(t);
span = 6; % it spans one left and one right symbol
gt = rcosdesign(0.5, span, len/2,'normal'); % raised cosine pulse shaping filter
gt(end)=[];
gt_center = gt((span*len/2)/2-len/2+1:(span*len/2)/2+len/2);

time_shift = T/30; % it is given as pi/4 in the homework and it is assumed that phase shift is positive
time_shift = round(time_shift/precision);

gt_shifted = circshift(gt, time_shift); % it is shifted by the given amount

phase_shift = pi*(2/3); % it is given as pi/4 in the homework


errors_timing = zeros(length(N),length(snr_db));
errors_phase = zeros(length(N),length(snr_db));

detectedPhases = zeros(length(N),length(snr_db));
detectedTiming = zeros(length(N),length(snr_db));

for nN = 1:length(N)
    pilotsymbols = cons(1).*ones(1,N(nN));
    for nSNR = 1:length(snr_db)
        en = 10^(snr_db(nSNR)/10); % convert SNR from unit db to normal numbers
        sigma = 1/sqrt(en); % standard deviation of AWGN noise
        error_timing=0;
        error_phase=0;
        for ntrial = 1:trial
            rlt = zeros(1,len*(length(pilotsymbols)+2)); % most left and right is for the tails of gt
            for nPilot=1:length(pilotsymbols)
                noise=sigma/sqrt(2)*[randn(1, len*3) + 1j*randn(1,len*3)];
                rlt(1+len*(nPilot-1):len*nPilot+2*len) = rlt(1+len*(nPilot-1):len*(nPilot)+2*len)+gt_shifted.*pilotsymbols(nPilot).*exp(1j*phase_shift)+noise;
            end
            rlt([1:len end-len+1:end]) = []; % the tail on the begining and end are removed
            %rlt = awgn(rlt, snr_db(nSNR), 'measured');
           
            % calculation of yk's
            yk_max = -inf;
            phases = linspace(0,2*pi,100);
            for nShift = 1:len
                for nPhase = 1:100
                    gt_nshift=circshift(gt_center,nShift);
                    yk = zeros(1,length(pilotsymbols));
                    for nk = 1:length(pilotsymbols)
                        yk(nk)=sum(rlt(1+len*(nk-1):len*nk).*gt_nshift)./len; % integration is taken numerically
                    end
                    temp = real(exp(1j*phases(nPhase)).*sum(yk.*conj(pilotsymbols)));
                    if temp > yk_max
                        yk_max = temp;
                        ind_time = nShift;
                        ind_phase = nPhase;
                        yk_opt = yk;
                    end
                end
            end
                

            % decision directed maximum likelihood timing estimation is used
            error_timing=error_timing+abs(time_shift-ind_time)/len*T;
            detectedTiming(nN,nSNR) = detectedTiming(nN,nSNR) + ind_time;
            
            detectedPhase = atan(imag(sum(yk_opt.*conj(pilotsymbols)))/real(sum(yk_opt.*conj(pilotsymbols))));
            if detectedPhase <-0.1*pi
                % it is assumed that positive phase shift occurs
                detectedPhase = detectedPhase + pi; % since arctan gives angle [-pi/2 pi/2], to make it positive pi sould be added 
            end
            %detectedPhase = phases(ind_phase);
            error_phase=error_phase+abs(detectedPhase-phase_shift);
            detectedPhases(nN,nSNR) = detectedPhases(nN,nSNR) + detectedPhase;
            
        end
        errors_timing(nN,nSNR)=error_timing/trial;
        errors_phase(nN,nSNR)=error_phase/trial/pi;
        
        detectedTiming(nN,nSNR) = (detectedTiming(nN,nSNR)/trial)/len*T
        detectedPhases(nN,nSNR) = detectedPhases(nN,nSNR)/trial
    end
end

%representing the result
figure();
plot(snr_db, errors_timing(1,:));hold on;
plot(snr_db, errors_timing(2,:));hold on;
plot(snr_db, errors_timing(3,:));hold on;
plot(snr_db, errors_timing(4,:));hold on;
grid on;
axis square;
legend('N=1','N=5','N=10','N=20');
xlabel 'SNR (dB)';
ylabel 'Error in timing Estimation (sec)';
set(gca,'FontSize',13);
set(gca,'Xtick',0:2:30);

figure();
plot(snr_db, errors_phase(1,:));hold on;
plot(snr_db, errors_phase(2,:));hold on;
plot(snr_db, errors_phase(3,:));hold on;
plot(snr_db, errors_phase(4,:));hold on;
grid on;
axis square;
legend('N=1','N=5','N=10','N=20');
xlabel 'SNR (dB)';
ylabel 'Error in Phase Estimation (pi)';
set(gca,'FontSize',13);
set(gca,'Xtick',0:2:30);

