%  BPSK
clear;
s = [1 0 1 1 1 1 0 0];
s_4ary = [10 11 11 00]; 
s_16ary = [1011 1100];
fc = 5;
t = 0:0.001:0.999; % the time unit is 1 msec


% since it's binary, there are only 2 phases to be consired
theta = [0, pi]; 

% determining the constellation diagram

% sin(2pi*fc*t) coefficients are 0 for both s=0 and s=1, so no need to
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
