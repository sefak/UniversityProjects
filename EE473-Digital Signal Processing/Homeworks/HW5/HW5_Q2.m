%-----------------------------part a--------------------------------------%
[b,a] = ellip(4,.2,40,[.41 .47]);

[H,w] = freqz(b,a,4096);

figure(1);
plot(w/pi,20*log10(abs(H)));
axis([0 1 -80 10]);
xlabel('w (pi)');
ylabel('|H| (dB)');
title('The magnitude response of the bandpass filter');
grid on;

%-----------------------------part b--------------------------------------%

figure(2);
subplot(1,2,1)
plot(w/pi,20*log10(abs(H)));
axis([0.41 0.47 -0.2 0]);
xlabel('w (pi)');
ylabel('|H| (dB)');
title('The ripples in the passband of the bandpass filter');
grid on;

bnew = b.*10^0.005; % this is explained in the report
[H,w] = freqz(bnew,a,4096);

subplot(1,2,2)
plot(w/pi,20*log10(abs(H)));
grid on;
axis([0.41 0.47 -0.1 0.1]);
xlabel('w (pi)');
ylabel('|H_s| (dB)');
title('The shifted version of the ripples in the passband of the bandpass filter');

%-----------------------------part c--------------------------------------%
h = filter(b,a,[1 zeros(1,4095)]);

figure(3)
stem(h(1:200),'.');
xlabel('n');
ylabel('h[n]');
title('The impulse response of the given bandpass filter');