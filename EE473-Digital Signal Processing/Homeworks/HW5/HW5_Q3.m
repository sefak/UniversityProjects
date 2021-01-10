%-----------------------------part a--------------------------------------%
[b,a] = ellip(4,.2,40,[.41 .47]);

M = max(abs([b a]));
a16 = quant(a,16,M);
b16 = quant(b,16,M);

maxChange_a16 = max(abs(a-a16));
maxChange_b16 = max(abs(b-b16));

[H,w] = freqz(b16,a16,4096);

figure(1);
subplot(1,2,1)
plot(w/pi,20*log10(abs(H)));
axis([0 1 -80 10]);
xlabel('w (pi)');
ylabel('|H| (dB)');
title('The magnitude response of the bandpass filter');
grid on;
subplot(1,2,2)
plot(w/pi,20*log10(abs(H)));
axis([0.41 0.47 -3.6 1.4]);
xlabel('w (pi)');
ylabel('|H| (dB)');
title('The ripples in the passband of the bandpass filter');
grid on;

%-----------------------------part b--------------------------------------%
figure(2);
dpzplot(b16,a16);
xlabel('Re');
ylabel('Im');
title('Poles and zeros of the quantized filter');

%-----------------------------part c--------------------------------------%
a12 = quant(a,12,M);
b12 = quant(b,12,M);

maxChange_a12 = max(abs(a-a12));
maxChange_b12 = max(abs(b-b12));


[H,w] = freqz(b12,a12,4096);

figure(3);
subplot(1,2,1)
plot(w/pi,20*log10(abs(H)));
axis([0 1 -80 10]);
xlabel('w (pi)');
ylabel('|H| (dB)');
title('The magnitude response of the bandpass filter');
grid on;
subplot(1,2,2)
plot(w/pi,20*log10(abs(H)));
axis([0.41 0.47 -1.6 4.8]);
xlabel('w (pi)');
ylabel('|H| (dB)');
title('The ripples in the passband of the bandpass filter');
grid on;

figure(4);
dpzplot(b12,a12);
xlabel('Re');
ylabel('Im');
title('Poles and zeros of the quantized filter');

%-----------------------------part e--------------------------------------%
h = filter(b12,a12,[1 zeros(1,4095)]);

figure(5)
stem(h,'.');
xlabel('n');
ylabel('h[n]');
title('The impulse response of the 12 bits quantized version of the given bandpass filter');
