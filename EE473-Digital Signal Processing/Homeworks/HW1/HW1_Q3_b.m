a = [1 0.5 0]; 
b = [1 -1.8*cos(pi/16) 0.81];

[r, p] = residuez(a,b);

n=0:100;

h = 2.*abs(r(1)).*(abs(p(1)).^n).*cos(angle(p(1)).*n+angle(r(1)));

stem(n,h, '.');
title('The impulse response of the given difference equation');
xlabel('n');
ylabel('h[n]');