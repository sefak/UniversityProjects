snr_db =  0:2:20;
N = [1 5 10 20];
cons=exp(1j*(2*pi*[0:3]/4+pi/4)); % constellation diagram
%theta = [pi/4, 3*pi/4, 5*pi/4, 7*pi/4]; % constellation diagram
fc = 1e9; % carrier frequency
T = 1e-6; % symboling period is 1msec
precision = 1e-8; % the time unit is 1e-8 sec
trial = 100;
t = 0:precision:T-precision; 
len = length(t);
gt = rcosdesign(0.5, 1, 100,'normal'); % raised cosine pulse shaping filter
gt(end)=[];

phase_shift = pi/4; % it is given as pi/4 in the homework

errors = zeros(length(N),length(snr_db));

for nN = 1:length(N)
    pilotsymbols = cons(1).*ones(1,N(nN));
    for nSNR = 1:length(snr_db)
        en = 10^(snr_db(nSNR)/10); % convert SNR from unit db to normal numbers
        sigma = 1/sqrt(en); % standard deviation of AWGN noise
        rlt = ones(1,len*length(pilotsymbols));
        error=0;
        for ntrial = 1:trial
            for nPilot=1:length(pilotsymbols)
                noise=sigma/sqrt(2)*[randn(1, len) + 1j*randn(1,len)];
                rlt(1+len*(nPilot-1):len*nPilot) = gt.*pilotsymbols(nPilot).*exp(1j*phase_shift)+noise;
            end

            % calculation of yk's
            yk = zeros(1,length(pilotsymbols));
            for nk = 1:length(pilotsymbols)
                yk(nk)=sum(rlt(1+len*(nk-1):len*nk).*gt)./len; % integration is taken numerically
            end

            % the formula derived in the class is used.
            detectedPhase = atan(imag(sum(conj(pilotsymbols).*yk))/real(sum(conj(pilotsymbols).*yk)));
            error=error+abs(detectedPhase-phase_shift); 
        end
        errors(nN,nSNR)=error/trial;
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

