% 16-QAM
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
