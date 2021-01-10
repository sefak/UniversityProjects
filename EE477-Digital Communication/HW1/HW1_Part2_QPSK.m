% QPSK
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


