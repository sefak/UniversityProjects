Fs = 14400; % Sampling Frequency, generally chosen as 14400
duration = 20; % Duaration of the sound file.
t = linspace(0, duration, duration*Fs); % Time Vector.
kf = 20;
fc = 500;
m = cos(2*pi*20*t);
phi = 2*pi*kf*cumsum(m)/Fs; % information carrying phase
s = cos(2*pi*fc*t+phi); % Signal.
s = s /max(abs(s)) ; %scale to the signal to fit between 1 and -1.
%sound(s, Fs); % Creating the sound file.
%audiowrite("y.wav", s, Fs);
figure(1)
plot(t,s)
hold on;
plot(t,m)
title("The modulated signal in time domain")
xlabel("Time (s)")
ylabel("Value") 
legend("modulated","message");
figure(2)
f = [-duration*Fs/2:duration*Fs/2-1]/duration;
plot(f,abs(fftshift(fft(s))))
title("The modulated signal in frequency domain")
xlabel("Frequency (Hz)")
ylabel("Value")
%% Generate a sinusoidal with a know frequency to determine the arduino sampling frequency  

sin50hz = sin(2*pi*50*t);
audiowrite("sin.wav", sin50hz, Fs);
plot(t,sin50hz)