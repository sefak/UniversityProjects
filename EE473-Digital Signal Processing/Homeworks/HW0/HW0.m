%% Q1.a) 

N = 12;
M = [4, 5, 7, 10];

n = 0:2*N-1;

xM = zeros(length(M), length(n));

% hold on;
for m = 1:length(M)
    xM(m,:) = sin(2*pi*M(m)*n/N);
    % stem(n,xM(m,:), '*');
    subplot(length(M)/2, length(M)/2, m);
    stem(n,xM(m,:),'*');
    title(sprintf('M = %d',M(m)));
    xlabel('n');
    ylabel('xM');
end


%% Q1.b)

k = [1, 2, 4, 6];
n = 1:9;

wk = 2*pi*k/5;

xk = zeros(length(k), length(n));

c = ['*','.','-','+']; 
hold on;
for m = 1:length(k)
    xk(m,:) = sin(wk(m)*n);
    stem(n,xk(m,:), c(m));
end
title('xks for k = 1, 2, 4, 6');
xlabel('n');
ylabel('xk');
legend(k);


%% Q1.c)

N1 = 12; 
n1 = 0:2*N1; 
y1 = cos(2*pi*n1/6) + 2*cos(3*pi*n1/6); 
subplot(1,3,1);
stem(n1,y1,'*');
title('y1');
xlabel('n');
ylabel('y1');


n2 = 0:24; 
y2 = 2*cos(2*n2/6) + cos(3*n2/6); 
subplot(1,3,2);
stem(n2,y2,'*');
title('y2');
xlabel('n');
ylabel('y2');


N3 = 24;
n3 = 0:2*N3; 
y3 = cos(2*pi*n3/6) + 3*sin(5*pi*n3/12); 
subplot(1,3,3);
stem(n3,y3,'*');
title('y3');
xlabel('n');
ylabel('y3');


%% Q2

n = 0:30; 

x1 = zeros(1, length(n));
x1(1) = 1;% 1st index corresponds to n=0
x2 = ones(1,length(n));  % 1st index corresponds to n=0

y1 = diffeqn(1, x1, 0);  % 1st index corresponds to n=0
y2 = diffeqn(1, x2, 0);  % 1st index corresponds to n=0

subplot(1,2,1);
stem(n,y1,'*');
title('y1');
xlabel('n');
ylabel('y1');

subplot(1,2,2);
stem(n,y2,'*');
title('y2');
xlabel('n');
ylabel('y2');


