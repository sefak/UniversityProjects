priorports=instrfind; % halihazirdaki acik portlari bulma
delete(priorports); % bu acik port lari kapama (yoksa hata verir)
s = serial('COM3'); % bilgisayarinizda hangi port olarak define edildiyse, 
% o portu girin . . COM1, COM2, vs . .

s.InputBufferSize = 10000; % serial protokolunden oturu , datayi bloklar halinde
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
Fs=8910; % In the part 5, the sampling frequency of arduino is found 8910Hz

figure(2)
plot([1:10000]/Fs,data);
title("The received signal")
xlabel("Time (s)")
ylabel("Value")
%% mapping the data into [-1 1] range

data = data - 126; % The added DC value by the DC biasing circuit is 122
data = data/60; % mapping the data into [-1 1]
plot(data)
%% Demodulation with the envelope detector method given in the Simulink part

Fpass = 15; 

data_squared = data.*data;
%plot(abs(fftshift(fft(data_squared))))

data_lowpassed = lowpass(data_squared, Fpass, Fs, 'Steepness',0.95);
%plot(abs(fftshift(fft(data_lowpassed))))

data_demodulated = data_lowpassed - 0.26; % removing Dc component
%plot(abs(fftshift(fft(data_demodulated))))

data_demodulated = 4.25*data_demodulated; % scaling into [-1 1] range

%% PLoting the result
figure
t = linspace(1/Fs,1,Fs);
m = cos(2*pi*10*t);
subplot(211)
plot(t,data_demodulated(Fs/10+1:1.1*Fs)); % a 1 sec interval is plotted
title("The demodulated signal")
xlabel("Time (s)")
ylabel("Value")
subplot(212)
plot(t,m)
title("The sent signal")
xlabel("Time (s)")
ylabel("Value")

mean_sq_err = sum((m-data_demodulated(Fs/10+1:1.1*Fs)').^2)/Fs;


