%-----------------------------part a--------------------------------------%
[b,a] = ellip(4,.2,40,[.41 .47]);
[r,p,k]=residue(fliplr(b),fliplr(a)); % reverse order is given to residue


ap = zeros(length(r)/2,3);
bp = zeros(length(r)/2,3);
for n=1:length(r)/2
    if(n==1)
        [bp(n,:),ap(n,:)] = residue(r(2*n-1:2*n),p(2*n-1:2*n),k);
    else
        [bp(n,[2 3]),ap(n,:)] = residue(r(2*n-1:2*n),p(2*n-1:2*n),0);
        bp(n,1) = 0;
    end
    bp(n,:) = fliplr(real(bp(n,:))); % order is reversed
    bp(n,:) = bp(n,:)./ap(n,3);      % normalized in a way that the first ap is 1
    ap(n,:) = fliplr(real(ap(n,:))); % order is reversed
    ap(n,:) = ap(n,:)./ap(n,1);      % normalized in a way that the first ap is 1
    
end

%-----------------------------part b--------------------------------------%

hp = zeros(1,4096);
% impulse responses of the parallel subsections are added.
for n=1:size(ap,1)
    hp = hp + filter(bp(n,:),ap(n,:),[1 zeros(1,4095)]);
end

figure(1)
stem(hp(1:200),'.');
xlabel('n');
ylabel('h[n]');
title('The impulse response of the paralleled version of the given bandpass filter');

max_diff1 = max(hp-filter(b,a,[1 zeros(1,4095)]));

%-----------------------------part c--------------------------------------%

apq16 = zeros(size(bp, 1),size(bp, 2));
bpq16 = zeros(size(bp, 1),size(bp, 2));

rq16=[];
pq16=[];
kq16=[];
for n = 1:size(bp, 1)
    M = max(abs([bp(n,:) ap(n,:)]));
    apq16(n,:) = quant(ap(n,:),16,M);
    bpq16(n,:) = quant(bp(n,:),16,M);
    
    [rtemp,ptemp,ktemp]=residue(fliplr(bpq16(n,:)),fliplr(apq16(n,:)));
    
    rq16 = [rq16; rtemp];
    pq16 = [pq16; ptemp];
    kq16 = [kq16; ktemp];
end

% the same method used above
[bp16, ap16] = residue(rq16,pq16,kq16);
bp16 = fliplr(real(bp16)); bp16 = bp16./ap16(end);
ap16 = fliplr(real(ap16)); ap16 = ap16./ap16(1);


%-----------------------------part d--------------------------------------%

hp16 = zeros(1,4096);
for n=1:size(apq16,1)
    hp16 = hp16 + filter(bpq16(n,:),apq16(n,:),[1 zeros(1,4095)]);
end

[H,w]=freqz(hp16,1,4096);

figure(2);
subplot(1,2,1)
plot(w/pi,20*log10(abs(H)));
axis([0 1 -80 10]);
xlabel('w (pi)');
ylabel('|H| (dB)');
title('The magnitude response of the 16 bits quantized paralleled version of the bandpass filter');
grid on;

[H,w]=freqz(bp16,ap16,4096);
subplot(1,2,2)
plot(w/pi,20*log10(abs(H)));
axis([0 1 -80 10]);
xlabel('w (pi)');
ylabel('|H| (dB)');
title('The magnitude response of the paralleled version of the bandpass filter with difference equation');
grid on;


%-----------------------------part e--------------------------------------%

figure(3);
dpzplot(bp16,ap16);
xlabel('Re');
ylabel('Im');
title('Poles and zeros of the paralleled filter');

%-----------------------------part f--------------------------------------%

apq12 = zeros(size(bp, 1),size(bp, 2));
bpq12 = zeros(size(bp, 1),size(bp, 2));

rq12=[];
pq12=[];
kq12=[];
for n = 1:size(bp, 1)
    M = max(abs([bp(n,:) ap(n,:)]));
    apq12(n,:) = quant(ap(n,:),12,M);
    bpq12(n,:) = quant(bp(n,:),12,M);
    
    [rtemp,ptemp,ktemp]=residue(fliplr(bpq12(n,:)),fliplr(apq12(n,:)));
    
    rq12 = [rq12; rtemp];
    pq12 = [pq12; ptemp];
    kq12 = [kq12; ktemp];
end

% the same method used above
[bp12, ap12] = residue(rq12,pq12,kq12);
bp12 = fliplr(real(bp12)); bp12 = bp12./ap12(end);
ap12 = fliplr(real(ap12)); ap12 = ap12./ap12(1);


hp12 = zeros(1,4096);
for n=1:size(apq12,1)
    hp12 = hp12 + filter(bpq12(n,:),apq12(n,:),[1 zeros(1,4095)]);
end

[H,w]=freqz(hp12,1,4096);

figure(4);
subplot(1,2,1)
plot(w/pi,20*log10(abs(H)));
axis([0 1 -60 10]);
xlabel('w (pi)');
ylabel('|H| (dB)');
title('The magnitude response of the 12 bits quantized paralleled version of the bandpass filter');
grid on;

[H,w]=freqz(bp12,ap12,4096);
subplot(1,2,2)
plot(w/pi,20*log10(abs(H)));
axis([0 1 -60 10]);
xlabel('w (pi)');
ylabel('|H| (dB)');
title('The magnitude response of the paralleled version of the bandpass filter with difference equation');
grid on;


figure(5);
dpzplot(bp12,ap12);
xlabel('Re');
ylabel('Im');
title('Poles and zeros of the paralleled filter');