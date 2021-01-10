tb8=[zeros(4,1) [0 0;0 1; 1 0; 1 1]; ones(4,1) [0 0;0 1; 1 0; 1 1]];
tb16=[zeros(8,1) tb8; ones(8,1) tb8];
tb32 = [zeros(16,1) tb16; ones(16,1) tb16];
code_symbols = [-1 1];
temp = code_symbols(tb32+1);
fl = [0 0 0 0 0.74 -0.514 0.37 0.216 0.062]; % channel
dm = zeros(1,32);
rec_bits(1:5) = conv([1,-1,1,-1,-1], fl, 'same');
for n = 1:32
   temp_bits = conv(temp(n,:), fl, 'same');
   dm(n) = norm(temp_bits-rec_bits(1:5));
end
[rowmin, sym_ind]=min(dm,2);
detected_bits=temp(sym_ind,:);
