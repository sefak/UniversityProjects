priorports=instrfind; % halihazirdaki acik portlari bulma
delete(priorports); % bu acik port lari kapama (yoksa hata verir)
s = serial('COM3'); % bilgisayarinizda hangi port olarak define edildiyse, 
% o portu girin . . COM1, COM2, vs . .

s.InputBufferSize = 2000; % serial protokolunden oturu , datayi bloklar halinde
% almaniz gerekiyor. kacar bytelik bloklar halinde almak istiyorsaniz, onu girin
set(s, 'BaudRate', 115200) ; % arduino da set ettigimiz hiz ile ayni olmali
fopen(s) ; % COM portunu acma

Fs = 8872;

[d, c] = butter(6, [810 890]/(Fs/2));
[f, e] = butter(6, [1400 1550]/(Fs/2));
while 1 % 5 sn ye boyunca data al  
    data = fread(s)-125;
    
    drawnow;
    subplot(131);
    plot([1:2000]/Fs, data)
    subplot(132);
    plot([1:2000]/Fs, filter(d, c, data))
    subplot(133);
    plot([1:2000]/Fs, filter(f, e, data))
    disp([sum(abs(filter(d, c, data)))/2000, sum(abs(filter(f, e, data)))/2000])
end
fclose(s); % Serial port u kapatmak


