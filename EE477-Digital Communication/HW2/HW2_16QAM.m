%% Uniform mapping
clear all
warning off
%%%%%%% INITIALIZATION %%%%%%%%%%%%%%%%%
Infty=50;
number_of_bits=4000;
N=(number_of_bits);
max_nframe =2000; 
ferlim=100; % max # of frames that have error
snr_db=0:2:20;
%%%%% SYMBOL CONSTELLATION %%%%%%%%%
tb4=[0 0;0 1; 1 0; 1 1];
tb8=[zeros(4,1) tb4; ones(4,1) tb4];
tb16=[zeros(8,1) tb8; ones(8,1) tb8];
%%%%%%%%%%%%%CORRELATION MATRICES %%%%%%%%%%%%%%
%%%%%%%%%%%%%%ERROR MATRICES%%%%%%%%%%%%%%%%%%%%
errs_bit=zeros(length(snr_db), 1);% stores bit error for each snr value
errs_symbol=zeros(length(snr_db), 1);% stores symbol error for each snr value
nframes=zeros(length(snr_db), 1);
ferrs=errs_bit;
m_bit=2; n_bit=2;
M=2^(m_bit+n_bit); % # of symbols
bits=tb16;
code_symbols=[-3-3j -1-3j 1-3j 3-3j -3-1j -1-1j 1-1j 3-1j ...
              -3+1j -1+1j 1+1j 3+1j -3+3j -1+3j 1+3j 3+3j]./sqrt(10); % constellation diagram - uniform
tot_bits=m_bit+n_bit;
Nsy=N/tot_bits; % # of symbols that exist in a frame

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for nEN = 1:length(snr_db) % SNR POINTS
    snr_p=snr_db(nEN);
    en = 10^(snr_p/10); % convert SNR from unit db to normal numbers
    sigma = 1/sqrt(en); % standard deviation of AWGN noise
    nframe = 0;
    while (nframe<max_nframe) && (ferrs(nEN)<ferlim)
        err_count=0;
        nframe = nframe + 1;
        info_bits=round(rand(1,number_of_bits));
        info_part=reshape(info_bits, tot_bits, Nsy);
        info_matrix=info_part';
        sym_vec=ones(Nsy, 1);
        for v=1:tot_bits
            sym_vec=sym_vec+info_matrix(:,v).*2^(m_bit+n_bit-v);
        end
        sym_seq=code_symbols(sym_vec); % symbol mapping
        %%%%%%%%%%%%%CHANNEL %%%%%%%%%%%%%%%%%%%%%
        noise=1/sqrt(2)*[randn(1, Nsy) + 1j*randn(1,Nsy)];%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        det_seq=zeros(1,N);
        rec_sig=sym_seq+sigma*noise;
        %%%%DETECTOR %%%%%%%%%%%%
        for k=1:Nsy
            min_metric=10^6; dm=zeros(1,M);
            for r=1:M
                x_r=code_symbols(r);
                dm(r)=norm(rec_sig(k)-x_r);
            end
            [rowmin, sym_ind]=min(dm);
            % bit error
            detected_bits=[bits(sym_ind, :)];
            errb = length(find(info_part(:,k)~=detected_bits'));
            errs_bit(nEN)=errs_bit(nEN)+errb;
            % symbol error
            detected_symbol=sym_ind;
            errs = length(find(sym_vec(k)~=detected_symbol));
            errs_symbol(nEN)=errs_symbol(nEN)+errs;
            err_count=err_count+errb;
        end
        if err_count~=0
            ferrs(nEN)=ferrs(nEN)+1;
        end
    end % End of while loop
    nframes(nEN)=nframe;
    sim_res=[errs_bit errs_symbol nframes]
end %end for (SNR points)
 
sim_res=[errs_bit errs_symbol nframes]
save 16QAM_u_demo.mat sim_res

snr = 10.^(snr_db/10);

figure();

coef = 31/96; % why it's 31/96 is expained in the report 

% BER vs SNR; simulation & theory
semilogy(snr_db, errs_bit./nframes/number_of_bits, 'r-x', 'DisplayName','BERvsSNR_s_i_m-u');hold on;
semilogy(snr_db, coef*3.*qfunc(sqrt(snr./5)), 'rs', 'DisplayName','BERvsSNR_t_h_e_o-u');hold on;


grid on;
axis square;
legend;
xlabel 'SNR';
ylabel 'Error Rates';
set(gca,'FontSize',13);
set(gca,'Xtick',0:2:20);

%% Uniform mapping
clear all
warning off
%%%%%%% INITIALIZATION %%%%%%%%%%%%%%%%%
Infty=50;
number_of_bits=4000;
N=(number_of_bits);
max_nframe =2000; 
ferlim=100; % max # of frames that have error
snr_db=0:2:20;
%%%%% SYMBOL CONSTELLATION %%%%%%%%%
tb4=[0 0;0 1; 1 0; 1 1];
tb8=[zeros(4,1) tb4; ones(4,1) tb4];
tb16=[zeros(8,1) tb8; ones(8,1) tb8];
%%%%%%%%%%%%%CORRELATION MATRICES %%%%%%%%%%%%%%
%%%%%%%%%%%%%%ERROR MATRICES%%%%%%%%%%%%%%%%%%%%
errs_bit=zeros(length(snr_db), 1);% stores bit error for each snr value
errs_symbol=zeros(length(snr_db), 1);% stores symbol error for each snr value
nframes=zeros(length(snr_db), 1);
ferrs=errs_bit;
m_bit=2; n_bit=2;
M=2^(m_bit+n_bit); % # of symbols
bits=tb16;
code_symbols_u=[-3-3j -1-3j 1-3j 3-3j -3-1j -1-1j 1-1j 3-1j ...
              -3+1j -1+1j 1+1j 3+1j -3+3j -1+3j 1+3j 3+3j]./sqrt(10); % constellation diagram - uniform
code_symbols=code_symbols_u([1,2,4,3,5,6,8,7,13,14,16,15,9,10,12,11]); % constellation diagram - gray
tot_bits=m_bit+n_bit;
Nsy=N/tot_bits; % # of symbols that exist in a frame
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for nEN = 1:length(snr_db) % SNR POINTS
    snr_p=snr_db(nEN);
    en = 10^(snr_p/10); % convert SNR from unit db to normal numbers
    sigma = 1/sqrt(en); % standard deviation of AWGN noise
    nframe = 0;
    while (nframe<max_nframe) && (ferrs(nEN)<ferlim)
        err_count=0;
        nframe = nframe + 1;
        info_bits=round(rand(1,number_of_bits));
        info_part=reshape(info_bits, tot_bits, Nsy);
        info_matrix=info_part';
        sym_vec=ones(Nsy, 1);
        for v=1:tot_bits
            sym_vec=sym_vec+info_matrix(:,v).*2^(m_bit+n_bit-v);
        end
        sym_seq=code_symbols(sym_vec); % symbol mapping
        %%%%%%%%%%%%%CHANNEL %%%%%%%%%%%%%%%%%%%%%
        noise=1/sqrt(2)*[randn(1, Nsy) + 1j*randn(1,Nsy)];%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        det_seq=zeros(1,N);
        rec_sig=sym_seq+sigma*noise;
        %%%%DETECTOR %%%%%%%%%%%%
        for k=1:Nsy
            min_metric=10^6; dm=zeros(1,M);
            for r=1:M
                x_r=code_symbols(r);
                dm(r)=norm(rec_sig(k)-x_r);
            end
            [rowmin, sym_ind]=min(dm);
            % bit error
            detected_bits=[bits(sym_ind, :)];
            errb = length(find(info_part(:,k)~=detected_bits'));
            errs_bit(nEN)=errs_bit(nEN)+errb;
            % symbol error
            detected_symbol=sym_ind;
            errs = length(find(sym_vec(k)~=detected_symbol));
            errs_symbol(nEN)=errs_symbol(nEN)+errs;
            err_count=err_count+errb;
        end
        if err_count~=0
            ferrs(nEN)=ferrs(nEN)+1;
        end
    end % End of while loop
    nframes(nEN)=nframe;
    sim_res=[errs_bit errs_symbol nframes]
end %end for (SNR points)
 
sim_res=[errs_bit errs_symbol nframes]
save 16QAM_g_demo.mat sim_res

snr = 10.^(snr_db/10);

coef = 1/4; % why it's 1/4 is expained in the report

% BER vs SNR; simulation & theory
semilogy(snr_db, errs_bit./nframes/number_of_bits, 'b-x', 'DisplayName','BERvsSNR_s_i_m-g');hold on;
semilogy(snr_db, coef*3.*qfunc(sqrt(snr./5)), 'bd', 'DisplayName','BERvsSNR_t_h_e_o-g');hold on;


