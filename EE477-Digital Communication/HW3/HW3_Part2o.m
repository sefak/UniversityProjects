snr_db = 0:2:20;
N = [1 5 10 20];
cons=exp(1j*(2*pi*[0:3]/4+pi/4)); % constellation diagram
%theta = [pi/4, 3*pi/4, 5*pi/4, 7*pi/4]; % constellation diagram
fc = 1e9; % carrier frequency
T = 1e-6; % symboling period is 1msec
precision = 1e-8; % the time unit is 1e-8 sec
trial = 100;
t = 0:precision:T-precision; 
len = length(t);
gt = rcosdesign(0.5, 10, 10, 'normal'); % raised cosine pulse shaping filter
gt(end)=[];

time_shift = T/4; % it is given as pi/4 in the homework
time_shift = round(time_shift/precision);

gt_shifted = circshift(gt, time_shift);



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
                rlt(1+len*(nPilot-1):len*nPilot) = gt_shifted.*pilotsymbols(nPilot)+noise;
            end

            % calculation of yk's
            yk = zeros(length(pilotsymbols),len);
            for nShift = 1:len
                gt_nshift=circshift(gt,nShift);
                for nk = 1:length(pilotsymbols)
                    yk(nk,nShift)=sum(rlt(1+len*(nk-1):len*nk).*gt_nshift)./len; % integration is taken numerically
                end
            end
            if(length(pilotsymbols)==1)
                % if there is only one plot symbol then no need to summation
                % of the symbols, since there is only one symbol
                [~, ind]=max(real((yk.*pilotsymbols')')); 
            else
                 [~, ind]=max(real(sum(yk.*pilotsymbols')'));
            end
      
            % decision directed maximum likelihood timing estimation is used
            error=error+abs(time_shift-ind)*T; 
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
ylabel 'Error in timing Estimation (sec)';
set(gca,'FontSize',13);
set(gca,'Xtick',0:2:20);

