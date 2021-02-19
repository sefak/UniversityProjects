function [] = receive_decode_display_DTMF(port_name,buffer_size, Fs, duration)
%receive_decode_DTMF Summary of this function goes here
%   Detailed explanation goes here

priorports=instrfind; % halihazirdaki acik portlari bulma
delete(priorports); % bu acik port lari kapama (yoksa hata verir)
s = serial(port_name); % bilgisayarinizda hangi port olarak define edildiyse, 
% o portu girin . . COM1, COM2, vs . .

s.InputBufferSize = buffer_size; % serial protokolunden oturu , datayi bloklar halinde
% almaniz gerekiyor. kacar bytelik bloklar halinde almak istiyorsaniz, onu girin
set(s, 'BaudRate', 115200) ; % arduino da set ettigimiz hiz ile ayni olmali
fopen(s) ; % COM portunu acma


output = nan;
time0 = tic;
while toc(time0) < duration
    temp_output = output;
    data = fread(s);
    output = decode_DTMF(data-125,Fs);
    print_output(temp_output, output);
end
fclose(s); % Serial port u kapatmak
fprintf('\n Time of %d seconds is up. \n', duration);
end

