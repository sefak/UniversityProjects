car = imread('car-interference.jpg');
astronau = imread('astronaut-interference.jpg');
astronaut = rgb2gray(astronau);

%% --------------------------Part a) car----------------------------------

F_car = fft2(car);
S_car = fftshift(log(1+abs(F_car)));

figure(1)
imshow(car);
title('The original car image');
figure(2)
imshow(S_car, []);
title('The car spectrum image');

%% --------------------------Part b) car----------------------------------
S_car_th = S_car <max(max(S_car))*0.77;

figure(3)
imshow(S_car_th);
title('The thresholded version of the car spectrum image');

%% --------------------------Part c) car----------------------------------
D0 = 11;
[Q_rows, Q_cols]=find(S_car_th==0);
center_row = Q_rows(int8(end/2));
% DC values are removed
Q_rows(Q_rows>center_row-10 & Q_rows<center_row+10) = [];
center_col = Q_cols(int8(end/2));
% DC values are removed
Q_cols(Q_cols>center_col-10 & Q_cols<center_col+10) = [];

[col, row] = meshgrid(1:size(car,2),1:size(car,1));

D_car = zeros(size(car,1),size(car,2), size(Q_cols,1));

for n=1:size(Q_cols,1)
   D_car(:,:,n)=sqrt((row-Q_rows(n)).^2+(col-Q_cols(n)).^2); 
end

H_car = 1 - exp(-D_car.^2./(2*D0*D0));

H_carNR = ones(size(car,1),size(car,2));
for n=1:size(H_car, 3)
    H_carNR = H_carNR.*H_car(:,:,n);
end

Y_car = (H_carNR).*(fftshift(F_car));
Filtered_car = real(ifft2(ifftshift(Y_car)));

N_car = (1-H_carNR).*(fftshift(F_car));
Filtered_car_n = real(ifft2(ifftshift(N_car)));

figure(4)
imshow(Filtered_car, []);
title('The filtered car image');
figure(5)
imshow(Filtered_car_n, []);
title('The car noise image');

%% -----------------------Part a) astronaut-------------------------------

F_astronaut = fft2(astronaut);
S_astronaut = fftshift(log(abs(F_astronaut)));

figure(6)
imshow(astronaut);
title('The original astronaut image');
figure(7)
imshow(S_astronaut, []);
title('The astronaut spectrum image');

%% -----------------------Part b) astronaut-------------------------------
S_astronaut_th = S_astronaut <max(max(S_astronaut))*0.92;

figure(8)
imshow(S_astronaut_th);
title('The thresholded version of the astronaut spectrum image');

%% -----------------------Part c) astronaut-------------------------------

D0 = 1;
[Q_rows, Q_cols]=find(S_astronaut_th==0);
center_row = Q_rows(int8(end/2));
% DC values are removed
Q_rows(Q_rows>center_row-5 & Q_rows<center_row+5) = [];
center_col = Q_cols(int8(end/2));
% DC values are removed
Q_cols(Q_cols>center_col-5 & Q_cols<center_col+5) = [];
[col, row] = meshgrid(1:size(astronaut,2),1:size(astronaut,1));

D_astronaut = zeros(size(astronaut,1),size(astronaut,2), size(Q_cols,1));

for n=1:size(Q_cols,1)
   D_astronaut(:,:,n)=sqrt((row-Q_rows(n)).^2+(col-Q_cols(n)).^2); 
end

H_astronaut = 1 - exp(-D_astronaut.^2./(2*D0*D0));

H_astronautNR = ones(size(astronaut,1),size(astronaut,2));
for n=1:size(H_astronaut, 3)
    H_astronautNR = H_astronautNR.*H_astronaut(:,:,n);
end

Y_astronaut = (H_astronautNR).*(fftshift(F_astronaut));
Filtered_astronaut = (ifft2(ifftshift(Y_astronaut)));

N_astronaut = (1-H_astronautNR).*(fftshift(F_astronaut));
Filtered_astronaut_n = (ifft2(ifftshift(N_astronaut)));


figure(9)
imshow(Filtered_astronaut, []);
title('The filtered astronaut image');
figure(10)
imshow(Filtered_astronaut_n, []);
title('The astronaut noise image');

