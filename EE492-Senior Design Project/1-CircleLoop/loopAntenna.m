f = 2.4e9;
r = 3e8/f/2/pi*1.089; 
w = 2*pi*r/exp(1)^4;

lc = loopCircular("Radius", r, "Thickness", w);

%lc.Load.Impedance=360*1i;
freq1 = linspace(2e9,5e9,11);

figure(1); show(lc);
figure(2); impedance(lc,freq1);
%figure(3); rfplot(sparameters(lc,freq1));
%figure(4); returnLoss(lc,freq1);
%%
[efield,az,el] = pattern(lc, 2.41e9,'Type','efield');
phi = az'; theta = (90-el); MagE = efield';
figure(5); patternCustom(MagE,theta,phi);
