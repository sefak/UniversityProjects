%%  BPSK
clear;
s = [1 0 1 1 1 1 0 0];
s_4ary = [10 11 11 00]; 
s_16ary = [1011 1100];
fc = 5;
t = 0:0.001:0.999; % the time unit is 1 msec



% since it's binary, there are only 2 phases to be consired
theta = [0, pi]; 

% determining the constellation diagram

% sin(2pi*fc*t) coefficients are 0 for both s=0 and s=1, so no need toz
% represent
cons = zeros(1,length(theta));
scons = zeros(1,size(t,1)*length(t));
leg = strings;
bits = ["0", "1"];
for n=1:length(theta)
    figure(1);
    % average energy of BPSK is Eg/2 so it should be multiplied with sqrt(2)
    cons(n)=cos(theta(n))*sqrt(2);
    % representing the constellation diagram
    scatter(cons(n), 0, '*');hold on;
    
    % representing the sine waveforms
    scons(int16((t).*length(t))+1) = cons(n).*cos(2.*pi.*fc.*(t));
    figure(2);
    plot((t+n-1),scons); hold on;
    
    leg(n) =(sprintf('The %d. symbol(s=%s) in BPSK',n,bits(n)));
end
figure(1);
xlabel('cos(2*pi*fc*t)');
ylabel('sin(2*pi*fc*t)');
title('The constellation diagram of the symbols in BPSK');
legend(leg);
figure(2);
xlabel('t in sec');
ylabel('waveform of the symbols');
title('The waveform representation of the symbols in BPSK');
legend(leg);


% The modulated pulse stream of the given bit stream
cons= [];
% average energy of BPSK is Eg/2 so it should be multiplied with sqrt(2)
cons(s==0) = cos(theta(1));
cons(s==1) = cos(theta(2));
cons = cons.*sqrt(2);

st = zeros(1,size(cons,1)*length(t));
for n=1:length(s)
    st(int16((n+t-1).*length(t))+1) = cons(n).*cos(2.*pi.*fc.*(n-1+t));
end

figure(3);
plot(st);
xlabel('t in msec');
ylabel('waveform of the symbols');
title('The waveform representation of the symbols in the given bit stream');

%% QPSK
clear;
s = [1 0 1 1 1 1 0 0];
s_4ary = [10 11 11 00]; 
s_16ary = [1011 1100];
fc = 5;
t = 0:0.001:0.999; % the time unit is 1 msec

% since it's quadrature, there are 4 phases to be consired
theta = [0, pi/2, pi, 3/2*pi]; 

% determining the constellation diagram

% since in matlab pi is not exact, it is truncated at some point; so it is
% converted to sym and the result is converted back to double to get exact
% result

cons = zeros(length(theta),2);
scons = zeros(1,size(t,1)*length(t));
leg = strings;
bits = ["00", "01", "10", "11"];
for n=1:length(theta)
    figure(1);
    % average energy of QPSK is Eg/2 so it should be multiplied with sqrt(2)
    cons(n,1) = double(cos(sym(theta(n))))*sqrt(2); 
    cons(n,2) = double(sin(sym(theta(n))))*sqrt(2);
    % representing the constellation diagram
    scatter(cons(n,1),cons(n,2), '*');hold on;
    
    % representing the sine waveforms
    scons(int16((t).*length(t))+1) = cons(n,1)*cos(2.*pi.*fc.*(t)) ...
                                     -cons(n,2)*sin(2.*pi.*fc.*(t));
    figure(2);
    plot((t+n-1),scons); hold on;
    
    leg(n) =(sprintf('The %d. symbol(s=%s)',n,bits(n)));
end
figure(1);
xlabel('cos(2*pi*fc*t)');
ylabel('sin(2*pi*fc*t)');
title('The constellation diagram of the symbols in QPSK');
legend(leg);
figure(2);
xlabel('t in sec');
ylabel('waveform of the symbols');
title('The waveform representation of the symbols in QPSK');
legend(leg);
 



% The modulated pulse stream of the given bit stream
cons =[];
% average energy of QPSK is Eg/2 so it should be multiplied with sqrt(2)
cons(s_4ary==00,1) = double(cos(sym(theta(1)))); 
cons(s_4ary==00,2) = double(sin(sym(theta(1))));
cons(s_4ary==01,1) = double(cos(sym(theta(2))));
cons(s_4ary==01,2) = double(sin(sym(theta(2))));
cons(s_4ary==10,1) = double(cos(sym(theta(3)))); 
cons(s_4ary==10,2) = double(sin(sym(theta(3))));
cons(s_4ary==11,1) = double(cos(sym(theta(4)))); 
cons(s_4ary==11,2) = double(sin(sym(theta(4))));
cons = cons.*sqrt(2);

st = zeros(1,size(cons,1)*length(t));
for n=1:length(s_4ary)
    st(int16((n+t-1).*length(t))+1) = cons(n,1).*cos(2.*pi.*fc.*(n-1+t)) ...
                                     -cons(n,2).*sin(2.*pi.*fc.*(n-1+t));
end

figure(3);
plot(st);
xlabel('t in msec');
ylabel('waveform of the symbols');
title('The waveform representation of the symbols in the given bit stream');

%% 4-PAM
clear;
s = [1 0 1 1 1 1 0 0];
s_4ary = [10 11 11 00]; 
s_16ary = [1011 1100];
fc = 5;
t = 0:0.001:0.999; % the time unit is 1 msec


% since it's quadrature, there are 4 amplitude to be consired
% delta is taken as 1
amp = [-3 -1 1 3];

% determining the constellation diagram

cons = zeros(length(amp),1);
scons = zeros(1,size(t,1)*length(t));
leg = strings;
bits = ["00", "01", "10", "11"];
for n=1:length(amp)
    figure(1);
    % average energy of 4-PAM is (Eg/2)*5delta^2 and so it is normalized with sqrt(5delta^2/2)
    cons(n) = amp(n)/sqrt(5/2);
    % representing the constellation diagram
    scatter(cons(n,1),0, '*');hold on;
    
    % representing the sine waveforms
    scons(int16((t).*length(t))+1) = cons(n).*cos(2.*pi.*fc.*(t));
    figure(2);
    plot((t+n-1),scons); hold on;
    
    leg(n) =(sprintf('The %d. symbol(s=%s)',n,bits(n)));
end
figure(1);
xlabel('amp');
ylabel(' ');
title('The constellation diagram of the symbols in 4-PAM');
legend(leg);
figure(2);
xlabel('t in sec');
ylabel('waveform of the symbols');
title('The waveform representation of the symbols in 4-PAM');
legend(leg);



% The modulated pulse stream of the given bit stream
cons = [];
% average energy of 4-PAM is (Eg/2)*5delta^2 and so it is normalized with sqrt(5delta^2/2)
cons(s_4ary==00) = amp(1);
cons(s_4ary==01) = amp(2);
cons(s_4ary==10) = amp(3);
cons(s_4ary==11) = amp(4);
cons = cons./sqrt(5/2);

st = zeros(1,size(cons,1)*length(t));
for n=1:length(s_4ary)
    st(int16((n+t-1).*length(t))+1) = cons(n).*cos(2.*pi.*fc.*(n-1+t));                                
end

figure(3);
plot(st);
xlabel('t in msec');
ylabel('waveform of the symbols');
title('The waveform representation of the symbols in the given bit stream');


%% 16-QAM
clear;
s = [1 0 1 1 1 1 0 0];
s_4ary = [10 11 11 00]; 
s_16ary = [1011 1100];
fc = 5;
t = 0:0.001:0.999; % the time unit is 1 msec


% since the rectangular 16-QAM is used to modulate, there are 4 amp values 
% in horizontal axis, 4 amp values in vertical axis  
% delta is taken as 1
ampA = [-3 -1 1 3];
ampB = [-3 -1 1 3];

% determining the constellation diagram

cons = zeros(length(ampA)*length(ampB),2);
scons = zeros(1,size(t,1)*length(t));
leg = strings;
bits = ["0000", "0001", "0010", "0011", "0100", "0101", "0110", "0111", ...
    "1000", "1001", "1010", "1011", "1100", "1101", "1110", "1111"];
n=1;
for k=1:length(ampB)
    for l=1:length(ampA)
        figure(1);
        % average energy of 16-PAM is (Eg/2)*10delta^2 and so it is normalized with sqrt(5delta^2) 
        cons(n,1) = ampA(l)/sqrt(5); 
        cons(n,2) = ampB(k)/sqrt(5);
        % representing the constellation diagram
        scatter(cons(n,1),cons(n,2), '*');hold on;

        % representing the sine waveforms
        scons(int16((t).*length(t))+1) = cons(n,1).*cos(2.*pi.*fc.*(t)) ...
                                         -cons(n,2).*sin(2.*pi.*fc.*(t));
        figure(2);
        plot((t+n-1),scons); hold on;

        leg(n) =(sprintf('%d.sy(s=%s)',n,bits(n)));
        
        n=n+1;
    end
end
figure(1);
xlabel('ampA');
ylabel('ampB');
title('The constellation diagram of the symbols in 16QAM');
legend(leg);
figure(2);
xlabel('t in sec');
ylabel('waveform of the symbols');
title('The waveform representation of the symbols in 16QAM');
legend(leg);
 

% The modulated pulse stream of the given bit stream
cons = [];
% average energy of 16-PAM is (Eg/2)*10delta^2 and so it is normalized with sqrt(5delta^2) 
cons(s_16ary==0000,1) = ampA(1); cons(s_16ary==0000,2) = ampB(1);
cons(s_16ary==0001,1) = ampA(2); cons(s_16ary==0001,2) = ampB(1);
cons(s_16ary==0010,1) = ampA(3); cons(s_16ary==0010,2) = ampB(1);
cons(s_16ary==0011,1) = ampA(4); cons(s_16ary==0011,2) = ampB(1);
cons(s_16ary==0100,1) = ampA(1); cons(s_16ary==0100,2) = ampB(2);
cons(s_16ary==0101,1) = ampA(2); cons(s_16ary==0101,2) = ampB(2);
cons(s_16ary==0110,1) = ampA(3); cons(s_16ary==0110,2) = ampB(2);
cons(s_16ary==0111,1) = ampA(4); cons(s_16ary==0111,2) = ampB(2);
cons(s_16ary==1000,1) = ampA(1); cons(s_16ary==1000,2) = ampB(3);
cons(s_16ary==1001,1) = ampA(2); cons(s_16ary==1001,2) = ampB(3);
cons(s_16ary==1010,1) = ampA(3); cons(s_16ary==1010,2) = ampB(3);
cons(s_16ary==1011,1) = ampA(4); cons(s_16ary==1011,2) = ampB(3);
cons(s_16ary==1100,1) = ampA(1); cons(s_16ary==1100,2) = ampB(4);
cons(s_16ary==1101,1) = ampA(2); cons(s_16ary==1101,2) = ampB(4);
cons(s_16ary==1110,1) = ampA(3); cons(s_16ary==1110,2) = ampB(4);
cons(s_16ary==1111,1) = ampA(4); cons(s_16ary==1111,2) = ampB(4);
cons = cons./sqrt(5);

st = zeros(1,size(cons,1)*length(t));
for n=1:length(s_16ary)
    st(int16((n+t-1).*length(t))+1) = cons(n,1).*cos(2.*pi.*fc.*(n-1+t)) ...
                                     -cons(n,2).*sin(2.*pi.*fc.*(n-1+t));                                
end

figure(3);
plot(st);
xlabel('t in msec');
ylabel('waveform of the symbols');
title('The waveform representation of the symbols in the given bit stream');

%% Binary FSK
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

