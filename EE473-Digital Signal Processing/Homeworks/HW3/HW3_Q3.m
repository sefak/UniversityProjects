%-----------------------------part b--------------------------------------%
N = 9;
k = 0:1:N-1;

w = 2.*pi.*k./N;

Hm = zeros(1,length(w));
Hm(w<pi/2 | w>3/2*pi) = 1;

figure(1);
stem([w./pi 2],[Hm Hm(1)], '*'); % since it is periodic with 2pi, Hm(2pi) equals to Hm(w=0)
xlabel('w in pi');
ylabel('|H(e^j^w))|');
title('The magnitude of frequency response in equally-spaced frequencies');

%-----------------------------part c--------------------------------------%

Hp = exp(-1i.*w.*((N-1)/2));

%-----------------------------part d--------------------------------------%

F = exp(1i.*k'*w);

H = Hm.*Hp;

hn = F^(-1)*H';

figure(2);
% since the imaginary parts are so small (they are in the order of e-15), 
% they are ignored.
stem(k,real(hn), '*');
xlabel('n');
ylabel('h[n]');
title('The impulse response of the implemented filter');


%-----------------------------part e--------------------------------------%
n_sample = 9000;
H_imp = fft(hn, n_sample);

Hnew = zeros(1,n_sample);
wnew = linspace(0,2*pi,n_sample);

figure(3);
plot([w./pi 2], [abs(H) abs(H(1))], '*'); hold on; % since it is periodic with 2pi, H(2pi) equals to H(w=0)
plot(wnew./pi, abs(H_imp), '-.');
xlabel('w in pi');
ylabel('Magnitudes');
title('The magnitude of frequency response of discretized and  system');
legend('discretized system','implemented system');



