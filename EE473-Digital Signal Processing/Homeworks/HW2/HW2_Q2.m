t = -5:0.01:5;
n = -5:5;

omega = [0 pi/2 pi 3/2*pi 2*pi];

cos_cont = zeros(length(omega), length(t));
cos_disc = zeros(length(omega), length(n));
for i=1:length(omega)
    cos_cont(i,:) = cos(omega(i).*t);

    cos_disc(i,:) = cos(omega(i).*n);
    
    figure(i);
    subplot(1,2,1);
    plot(t,cos_cont(i,:)); 
    xlabel('t');
    ylabel('cos(omega*t)');
    title(sprintf('cos(%.1fpi*t) vs t',omega(i)/pi));

    subplot(1,2,2);
    stem(n,cos_disc(i,:),'.');
    xlabel('n');
    ylabel('cos[omega*n]');
    title(sprintf('cos[%.1fpi*n] vs n',omega(i)/pi));
    
end
