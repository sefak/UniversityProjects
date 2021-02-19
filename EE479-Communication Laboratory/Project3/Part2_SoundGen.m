Fs = 14400; % Sampling Frequency, generally chosen as 14400
duration = 20; % Duaration of the sound file.
t = linspace(0, duration, duration*Fs); % Time Vector.

a = [852 1477];

sin8 = (sin(2*pi*a(1)*t)+sin(2*pi*a(2)*t))/2;
audiowrite("sin.wav", sin8, Fs);
plot(t,sin8)