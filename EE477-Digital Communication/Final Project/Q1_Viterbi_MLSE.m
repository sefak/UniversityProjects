%%%%%%% ZERO FORCING EQUALIZER %%%%%%%%%%%%%%
clear all
warning off
%%%%%%% INITIALIZATION %%%%%%%%%%%%%%%%%
number_of_bits=4000;
N=(number_of_bits);
max_nframe=1000;
ferlim=200;
snr_db=0:2:16;
code_symbols = [-1 1];
fl = [0 0 0 0 0.74 -0.514 0.37 0.216 0.062]; % channel 
chan_size = length(fl);
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
        send_bits=code_symbols(round(rand(1,N))+1);
        candidate_bits1 = zeros(1,N);
        candidate_bits2 = zeros(1,N);
        %%%%%%%%%%%%%CHANNEL %%%%%%%%%%%%%%%%%%%%%
        noise=1/sqrt(2)*[randn(1, N) + 1j*randn(1,N)];
        isi_bits = conv(send_bits,fl,'same');
        rec_bits = isi_bits+sigma*noise; %awgn(isi_bits,snr_p,'measured');
        %%%%DETECTOR %%%%%%%%%%%%
        
        % ----------------Initialization of the stages------------------- % 
        
        % since channel has 5, all 2^5 combination should be tried at the
        % beginning
        
        tb8=[zeros(4,1) [0 0;0 1; 1 0; 1 1]; ones(4,1) [0 0;0 1; 1 0; 1 1]];
        tb16=[zeros(8,1) tb8; ones(8,1) tb8];
        tb32 = [zeros(16,1) tb16; ones(16,1) tb16];
        temp = code_symbols(tb32+1);
        dm = zeros(1,32);
        for n = 1:32
           temp_bits = conv(temp(n,:), fl, 'same');
           dm(n) = norm(temp_bits-rec_bits(1:5));
        end
        [~, seq_ind]=min(dm);
        candidate_bits1(1:5)=temp(seq_ind,:);
        dm(seq_ind) = inf;
        [~, seq_ind]=min(dm);
        candidate_bits2(1:5)=temp(seq_ind,:);
        
        % ----------------------The middle stages------------------------ %
        temp = [];
        for n = 6:N
           temp(1,:) = [candidate_bits1(n-5:n-1) -1];
           temp(2,:) = [candidate_bits1(n-5:n-1) 1];
           temp(3,:) = [candidate_bits2(n-5:n-1) -1];
           temp(4,:) = [candidate_bits2(n-5:n-1) 1];
           
           dm = zeros(1,4); 
           for nt = 1:4
              temp_bits = conv(temp(nt,:),fl,'same');
              dm(nt) = norm(temp_bits-rec_bits(n-5:n));
           end
           
           if dm(1)<dm(2)
              candidate_bits1(n) = -1;
           else
              candidate_bits1(n) = 1;
           end
           if dm(3)<dm(4)
              candidate_bits2(n) = -1;
           else
              candidate_bits2(n) = 1;
           end  
        end
        % -------------------------The end stages------------------------ %
        
        
        if norm(conv(candidate_bits1,fl,'same')-rec_bits)<norm(conv(candidate_bits2,fl,'same')-rec_bits)
            detected_bits = candidate_bits1;
        else
            detected_bits = candidate_bits2;
        end
        
        err = sum(send_bits~=detected_bits);
        errs(nEN)=errs(nEN)+err;
        err_count=err_count+err;
        if err_count~=0
            ferrs(nEN)=ferrs(nEN)+1;
        end
    end % End of while loop
    nframes(nEN)=nframe;
    sim_res=[errs nframes]
end %end for (SNR points)
sim_res=[errs nframes]
%save(sprintf('Q1_Viterbi_MLSE.mat'),'sim_res');

semilogy(snr_db, errs./nframes/number_of_bits, 'g-x'); hold on;
axis square;
grid on;


