priorports=instrfind; % halihazirdaki acik portlari bulma
delete(priorports); % bu acik port lari kapama (yoksa hata verir)
s = serial('COM3'); % bilgisayarinizda hangi port olarak define edildiyse, 
% o portu girin . . COM1, COM2, vs . .

s.InputBufferSize = 15000; % serial protokolunden oturu , datayi bloklar halinde
% almaniz gerekiyor. kacar bytelik bloklar halinde almak istiyorsaniz, onu girin
set(s, 'BaudRate', 115200) ; % arduino da set ettigimiz hiz ile ayni olmali
fopen(s) ; % COM portunu acma

time0 = tic;
figure(1);
while toc(time0) < 5 % 5 sn ye boyunca data al  
    data = fread(s);
    drawnow;
    plot(data)
% datayi bloklar halinde alma. bu islemi yaptiginzda 0 ile 255 arasi
% degerlericeren , yukarida InputBufferSize i kac olarak
% belirlediyseniz o boyutta bir vektorunuz olacaktir .
end
fclose(s); % Serial port u kapatmak

%% Plot received signal (the last 10000 samples of the input signal)
Fs=8872; % In the part 6, the sampling frequency of arduino is found 8872Hz

figure(2)
plot([1:15000]/Fs,data);
title("The received signal")
xlabel("Time (s)")
ylabel("Value")
%% Removing the added DC bias
data = data - 126; % The added DC value by the DC biasing circuit is 126

%% Taking the derivative to obtain the message signal as in the magnitude
der=diff(data);
figure(3)
plot([1:14999]/Fs,der)
title("The derivative of the received signal")
xlabel("Time (s)")
ylabel("Value")
%% Demodulation with the envelope detector method given in the Simulink part

Fpass = 30; 

data_squared = der.*der;
%plot(abs(fftshift(fft(data_squared))))

data_lowpassed = lowpass(data_squared, Fpass, Fs, 'Steepness',0.95);
%plot(abs(fftshift(fft(data_lowpassed))))

%% Synchronization of the demodulated signal
data_demodulated = data_lowpassed(1420:1420+Fs-1) - mean(data_lowpassed(1420:1420+Fs-1)); % removing Dc component
%plot(abs(fftshift(fft(data_demodulated))))

data_demodulated = data_demodulated/30.9; % scaling into [-1 1] range

%% PLoting the result
figure(4)
t = linspace(1/Fs,1,Fs);
m = cos(2*pi*20*t);
subplot(211)
plot(t,data_demodulated); % a 1 sec interval is plotted
title("The demodulated signal")
xlabel("Time (s)")
ylabel("Value")
subplot(212)
plot(t,m)
title("The sent signal")
xlabel("Time (s)")
ylabel("Value")

mean_sq_err = sum((m-data_demodulated').^2)/Fs;


