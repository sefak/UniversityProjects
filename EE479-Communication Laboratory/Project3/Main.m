port_name = 'COM3';
buffer_size = 1000;
Fs = 8872;
duration = 100; % how many seconds to run
receive_decode_display_DTMF(port_name,buffer_size, Fs, duration);
