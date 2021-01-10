% Binary FSK
clear;
s = [1 0 1 1 1 1 0 0];
s_4ary = [10 11 11 00]; 
s_16ary = [1011 1100];
fc = 5;
t = 0:0.001:0.999; % the time unit is 1 msec


% since it's binary, there is only 2 freqeuncies to be shifted. fmin is
% equal to 1/2T so it is 1/2; however to make the freqeuncy change more 
% visible, it is selected as 10*1/2T = 5 
freq = [0 1].*(10/2);

% determining the constellation diagram

cons = zeros(1,length(freq));
scons = zeros(1,size(t,1)*length(t));
leg = strings;
bits = ["0", "1"];
for n=1:length(freq)
    figure(1);
    % average energy of BFSK is Eg/2 so it should be multiplied with sqrt(2)
    cons(n)=freq(n);
    % representing the constellation diagram
    if n==1
        scatter(1, 0, '*');hold on; % 1st symbol uses freq(1)
    else
        scatter(0, 1, '*');hold on; % 2nd symbol uses freq(2)
    end
    % representing the sine waveforms
    scons(int16((t).*length(t))+1) = sqrt(2).*cos(2.*pi.*(fc+cons(n)).*(t));
    figure(2);
    plot((t+n-1),scons); hold on;
    
    leg(n) =(sprintf('The %d. symbol(s=%s) in BFSK',n,bits(n)));
end
figure(1);
xlabel('cos(2*pi*fc*t)');
ylabel('cos(2*pi*(fc+5)*t)');
title('The constellation diagram of the symbols in BFSK');
legend(leg);
figure(2);
xlabel('t in sec');
ylabel('waveform of the symbols');
title('The waveform representation of the symbols in BFSK');
legend(leg);



% The modulated pulse stream of the given bit stream
cons= [];
% average energy of BFSK is Eg/2 so it should be multiplied with sqrt(2)
cons(s==0) = freq(1);
cons(s==1) = freq(2);

st = zeros(1,size(cons,1)*length(t));
for n=1:length(s)
    st(int16((n+t-1).*length(t))+1) = sqrt(2).*cos(2.*pi.*(fc+cons(n)).*(n-1+t));
end

figure(3);
plot(st);
xlabel('t in msec');
ylabel('waveform of the symbols');
title('The waveform representation of the symbols in the given bit stream');