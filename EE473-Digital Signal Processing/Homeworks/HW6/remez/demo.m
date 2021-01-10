M = 23; % filter length that is found in the Kaiser filter
Kp = 5; % pass-band weight
Ks = 1; % stop-band weight
wp = 0.4*pi; % pass-band edge
ws = 0.6*pi; % stop-band edge
wo = (wp+ws)/2; % cut-off freq.
Gs = 1000; % grid size
w = [0:Gs]'*pi/Gs; % frequency
W = Kp*(w<=wp) + Ks*(w>=ws); % weight function
D = (w<=wo); % desired function

[h,del] = fircheb(M,D,W);