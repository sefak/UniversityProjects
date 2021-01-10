function y = diffeqn(a,x,yn1)
%diffeqn HW0 Q2.

y = zeros(1, length(x));
y(1) = a*yn1+x(1);

for n = 2:length(x)
    y(n) = a*y(n-1)+x(n);
end
end

