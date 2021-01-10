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

SN = 1e-8; % small number for stopping criteria, etc
L = (M-1)/2;
R = L + 2; % R = size of reference set

% initialize reference set (approx equally spaced where W>0)
f = find(W>SN);
k = f(round(linspace(1,length(f),R)));
m = 0:L;
s = (-1).^(1:R)'; % signs

while 1
% --------------- Solve Interpolation Problem ---------------------
    x = [cos(w(k)*m), s./W(k)] \ D(k);
    a = x(1:L+1); % cosine coefficients
    del = x(L+2); % delta
    h = [a(L+1:-1:2); 2*a(1); a(2:L+1)]/2;
    H = fft(h,2*Gs);          
    wH = ([0:2*Gs-1]*(2*pi/(2*Gs)))';
    A = exp(L*1j*wH).*H;  % amplitude of the frequency response
    A = real(A(1:Gs+1));  % 0-pi part is considered and, ignores zero imaginary part 
    err = (A-D).*W; % weighted error
% --------------- Update Reference Set ----------------------------
    [~,newk1] = findpeaks(err); [~,newk2] = findpeaks(-err);
    newk = [1; sort([newk1; newk2]); 1001]; % 0 and pi are also starting and ending of the frequency
    errk = (A(newk)-D(newk)).*W(newk);
    
    % remove frequencies where the weighted error is less than delta
    v = abs(errk) >= (abs(del)-SN);
    newk = newk(v);
    errk = errk(v);
    
    % -- In our case, no need to check alternation, since in all iterations
    % -- it is checked that 'newk' are alternating.
    % ensure the alternation property  
    % v = etap(errk);
    % newk = newk(v);
    % errk = errk(v);

    % if newk is too large, remove points until size is correct
    while length(newk) > R
        if abs(errk(1)) < abs(errk(length(newk)))
            newk(1) = [];
        else
            newk(length(newk)) = [];
        end
    end

% --------------- Check Convergence -------------------------------
    if (max(errk)-abs(del))/abs(del) < SN
        disp('The algorithm has been converged.')
    break
    end
    k = newk;
end
del = abs(del)
h = [a(L+1:-1:2); 2*a(1); a(2:L+1)]/2;


[H, w]=freqz(h,1,4096);
A = real(exp(L*1j*w).*H); % Amplitude of the frequency response, ignores zero imaginary part 

figure(1);
subplot(1,2,1)
plot(w/pi,20*log10(abs(H)));
axis([0 1 -100 10]);
xlabel('w (pi)');
ylabel('|H| (dB)');
title('The magnitude of the frequency response of the Parks-McClellan filter');
grid on;

subplot(1,2,2)
plot(w/pi,unwrap(angle(H))/pi);
%axis([0 1 -1.5 0.5]);
xlabel('w (pi)');
ylabel('angle(H) (pi)');
title('The phase of the frequency response of the Parks-McClellan filter');
grid on;

figure(2);
plot(w/pi,A);
axis([0 1 min(A) max(A)]);
xlabel('w (pi)');
ylabel('amp(H)');
title('The amplitude of the frequency response of the Parks-McClellan filter');
axis square;
grid on;

figure(3);
subplot(2,1,1)
plot(w/pi,A);
axis([0 0.4 0.996 1.004]);
xlabel('w (pi)');
ylabel('amp(H)');
title('The ripples of the Parks-McClellan filter in the passband');
grid on;

subplot(2,1,2)
plot(w/pi,A);
axis([0.6 1 -0.02 0.02]);
xlabel('w (pi)');
ylabel('amp(H)');
title('The ripples of the Parks-McClellan filter in the stopband');
grid on;


