function [output] = decode_DTMF(data,Fs)
%decode_DTMF Summary of this function goes here
%   Detailed explanation goes here
output = nan;

bs = length(data);
low_freq = [650 730 810 900 980];
high_freq = [1130 1270 1410 1550 1690];
temp_l = ['1','2','3','A';'4','5','6','B';'7','8','9','C';'*','0','#','D'];   

for i=1:4
    [b, a] = butter(6, low_freq(i:i+1)/(Fs/2));
    if sum(abs(filter(b, a, data)))/bs>1
        temp_h = temp_l(i,:);
        break
    end
end

for i=1:4
    [b, a] = butter(6, high_freq(i:i+1)/(Fs/2));
    if sum(abs(filter(b, a, data)))/bs>2
        output = temp_h(i);
        break
    end
end

end

