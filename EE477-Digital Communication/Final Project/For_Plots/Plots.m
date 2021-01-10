%% Question 1
snr_db=0:2:40;
number_of_bits=4000;
figure(1)

% plot ZFE with 10 taps
load Q1_ZFE.mat
errs_bit = sim_res(:,1);
nframes = sim_res(:,2);
semilogy(snr_db(1:length(errs_bit)), errs_bit./nframes/number_of_bits, 'b-x', 'DisplayName','ZFE-10T');hold on;

% plot MMSE with 10 taps
load Q1_MMSE.mat
errs_bit = sim_res(:,1);
nframes = sim_res(:,2);
semilogy(snr_db(1:length(errs_bit)), errs_bit./nframes/number_of_bits, 'r-x', 'DisplayName','MMSE-10T');hold on;

% plot Viterbi_MLSE
load Q1_Viterbi_MLSE.mat
errs_bit = sim_res(:,1);
nframes = sim_res(:,2);
semilogy(snr_db(1:length(errs_bit)), errs_bit./nframes/number_of_bits, 'g-x', 'DisplayName','Viterbi-MLSE');hold on;

grid on;
axis square;
legend;
xlabel 'SNR';
ylabel 'Error Rates';
set(gca,'FontSize',13);
set(gca,'Xtick',0:2:40);

%% Question 2
number_of_bits=1000;
figure(2)
% plot FDE with 1 prefix cyclic
load Q2_FDE_1PC.mat
errs_bit = sim_res(:,1);
nframes = sim_res(:,2);
semilogy(snr_db(1:length(errs_bit)), errs_bit./nframes/number_of_bits, 'b-x', 'DisplayName','FDE-1PC');hold on;

% plot FDE with 3 prefix cyclic
load Q2_FDE_3PC.mat
errs_bit = sim_res(:,1);
nframes = sim_res(:,2);
semilogy(snr_db(1:length(errs_bit)), errs_bit./nframes/number_of_bits, 'r-x', 'DisplayName','FDE-3PC');hold on;

% plot FDE with 5 prefix cyclic
load Q2_FDE_5PC.mat
errs_bit = sim_res(:,1);
nframes = sim_res(:,2);
semilogy(snr_db(1:length(errs_bit)), errs_bit./nframes/number_of_bits, 'g-x', 'DisplayName','FDE-5PC');hold on;

% plot FDE with 10 prefix cyclic
load Q2_FDE_10PC.mat
errs_bit = sim_res(:,1);
nframes = sim_res(:,2);
semilogy(snr_db(1:length(errs_bit)), errs_bit./nframes/number_of_bits, 'k-x', 'DisplayName','FDE-10PC');hold on;

% plot MMSE with 10 taps
number_of_bits=4000;
load Q1_MMSE.mat
errs_bit = sim_res(:,1);
nframes = sim_res(:,2);
semilogy(snr_db(1:length(errs_bit)), errs_bit./nframes/number_of_bits, 'm-x', 'DisplayName','MMSE-10T');hold on;

grid on;
axis square;
legend;
xlabel 'SNR';
ylabel 'Error Rates';
set(gca,'FontSize',13);
set(gca,'Xtick',0:2:40);