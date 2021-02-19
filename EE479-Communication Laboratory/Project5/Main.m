port_name = 'COM3';
buffer_size = 1000;
Fs = 8891;
bitTime = 4; % milisecond 
threshold = 40;
method = 'on-off'; 
%method = 'Manchester';
duration = 100; % how many seconds to run

decode_ASCII(port_name,buffer_size,Fs,bitTime/1e3,threshold,method,duration);