[kayit, sample_rate] = audioread('ses.wav');
kayit_noisy = awgn(kayit,10*log10(20),'measured');

%sound(kayit,sample_rate)
%sound(kayit_noisy,sample_rate)

sample_period = 1/sample_rate;
t = (0:sample_period:(length(kayit)-1)/sample_rate);


figure(1);
plot(t,kayit)
title('Original Sound'); xlabel('Time (seconds)'); ylabel('Amplitude')
xlim([0 t(end)])

figure(2);  
plot(t,kayit_noisy)
title('Noisy Sound'); xlabel('Time (seconds)'); ylabel('Amplitude')
xlim([0 t(end)])

[H_kayit, w] = freqz(kayit,1,4096);
H_noisy = freqz(kayit_noisy,1,4096);

figure(3);
subplot(2,1,1)
plot(w/pi,(abs(H_kayit)));
xlabel('w (pi)');
ylabel('|H|');
title('The magnitude of the frequency response of the original sound');
grid on;

subplot(2,1,2)
plot(w/pi,unwrap(angle(H_kayit))/pi);
xlabel('w (pi)');
ylabel('angle(H) (pi)');
title('The phase of the frequency response of the original sound');
grid on;


figure(4);
subplot(2,1,1)
plot(w/pi,(abs(H_noisy)));
xlabel('w (pi)');
ylabel('|H|');
title('The magnitude of the frequency response of the noisy sound');
grid on;

subplot(2,1,2)
plot(w/pi,unwrap(angle(H_noisy))/pi);
xlabel('w (pi)');
ylabel('angle(H) (pi)');
title('The phase of the frequency response of the noisy sound');
grid on;

%% Impulse invariance approach
[b,a] = butter(6,2*pi*1000,'s');
[bz,az] = impinvar(b,a,sample_rate);

H_butter = freqz(bz,az,4096);

figure(5);
plot(w/pi,(abs(H_butter)),'linewidth',2);
%axis([0 1 0 1]);
xlabel('w (pi)');
ylabel('|H|');
title('The magnitude response of the lowpass filter - Impulse invariance approach');
axis square;
grid on;

kayit_ii = filter(bz,az,kayit_noisy);

H_ii = freqz(kayit_ii,1,4096);

figure(6);
subplot(2,1,1)
plot(w/pi,(abs(H_ii)));
xlabel('w (pi)');
ylabel('|H|');
title('The magnitude of the frequency response of the filtered sound');
grid on;

subplot(2,1,2)
plot(w/pi,unwrap(angle(H_ii))/pi);
xlabel('w (pi)');
ylabel('angle(H) (pi)');
title('The phase of the frequency response of the filtered sound');
grid on;

sound(kayit_ii,sample_rate);

%% Bilinear transformation approach
[b,a] = butter(6,0.15);

H_butter = freqz(b,a,4096);

figure(7);
plot(w/pi,(abs(H_butter)),'linewidth',2);
axis([0 1 0 1]);
xlabel('w (pi)');
ylabel('|H|');
title('The magnitude response of the lowpass filter - Bilinear transformation approach');
axis square;
grid on;

kayit_bt = filter(b,a,kayit_noisy);

H_bt = freqz(kayit_bt,1,4096);

figure(8);
subplot(2,1,1)
plot(w/pi,(abs(H_bt)));
xlabel('w (pi)');
ylabel('|H|');
title('The magnitude of the frequency response of the noisy sound');
grid on;

subplot(2,1,2)
plot(w/pi,unwrap(angle(H_bt))/pi);
xlabel('w (pi)');
ylabel('angle(H) (pi)');
title('The phase of the frequency response of the noisy sound');
grid on;

sound(kayit_bt,sample_rate);


%% Parks-McClellan approach
[h_pm, err]= firpm(21,[0 0.1 0.2 1],[1 1 0 0], [1 1]);

H_pmfilter = freqz(h_pm,1,4096);

figure(9);
plot(w/pi,(abs(H_pmfilter)),'linewidth',2);
%axis([0 1 0 1]);
xlabel('w (pi)');
ylabel('|H|');
title('The magnitude response of the lowpass filter - Parks-McClellan approach');
axis square;
grid on;

kayit_pm = filter(h_pm,1,kayit_noisy);

H_pm = freqz(kayit_pm,1,4096);

figure(10);
subplot(2,1,1)
plot(w/pi,(abs(H_pm)));
xlabel('w (pi)');
ylabel('|H|');
title('The magnitude of the frequency response of the noisy sound');
grid on;

subplot(2,1,2)
plot(w/pi,unwrap(angle(H_pm))/pi);
xlabel('w (pi)');
ylabel('angle(H) (pi)');
title('The phase of the frequency response of the noisy sound');
grid on;

sound(kayit_pm,sample_rate);
%% Kaiser window approach
delta_p = 0.05; w_p = 0.1*pi;
delta_s = 0.05; w_s = 0.2*pi;

delta_w = w_s-w_p;
Wc = (w_p+w_s)/2/pi;
A = -20*log10(min(delta_p,delta_s));

beta = 0.5842*(A-21)^(0.4)+0.07886*(A-21);
M = ceil((A-8)/(2.285*delta_w)); % rounded to next integer

kw = kaiser(M,beta);

k_low = fir1(M-1,Wc,'low',kw);

H_kwfilter = freqz(k_low,1,4096);

figure(11);
plot(w/pi,(abs(H_kwfilter)),'linewidth',2);
%axis([0 1 0 1]);
xlabel('w (pi)');
ylabel('|H|');
title('The magnitude response of the lowpass filter - Kaiser window approach');
axis square;
grid on;

kayit_kw = filter(k_low,1,kayit_noisy);

H_kw = freqz(kayit_kw,1,4096);

figure(12);
subplot(2,1,1)
plot(w/pi,(abs(H_kw)));
xlabel('w (pi)');
ylabel('|H|');
title('The magnitude of the frequency response of the noisy sound');
grid on;

subplot(2,1,2)
plot(w/pi,unwrap(angle(H_kw))/pi);
xlabel('w (pi)');
ylabel('angle(H) (pi)');
title('The phase of the frequency response of the noisy sound');
grid on;

sound(kayit_kw,sample_rate);