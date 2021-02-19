priorports=instrfind; % halihazirdaki acik portlari bulma
delete(priorports); % bu acik port lari kapama (yoksa hata verir)
s = serial('COM3'); % bilgisayarinizda hangi port olarak define edildiyse, 
% o portu girin . . COM1, COM2, vs . .
buffersize = 1000;

s.InputBufferSize = buffersize; % serial protokolunden oturu , datayi bloklar halinde
% almaniz gerekiyor. kacar bytelik bloklar halinde almak istiyorsaniz, onu girin
set(s, 'BaudRate', 115200) ; % arduino da set ettigimiz hiz ile ayni olmali
fopen(s) ; % COM portunu acma

Fs = 8891;
bitTime = 100;
threshold = 40;

count = 0;
time0 = tic;
while toc(time0) < 1% 5 sn ye boyunca data al  
    data = fread(s);
    transformedData = (data>threshold);
    
end
fclose(s); % Serial port u kapatmak

plot([1:buffersize]/Fs, data); hold on;
ylabel("Voltage");
xlabel("Time (s)");
yyaxis right;
plot([1:buffersize]/Fs, transformedData)
ylabel("Corresponding Digital Value");
%%
temp = 42;
bit = [];
for i = 1:8
    if mod(temp,2)==1
       bit=[bit,1]; 
    else
       bit=[bit,0];
    end
    temp=temp/2;
end
bi2de(bit)


