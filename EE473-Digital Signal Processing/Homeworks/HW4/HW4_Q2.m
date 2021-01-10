%-----------------------------part a--------------------------------------%

coefx1 = [0 0 0 1];
coefy1 = 1;
hn1 = filter(coefx1, coefy1, [1 zeros(1, 1e3+23)]); % input is given as unit impulse

n_sample = 1024;
H1 = fftshift(fft(hn1, n_sample));

figure(1);
subplot(1,2,1)
plot(linspace(-pi,pi,n_sample)./pi,abs(H1))
title('The magnitude of frequency response of the system 1');
xlabel('w (pi)');
ylabel('|H1|');
set(gca, 'Ytick', [0.95 1 1.05])
subplot(1,2,2)
plot(linspace(-pi,pi,n_sample)./pi,angle(H1)./pi)
title('The phase of frequency response of the system 1');
xlabel('w (pi)');
ylabel('angle(H1) (pi)');


%-----------------------------part b--------------------------------------%

coefx2 = [-3/4 1];
coefy2 = [1 -3/4];
hn2 = filter(coefx2, coefy2, [1 zeros(1, 1e3+23)]); % input is given as unit impulse

n_sample = 1024;
H2 = fftshift(fft(hn2, n_sample));

figure(2);
subplot(1,2,1)
plot(linspace(-pi,pi,n_sample)./pi,abs(H2))
title('The magnitude of frequency response of the system 2');
xlabel('w (pi)');
ylabel('|H2|');
set(gca, 'Ytick', [0.5 1 1.5])
subplot(1,2,2)
plot(linspace(-pi,pi,n_sample)./pi,angle(H2)./pi)
title('The phase of frequency response of the system 2');
xlabel('w (pi)');
ylabel('angle(H2) (pi)');


%-----------------------------part c--------------------------------------%

n = 0:50;
xn = (3/4).^(n);

figure(3)
stem(n, xn, '*');
title('x[n]');
xlabel('n');
ylabel('x[n]');


%-----------------------------part d--------------------------------------%

yn1 = filter(coefx1, coefy1, xn);
yn2 = filter(coefx2, coefy2, xn);

figure(4)
stem(n,yn1, 'rx'); hold on;
stem(n,yn2, 'b'); hold on;
title('y[n]');
xlabel('n');
ylabel('x[n]');
legend('y1[n]','y2[n]');


%-----------------------------part e--------------------------------------%

n_sample = 1024;
X = fftshift(fft(xn, n_sample));
Y1 = fftshift(fft(yn1, n_sample));
Y2 = fftshift(fft(yn2, n_sample));

figure(5);
subplot(1,3,1)
plot(linspace(-pi,pi,n_sample)./pi,abs(X))
title('The magnitude of x[n]''s DTFT');
xlabel('w (pi)');
ylabel('|X|');
subplot(1,3,2)
plot(linspace(-pi,pi,n_sample)./pi,abs(Y1))
title('The magnitude of y1[n]''s DTFT');
xlabel('w (pi)');
ylabel('|Y1|')
subplot(1,3,3)
plot(linspace(-pi,pi,n_sample)./pi,abs(Y2))
title('The magnitude of y2[n]''s DTFT');
xlabel('w (pi)');
ylabel('|Y2|')

% figure()
% plot(linspace(-pi,pi,n_sample)./pi,abs(X)); hold on;
% plot(linspace(-pi,pi,n_sample)./pi,abs(Y1)); hold on;
% plot(linspace(-pi,pi,n_sample)./pi,abs(Y2)); hold on;
% legend('X','Y1','Y2');

%-----------------------------part f--------------------------------------%

htemp = filter(coefx2, coefy2, [1 zeros(1, 50)]);
hn22 = conv(htemp,htemp);

hn22_multiple = hn22;
for i=1:10
    hn22_multiple = conv(htemp,hn22_multiple);
end

yn22 = conv(hn22,xn);
Y22 = fftshift(fft(yn22, n_sample));

figure(6)
plot(linspace(-pi,pi,n_sample)./pi,abs(Y22))
title('The magnitude of y22[n]''s DTFT');
xlabel('w (pi)');
ylabel('|Y22|');


yn22_multiple = conv(hn22_multiple,xn);
Y22_multiple = fftshift(fft(yn22_multiple, n_sample));

figure(7)
plot(linspace(-pi,pi,n_sample)./pi,abs(Y22_multiple))
title('The magnitude of y22[n]''s DTFT arbitrary number of cascade');
xlabel('w (pi)');
ylabel('|Y22|');


