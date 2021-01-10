
% Homework1 Question 2

M1 = 0; % lower limit of the moving average
M2 = 4; % upper limit of the moving average
c = M1+M2+1; % for easy of representation

w = -1*pi:0.01:pi; % frequency values to plot

% the frequency response of the given moving average found the the 1st part
H = (1/c).*((sin(w.*(c/2)))./sin(w./2)).*exp(i.*w.*(M1/2-M2/2));

Hmag = abs(H); % magnitude response

Hpha = angle(H); % phase response


% ploting the responses separately
figure(1)
plot(w./pi,Hmag);
title('The magnitude response of the moving average');
xlabel('w in pi scale');
ylabel('Hmag');

figure(2)
plot(w./pi,Hpha./pi);
title('The phase response of the moving average');
xlabel('w in pi scale');
ylabel('Hpha in pi scale');
