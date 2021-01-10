%-----------------------------part a--------------------------------------%
[b,a] = ellip(4,.2,40,[.41 .47]);

[bc,ac]=df2cf(b,a);

%-----------------------------part b--------------------------------------%
hc = [1 zeros(1,4095)];
for n = 1:size(bc, 1)
    hc = filter(bc(n,:),ac(n,:),hc);
end

figure(1)
stem(hc(1:200),'.');
xlabel('n');
ylabel('h[n]');
title('The impulse response of the cascaded version of the given bandpass filter');

max_diff1 = max(hc-filter(b,a,[1 zeros(1,4095)]));

%-----------------------------part c--------------------------------------%
acq16 = zeros(size(bc, 1),size(bc, 2));
bcq16 = zeros(size(bc, 1),size(bc, 2));
for n = 1:size(bc, 1)
    M = max(abs([bc(n,:) ac(n,:)]));
    acq16(n,:) = quant(ac(n,:),16,M);
    bcq16(n,:) = quant(bc(n,:),16,M);
end

hc16 = [1 zeros(1,4095)];
for n = 1:size(bc, 1)
   hc16 = filter(bc(n,:),ac(n,:),hc16);
end

figure(2)
stem(hc16(1:200),'.');
xlabel('n');
ylabel('h[n]');
title('The impulse response of the 16 bits quantized and cascaded version of the given bandpass filter');


max_diff2 = max(hc16-filter(b,a,[1 zeros(1,4095)]));

%-----------------------------part d--------------------------------------%

[H_c16,w_c16] = freqz(hc16,1,4096);

figure(3);
subplot(1,2,1)
plot(w_c16/pi,20*log10(abs(H_c16)));
axis([0 1 -80 10]);
xlabel('w (pi)');
ylabel('|H| (dB)');
title('The magnitude response of the cascaded version of the bandpass filter');
grid on;
subplot(1,2,2)
plot(w_c16/pi,20*log10(abs(H_c16)));
axis([0.41 0.47 -0.2 0]);
xlabel('w (pi)');
ylabel('|H| (dB)');
title('The magnitude response of the cascaded version of the bandpass filter zoomed to passband');
grid on;

for n = 1:size(bcq16, 1)
    figure(n+3);
    dpzplot(bcq16(n,:),acq16(n,:));
    xlabel('Re');
    ylabel('Im');
    title(sprintf('Poles and zeros of the quantized filter %d', n));
end


%-----------------------------part e--------------------------------------%

acq12 = zeros(size(bc, 1),size(bc, 2));
bcq12 = zeros(size(bc, 1),size(bc, 2));
for n = 1:size(bc, 1)
    M = max(abs([bc(n,:) ac(n,:)]));
    acq12(n,:) = quant(ac(n,:),12,M);
    bcq12(n,:) = quant(bc(n,:),12,M);
end

hc12 = [1 zeros(1,4095)];
for n = 1:size(bc, 1)
   hc12 = filter(bc(n,:),ac(n,:),hc12);
end

figure(8)
stem(hc12(1:200),'.');
xlabel('n');
ylabel('h[n]');
title('The impulse response of the 12 bits quantized and cascaded version of the given bandpass filter');


max_diff3 = max(hc12-filter(b,a,[1 zeros(1,4095)]));


[H_c12,w_c12] = freqz(hc12,1,4096);

figure(9);
subplot(1,2,1)
plot(w_c12/pi,20*log10(abs(H_c12)));
axis([0 1 -80 10]);
xlabel('w (pi)');
ylabel('|H| (dB)');
title('The magnitude response of the cascaded version of the bandpass filter');
grid on;
subplot(1,2,2)
plot(w_c12/pi,20*log10(abs(H_c12)));
axis([0.41 0.47 -0.2 0]);
xlabel('w (pi)');
ylabel('|H| (dB)');
title('The magnitude response of the cascaded version of the bandpass filter zoomed to passband');
grid on;


for n = 1:size(bcq12, 1)
    figure(n+9);
    dpzplot(bcq12(n,:),acq12(n,:));
    xlabel('Re');
    ylabel('Im');
    title(sprintf('Poles and zeros of the quantized filter %d', n));
end