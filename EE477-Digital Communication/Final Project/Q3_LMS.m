%%%%%%% ZERO FORCING EQUALIZER %%%%%%%%%%%%%%
clear all
warning off
%%%%%%% INITIALIZATION %%%%%%%%%%%%%%%%%
number_of_bits=4000;
N=(number_of_bits);
max_nframe=1000;
ferlim=200;
snr_db=0:2:30;
code_symbols = [-1 1];
fl = [0.74 -0.514 0.37 0.216 0.062]; % channel 
tap_num = 10; % determination of the tap number
pilot_num = 10; % number of pilot symbols
trial_num = 10; % number of training trails
step_size = 0.05; % step size of the update in equalizer coefficients
%%%%%%%%%%%%%%ERROR MATRICES%%%%%%%%%%%%%%%%%%%%
errs=zeros(length(snr_db), 1);
nframes=zeros(length(snr_db), 1);
ferrs=errs;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for nEN = 1:length(snr_db) % SNR POINTS
    snr_p=snr_db(nEN);
    en = 10^(snr_p/10); % convert SNR from unit db to normal numbers
    sigma = 1/sqrt(en); % standard deviation of AWGN noise
    nframe = 0;
    while (nframe<max_nframe) && (ferrs(nEN)<ferlim)
        err_count=0;
        nframe = nframe + 1;
        pilot_bits = code_symbols(round(rand(1,pilot_num))+1); % pilot bits are all 1s
        send_bits=[pilot_bits code_symbols(round(rand(1,N))+1)];
        %%%%%%%%%%%%%CHANNEL %%%%%%%%%%%%%%%%%%%%%
        noise=1/sqrt(2)*[randn(1, N+pilot_num) + 1j*randn(1,N+pilot_num)];
        isi_bits = conv(send_bits,[0 0 0 0 fl],'same');
        rec_bits = isi_bits+sigma*noise; %awgn(isi_bits,snr_p,'measured');
        %---------------------Training of the Equalizer-------------------%
        w_opt = zeros(1,tap_num); % initialiazation of the eequalizer coeff.
        rec_pilot_bits = rec_bits(1:pilot_num);
        for n = 1:trial_num
           error = rec_pilot_bits - conv(pilot_bits, w_opt, 'same');
           w_opt = w_opt + step_size*pilot_bits*error';
        end        
        equalized_bits = conv(rec_bits, w_opt, 'same');
        %%%%DETECTOR %%%%%%%%%%%%
        for k=1+pilot_num:N+pilot_num
            dm = zeros(1,2);
            for r=1:2
                x_r=code_symbols(r);
                dm(r)=norm(equalized_bits(k)-x_r);
            end
            [rowmin, sym_ind]=min(dm);
            detected_bits=code_symbols(sym_ind);
            err = send_bits(k)~=detected_bits;
            errs(nEN)=errs(nEN)+err;
            err_count=err_count+err;
        end
        if err_count~=0
            ferrs(nEN)=ferrs(nEN)+1;
        end
    end % End of while loop
    nframes(nEN)=nframe;
    sim_res=[errs nframes]
end %end for (SNR points)
sim_res=[errs nframes]
%save(sprintf('Q1_ZFE.mat'),'sim_res');

semilogy(snr_db, errs./nframes/number_of_bits, 'r-x'); hold on;
axis square;
grid on;