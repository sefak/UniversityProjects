function [A,w] = firamp_original(h,type,L)
% [A,w] = firamp(h,type,L)
% Amplitude response of a linear-phase FIR filters
% A : amplitude response
% w : frequency grid [0:L-1]*(2*pi/L)
% h : impulse response
% type : [1,2,3,4]
% L : frequency density (optional, default = 2^10)

h = h(:)';              % make h a row vector
N = length(h);          % length of h
if nargin < 3
   L = 2^10;            % grid size
end
H = fft(h,L);           % zero pad and fft
w = [0:L-1]*(2*pi/L);   % frequency grid
M = (N-1)/2;
if (type == 1)|(type == 2)
  H = exp(M*j*w).*H;    % Type I and II
else
  H = -1j*exp(M*1j*w).*H; % Type III and IV
end
A = real(H);            % discard zero imaginary part

