snr_db=0:2:20;
snr = 10.^(snr_db/10);

%figure()
%% plot QPSK
load QPSK_demo.mat
errs_bit = sim_res(:,1);
nframes = sim_res(:,3);
number_of_bits=4000;

coef = 3/4; % why it's 3/4 is expained in the report

% BER vs SNR; simulation & theory
semilogy(snr_db, errs_bit./nframes/number_of_bits, 'r-+', 'DisplayName','QPSK_s_i_m');hold on;
semilogy(snr_db, coef*2*qfunc(sqrt(snr)), 'rd', 'DisplayName','QPSK_t_h_e_o');hold on;

%% plot BPSK
load BPSK_demo.mat
errs_bit = sim_res(:,1);
nframes = sim_res(:,3);
number_of_bits=4000;

% BER vs SNR; simulation & theory
semilogy(snr_db, errs_bit./nframes/number_of_bits, 'r-x', 'DisplayName','BPSK_s_i_m');hold on;
semilogy(snr_db, qfunc(sqrt(2.*snr)), 'rs', 'DisplayName','BPSK_t_h_e_o');hold on;

%% plot 8PSK uniform
load 8PSK_u_demo.mat
errs_bit = sim_res(:,1);
nframes = sim_res(:,3);
number_of_bits=4002;
M = 8;

coef = 7/12; % why it's 7/12 is expained in the report

% BER vs SNR; simulation & theory
semilogy(snr_db, errs_bit./nframes/number_of_bits, 'g-x', 'DisplayName','8PSK_s_i_m-u');hold on;
semilogy(snr_db, coef*2*qfunc(sqrt(2.*snr).*sin(pi/M)), 'gs', 'DisplayName','8PSK_t_h_e_o-u');hold on;


%% plot BPSK gray
load 8PSK_g_demo.mat
errs_bit = sim_res(:,1);
nframes = sim_res(:,3);
number_of_bits=4002;
M = 8;

coef = 5/12; % why it's 5/12 is expained in the report

% BER vs SNR; simulation & theory
semilogy(snr_db, errs_bit./nframes/number_of_bits, 'g-+', 'DisplayName','8PSK_s_i_m-g');hold on;
semilogy(snr_db, coef*2*qfunc(sqrt(2.*snr).*sin(pi/M)), 'gd', 'DisplayName','8PSK_t_h_e_o-g');hold on;

%% plot 4PAM uniform
load 4PAM_u_demo.mat
errs_bit = sim_res(:,1);
nframes = sim_res(:,3);
number_of_bits=4000;


coef = 5/8; % why it's 5/8 is expained in the report

% BER vs SNR; simulation & theory
semilogy(snr_db, errs_bit./nframes/number_of_bits, 'b-x', 'DisplayName','4PAM_s_i_m-u');hold on;
semilogy(snr_db, coef*(3/2)*qfunc(sqrt(2/5.*snr)), 'bs', 'DisplayName','4PAM_t_h_e_o-u');hold on;

%% plot 4PAM gray
load 4PAM_g_demo.mat
errs_bit = sim_res(:,1);
nframes = sim_res(:,3);
number_of_bits=4000;


coef = 1/2; % why it's 1/2 is expained in the report

% BER vs SNR; simulation & theory
semilogy(snr_db, errs_bit./nframes/number_of_bits, 'b-+', 'DisplayName','4PAM_s_i_m-g');hold on;
semilogy(snr_db, coef*(3/2)*qfunc(sqrt(2/5.*snr)), 'bd', 'DisplayName','4PAM_t_h_e_o-g');hold on;

%% plot 16QAM uniform
load 16QAM_u_demo.mat
errs_bit = sim_res(:,1);
nframes = sim_res(:,3);
number_of_bits=4000;

coef = 31/96; % why it's 31/96 is expained in the report 

% BER vs SNR; simulation & theory
semilogy(snr_db, errs_bit./nframes/number_of_bits, 'm-x', 'DisplayName','16QAM_s_i_m-u');hold on;
semilogy(snr_db, coef*3.*qfunc(sqrt(snr./5)), 'ms', 'DisplayName','16QAM_t_h_e_o-u');hold on;

%% plot 16QAM gray
load 16QAM_g_demo.mat
errs_bit = sim_res(:,1);
nframes = sim_res(:,3);
number_of_bits=4000;
%%
coef = 1/4; % why it's 1/4 is expained in the report

% BER vs SNR; simulation & theory
semilogy(snr_db, errs_bit./nframes/number_of_bits, 'm-+', 'DisplayName','16QAM_s_i_m-g');hold on;
semilogy(snr_db, coef*3.*qfunc(sqrt(snr./5)), 'md', 'DisplayName','16QAM_t_h_e_o-g');hold on;


%% plot BFSK
load BFSK_demo.mat
errs_bit = sim_res(:,1);
nframes = sim_res(:,3);
number_of_bits=4000;


% BER vs SNR; simulation & theory
semilogy(snr_db, errs_bit./nframes/number_of_bits, 'k-x', 'DisplayName','BFSK_s_i_m');hold on;
semilogy(snr_db, qfunc(sqrt(snr)), 'ks', 'DisplayName','BFSK_t_h_e_o');hold on;

%%
grid on;
axis square;
legend;
xlabel 'SNR';
ylabel 'Error Rates';
set(gca,'FontSize',13);
set(gca,'Xtick',0:2:20);
