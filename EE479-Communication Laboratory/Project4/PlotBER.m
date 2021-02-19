%% BPSK
snr_db = 0:2:10;
snr = 10.^(snr_db/10);
err = zeros(6,3);
mdl='BPSK_DigitalBandpassComm.slx';
load_system(mdl);
for i = snr_db
    SNR = i;
    sim_out = sim(mdl);
    err(i/2+1,:) = sim_out.simout.Data(end,:);
end

semilogy(snr_db, err(:,1), 'b-x', 'DisplayName','BERvsSNR_s_i_m');hold on;
semilogy(snr_db, qfunc(sqrt(2.*snr)), 'bs', 'DisplayName','BERvsSNR_t_h_e_o');hold on;

grid on;
axis square;
legend;
xlabel 'SNR';
ylabel 'Error Rates';
set(gca,'FontSize',13);

%% 4-PAM
snr_db = 0:2:14;
snr = 10.^(snr_db/10);
err = zeros(8,3);
mdl='PAM4_DigitalBandpassComm.slx';
load_system(mdl);
for i = snr_db
    SNR = i;
    sim_out = sim(mdl);
    err(i/2+1,:) = sim_out.simout.Data(end,:);
end

semilogy(snr_db, err(:,1), 'b-x', 'DisplayName','BERvsSNR_s_i_m');hold on;
semilogy(snr_db, (1/2)*(3/2)*qfunc(sqrt(2/5.*snr)), 'bd', 'DisplayName','BERvsSNR_t_h_e_o');hold on;

grid on;    
axis square;
legend;
xlabel 'SNR';
ylabel 'Error Rates';
set(gca,'FontSize',13);

%% 8PSK
snr_db = 0:2:14;
snr = 10.^(snr_db/10);
err = zeros(8,3);
mdl='PSK8_DigitalBandpassComm.slx';
load_system(mdl);
for i = snr_db
    SNR = i;
    sim_out = sim(mdl);
    err(i/2+1,:) = sim_out.simout.Data(end,:);
end

semilogy(snr_db, err(:,1), 'b-x', 'DisplayName','BERvsSNR_s_i_m');hold on;
semilogy(snr_db, (1/3)*2*qfunc(sqrt(2.*snr).*sin(pi/8)), 'bd', 'DisplayName','BERvsSNR_t_h_e_o');hold on;

grid on;
axis square;
legend;
xlabel 'SNR';
ylabel 'Error Rates';
set(gca,'FontSize',13);

%% 16QAM
snr_db = 0:2:20;
snr = 10.^(snr_db/10);
err = zeros(11,3);
mdl='QAM16_DigitalBandpassComm.slx';
load_system(mdl);
for i = snr_db
    SNR = i;
    sim_out = sim(mdl);
    err(i/2+1,:) = sim_out.simout.Data(end,:);
end

semilogy(snr_db, err(:,1), 'b-x', 'DisplayName','BERvsSNR_s_i_m');hold on;
semilogy(snr_db, (1/4)*3.*qfunc(sqrt(snr./5)), 'bd', 'DisplayName','BERvsSNR_t_h_e_o');hold on;

grid on;
axis square;
legend;
xlabel 'SNR';
ylabel 'Error Rates';
set(gca,'FontSize',13);