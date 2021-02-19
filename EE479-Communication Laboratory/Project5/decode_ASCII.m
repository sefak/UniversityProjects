function [] = decode_ASCII(port_name,buffer_size,Fs,bitTime,threshold,method,duration)
%decode_ASCII Summary of this function goes here
%   Detailed explanation goes here

priorports=instrfind; % halihazirdaki acik portlari bulma
delete(priorports); % bu acik port lari kapama (yoksa hata verir)
s = serial(port_name); % bilgisayarinizda hangi port olarak define edildiyse, 
% o portu girin . . COM1, COM2, vs . .

s.InputBufferSize = buffer_size; % serial protokolunden oturu , datayi bloklar halinde
% almaniz gerekiyor. kacar bytelik bloklar halinde almak istiyorsaniz, onu girin
set(s, 'BaudRate', 115200) ; % arduino da set ettigimiz hiz ile ayni olmali
fopen(s) ; % COM portunu acma

if isequal(method,'Manchester')
   bitTime=bitTime/2;
end

count = 0;
bits = [];
leapData = [];
isSync = 0;
isFinished = 0;
time0 = tic;
while (toc(time0) < duration) && ~isFinished
    data = fread(s);
    transformedData = [leapData; (data<threshold)]; % combining left over data as 0s and 1s
    
    temp = transformedData(1);
    for i = 1:length(transformedData)
       if transformedData(i)==temp
           count = count+1; 
       else
           numBit = round(count/Fs/bitTime);
           bits = [bits, temp*ones(1,numBit)];
           count = 0;
           temp = ~temp;
       end
       if all(transformedData(i:end)==0)||all(transformedData(i:end)==1)
           leapData = transformedData(i:end);
           break;
       end
    end
    
    if isequal(method,'Manchester')
        promptBits = bits(2:2:length(bits)); % converting Manchester decoding to ordinary signalling
    elseif isequal(method,'on-off')
        promptBits = bits; % copying the bits to be printed.
    else
        disp('Enter valid method!');
        break;
    end
    
    if isSync == 0
        for i = 1:length(promptBits)-15
            first = char(bi2de(promptBits(i:i+7)));
            second = char(bi2de(promptBits(i+8:i+15)));
            if isequal([first, second],['/', '*'])
                isSync = 1;
                startIndex = i+16;
            end
        end
    else
        for i = startIndex:8:length(promptBits)-9
            current = char(bi2de(promptBits(i:i+7)));
            if isequal(current,'`') % $
                isFinished = 1;
                fprintf('\nReception is completed. \n');
                break;
            end
            fprintf(current);
            startIndex=startIndex+8;
        end
    end
    
end
fclose(s); % Serial port u kapatmak
if ~isFinished
    fprintf('\nTime of %d seconds is up. \n', duration);
end
end

