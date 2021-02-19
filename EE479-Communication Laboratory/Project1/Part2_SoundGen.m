Fs = 14400; % Sampling Frequency, generally chosen as 14400
duration = 20 ; % Duaration of the sound file.
t = linspace(0, duration, duration*Fs) ; % Time Vector.
A = 1.5;
fc = 500;
m = cos(2*pi*10*t);
s = (A+m).*cos(2*pi*fc*t); % Signal.
s = s /max(s) ; %scale to the signal to fit between 1 and 1.
%sound(s, Fs); % Creating the sound file.
audiowrite("y.wav", s, Fs);
figure(1)
plot(t,s)
title("The modulated signal")
xlabel("Time (s)")
ylabel("Value")

%% Generate a sinusoidal with a know frequency to determine the arduino sampling frequency  

sin500hz = sin(2*pi*500*t);
audiowrite("sin.wav", sin500hz, Fs);

%% Adding AWGN 

s_n1 = awgn(s,20,'measured');
audiowrite("y_n1.wav", s_n1, Fs);
figure(2)
plot(t,s_n1)
title("The modulated signal which has a 10^-^2 power AWGN")
xlabel("Time (s)")
ylabel("Value")

s_n2 = awgn(s,60, 'measured');
audiowrite("y_n2.wav", s_n2, Fs);
figure(3)
plot(t,s_n2)
title("The modulated signal which has a 10^-^6 power AWGN")
xlabel("Time (s)")
ylabel("Value")