% Homework1 Question 3


%-----------------------------part a-------------------------------------%

n = -10:100; % the indecies for the desired range

coefx = [1 0.5 0]; % coefficients of the x's starting from x[n]
coefy = [1 -1.8*cos(pi/16) 0.81]; % coefficients of the y's starting from y[n]


% It can also be calculated by using 'dimpulse' function 
% % using the function dimpulse, the impulse response is evaluated
% % n = 0:100;
%   [h,x] = dimpulse(coefx, coefy, length(n));
% 
% % since the given system can be expressed as difference eqn. and there are
% % no auxiliary conditions, then it should be causal LTI system. Therefore, 
% % it has no value in the negative side of the time axis.
% h = [zeros(1,10), h'];  
% n = [-10:-1, n];

% dirac delta function in discrete time
dir = zeros(1,111);
dir(11) = 1; % impulse at n=0
h = filter(coefx, coefy, dir);

figure(1)
stem(n, h, '.'); % ploting the h[n]
title('The impulse response of the given difference equation');
xlabel('n');
ylabel('h[n]');


%-----------------------------part c-------------------------------------%

x1 = exp(1i.*(pi/3).*n).*(n>=0);

y1 = filter(coefx, coefy, x1);
 
figure(2)
subplot(1,2,1)
stem(n,abs(y1),'.');
title('The magnitude of the output');
xlabel('n');
ylabel('|y1[n]|');
subplot(1,2,2)
stem(n,angle(y1),'.');
title('The phase of the output');
xlabel('n');
ylabel('phase of y1[n]');

% in order to compare with the output y1[n]
figure(3)
subplot(1,2,1)
stem(n,abs(x1),'.');
title('The magnitude of the input');
xlabel('n');
ylabel('|x1[n]|');
subplot(1,2,2)
stem(n,angle(x1),'.');
title('The phase of the input');
xlabel('n');
ylabel('phase of x1[n]');



%-----------------------------part e-------------------------------------%

w=-2:(0.001*(pi/3)):2;
H=(1+1/2.*exp(-1i.*w))./(1-1.8.*cos(pi/16).*exp(-1i.*w)+0.81.*exp(-2.*1i.*w));

% plot of the frequency response
figure(4)
subplot(1,2,1)
plot(w,abs(H));
title('The magnitude of the frequency response');
xlabel('w');
ylabel('|H(jw)|');
subplot(1,2,2)
plot(w,angle(H));
title('The phase of the frequency response');
xlabel('w');
ylabel('phase of H(jw)');

%-----------------------------part f-------------------------------------%

% Hss at w=pi/3
Hss=(1+1/2*exp(-1i*pi/3))/(1-1.8*cos(pi/16)*exp(-1i*pi/3)+0.81*exp(-2*1i*pi/3));

% eqn2 in the question
yss=Hss.*exp(1i.*(pi/3).*n);

yt=y1-yss; % transient response

% plotting the transient response in the range 0 to 30
figure(5)
subplot(1,2,1)
stem(n(11:41),abs(yt(11:41)),'.');
title('The magnitude of the transient response');
xlabel('n');
ylabel('|yt[n]|');
subplot(1,2,2)
stem(n(11:41),angle(yt(11:41)),'.');
title('The phase of the transient response');
xlabel('n');
ylabel('phase of yt[n]');
