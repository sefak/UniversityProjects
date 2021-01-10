% 4-PAM
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



