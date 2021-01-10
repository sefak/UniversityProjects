load('lineup.mat');
% to hear the sound of the original record, uncomment the following 

% sound(y);

%-----------------------------part b--------------------------------------%
N = 1000;
a = 0.5;
n = 0:1000;

coefx = [1 zeros(1, N-1) a];
coefy = 1;

hn = filter(coefx, coefy, [1 zeros(1, 1e5)]); % input is given as unit impulse

figure(1);
stem(n, hn(1:length(n)),'*');
title('The impulse response of the given echo system');
xlabel('n');
ylabel('h[n]');

%-----------------------------part e--------------------------------------%

coefz = [1 zeros(1, N-1) a];

output = filter(coefy, coefz, y); 

figure(2);
stem(output,'.');
title('The output of the given removal echo system');
xlabel('n');
ylabel('output[n]');

% to compare the resulting sound with the original, uncomment the following 

% sound(output);

%-----------------------------part f--------------------------------------%

hin = filter(coefy, coefz, [1 zeros(1, 1e5)]); % input is given as unit impulse
halln = conv(hn, hin);

figure(3);
stem(hin,'.');
title('The impulse response of the inserve system'); 
xlabel('n');
ylabel('hin[n]');

figure(4);
stem(halln,'*');
title('The impulse response of the overall system'); 
xlabel('n');
ylabel('hall[n]');
