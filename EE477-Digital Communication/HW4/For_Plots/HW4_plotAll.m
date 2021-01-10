%% Channel 1
snr_db=0:2:40;
number_of_bits=4000;
figure(1)

% plot Channel 1 - ZFE_9
load CH1_ZFE_9T.mat
errs_bit = sim_res(:,1);
nframes = sim_res(:,2);
% BER vs SNR; simulation
semilogy(snr_db(1:length(errs_bit)), errs_bit./nframes/number_of_bits, 'r-x', 'DisplayName','ZFE-9T');hold on;

% plot Channel 1 - ZFE_15
load CH1_ZFE_15T.mat
errs_bit = sim_res(:,1);
nframes = sim_res(:,2);
% BER vs SNR; simulation
semilogy(snr_db(1:length(errs_bit)), errs_bit./nframes/number_of_bits, 'r-o', 'DisplayName','ZFE-15T');hold on;

% plot Channel 1 - MMSE_9
load CH1_MMSE_9T.mat
errs_bit = sim_res(:,1);
nframes = sim_res(:,2);
% BER vs SNR; simulation
semilogy(snr_db(1:length(errs_bit)), errs_bit./nframes/number_of_bits, 'b-x', 'DisplayName','MMSE-9T');hold on;

% plot Channel 1 - MMSE_15
load CH1_MMSE_15T.mat
errs_bit = sim_res(:,1);
nframes = sim_res(:,2);
% BER vs SNR; simulation
semilogy(snr_db(1:length(errs_bit)), errs_bit./nframes/number_of_bits, 'b-o', 'DisplayName','MMSE-15T');hold on;

% plot Channel 1 - DFE_9
load CH1_DFE_5T.mat
errs_bit = sim_res(:,1);
nframes = sim_res(:,2);
% BER vs SNR; simulation
semilogy(snr_db(1:length(errs_bit)), errs_bit./nframes/number_of_bits, 'k-x', 'DisplayName','DFE-9T');hold on;

% plot Channel 1 - DFE_15
load CH1_DFE_8T.mat
errs_bit = sim_res(:,1);
nframes = sim_res(:,2);
% BER vs SNR; simulation
semilogy(snr_db(1:length(errs_bit)), errs_bit./nframes/number_of_bits, 'k-o', 'DisplayName','DFE-15T');hold on;

grid on;
axis square;
legend;
xlabel 'SNR';
ylabel 'Error Rates';
set(gca,'FontSize',13);
set(gca,'Xtick',0:2:30);

%% Channel 2
figure(2)

% plot Channel 2 - ZFE_9
load CH2_ZFE_9T.mat
errs_bit = sim_res(:,1);
nframes = sim_res(:,2);
% BER vs SNR; simulation
semilogy(snr_db(1:length(errs_bit)), errs_bit./nframes/number_of_bits, 'r-x', 'DisplayName','ZFE-9T');hold on;

% plot Channel 2 - ZFE_15
load CH2_ZFE_15T.mat
errs_bit = sim_res(:,1);
nframes = sim_res(:,2);
% BER vs SNR; simulation
semilogy(snr_db(1:length(errs_bit)), errs_bit./nframes/number_of_bits, 'r-o', 'DisplayName','ZFE-15T');hold on;

% plot Channel 2 - MMSE_9
load CH2_MMSE_9T.mat
errs_bit = sim_res(:,1);
nframes = sim_res(:,2);
% BER vs SNR; simulation
semilogy(snr_db(1:length(errs_bit)), errs_bit./nframes/number_of_bits, 'b-x', 'DisplayName','MMSE-9T');hold on;

% plot Channel 2 - MMSE_15
load CH2_MMSE_15T.mat
errs_bit = sim_res(:,1);
nframes = sim_res(:,2);
% BER vs SNR; simulation
semilogy(snr_db(1:length(errs_bit)), errs_bit./nframes/number_of_bits, 'b-o', 'DisplayName','MMSE-15T');hold on;

% plot Channel 2 - DFE_9
load CH2_DFE_5T.mat
errs_bit = sim_res(:,1);
nframes = sim_res(:,2);
% BER vs SNR; simulation
semilogy(snr_db(1:length(errs_bit)), errs_bit./nframes/number_of_bits, 'k-x', 'DisplayName','DFE-9T');hold on;

% plot Channel 2 - DFE_15
load CH2_DFE_8T.mat
errs_bit = sim_res(:,1);
nframes = sim_res(:,2);
% BER vs SNR; simulation
semilogy(snr_db(1:length(errs_bit)), errs_bit./nframes/number_of_bits, 'k-o', 'DisplayName','DFE-15T');hold on;

grid on;
axis square;
legend;
xlabel 'SNR';
ylabel 'Error Rates';
set(gca,'FontSize',13);
set(gca,'Xtick',0:2:40);

%% Channel 3

figure(3)

% plot Channel 3 - ZFE_9
load CH3_ZFE_9T.mat
errs_bit = sim_res(:,1);
nframes = sim_res(:,2);
% BER vs SNR; simulation
semilogy(snr_db(1:length(errs_bit)), errs_bit./nframes/number_of_bits, 'r-x', 'DisplayName','ZFE-9T');hold on;

% plot Channel 3 - ZFE_15
load CH3_ZFE_15T.mat
errs_bit = sim_res(:,1);
nframes = sim_res(:,2);
% BER vs SNR; simulation
semilogy(snr_db(1:length(errs_bit)), errs_bit./nframes/number_of_bits, 'r-o', 'DisplayName','ZFE-15T');hold on;

% plot Channel 3 - MMSE_9
load CH3_MMSE_9T.mat
errs_bit = sim_res(:,1);
nframes = sim_res(:,2);
% BER vs SNR; simulation
semilogy(snr_db(1:length(errs_bit)), errs_bit./nframes/number_of_bits, 'b-x', 'DisplayName','MMSE-9T');hold on;

% plot Channel 3 - MMSE_15
load CH3_MMSE_15T.mat
errs_bit = sim_res(:,1);
nframes = sim_res(:,2);
% BER vs SNR; simulation
semilogy(snr_db(1:length(errs_bit)), errs_bit./nframes/number_of_bits, 'b-o', 'DisplayName','MMSE-15T');hold on;

% plot Channel 3 - DFE_9
load CH3_DFE_5T.mat
errs_bit = sim_res(:,1);
nframes = sim_res(:,2);
% BER vs SNR; simulation
semilogy(snr_db(1:length(errs_bit)), errs_bit./nframes/number_of_bits, 'k-x', 'DisplayName','DFE-9T');hold on;

% plot Channel 3 - DFE_15
load CH3_DFE_8T.mat
errs_bit = sim_res(:,1);
nframes = sim_res(:,2);
% BER vs SNR; simulation
semilogy(snr_db(1:length(errs_bit)), errs_bit./nframes/number_of_bits, 'k-o', 'DisplayName','DFE-15T');hold on;

grid on;
axis square;
legend;
xlabel 'SNR';
ylabel 'Error Rates';
set(gca,'FontSize',13);
set(gca,'Xtick',0:2:40);


