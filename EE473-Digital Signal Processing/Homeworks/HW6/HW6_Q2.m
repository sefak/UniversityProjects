%% Kaiser Low Pass Filter

delta_p = 0.05; w_p = 0.4*pi;
delta_s = 0.01; w_s = 0.6*pi;

delta_w = w_s-w_p;
Wc = (w_p+w_s)/2/pi;
A = -20*log10(min(delta_p,delta_s));

beta = 0.5842*(A-21)^(0.4)+0.07886*(A-21);
M = ceil((A-8)/(2.285*delta_w)); % rounded to next integer

kw = kaiser(M,beta);

k_low = fir1(M-1,Wc,'low',kw);

[H, w]=freqz(k_low,1,4096);
L=(M-1)/2;
A = real(exp(L*1j*w).*H); % Amplitude of the frequency response, ignores zero imaginary part 

figure(1);
subplot(1,2,1)
plot(w/pi,20*log10(abs(H)));
axis([0 1 -100 10]);
xlabel('w (pi)');
ylabel('|H| (dB)');
title('The magnitude of the frequency response of the Kaiser filter');
grid on;

subplot(1,2,2)
plot(w/pi,unwrap(angle(H))/pi);
%axis([0 1 -1.5 0.5]);
xlabel('w (pi)');
ylabel('angle(H) (pi)');
title('The phase of the frequency response of the Kaiser filter');
grid on;

figure(2);
plot(w/pi,A);
axis([0 1 min(A) max(A)]);
xlabel('w (pi)');
ylabel('amp(H)');
title('The amplitude of the frequency response of the Kaiser filter');
axis square;    
grid on;

figure(3);
subplot(2,1,1)
plot(w/pi,A);
axis([0 0.4 0.987 1.01]);
xlabel('w (pi)');
ylabel('amp(H)');
title('The ripples of the Kaiser filter in the passband');
grid on;

subplot(2,1,2)
plot(w/pi,A);
axis([0.6 1 -0.007 0.014]);
xlabel('w (pi)');
ylabel('amp(H)');
title('The ripples of the Kaiser filter in the stopband');
grid on;