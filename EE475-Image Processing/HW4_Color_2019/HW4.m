%% Part 3

M=800; % it should be multiples of 16.

img_part3 = zeros(M,M,3, 'uint8');
img_part3_hsi = zeros(M,M,3, 'uint8');

img_part3(M*1/16:M*5/16, M*1/16:M*5/16, 1) = 255; % red color
img_part3(M*1/16:M*5/16, M*6/16:M*10/16, 2) = 255; % green color
img_part3(M*1/16:M*5/16, M*11/16:M*15/16, 3) = 255; % blue color

img_part3(M*6/16:M*10/16, M*1/16:M*5/16, [1 3]) = 255; % magenta color
img_part3(M*6/16:M*10/16, M*6/16:M*10/16, [2 3]) = 255; % cyan color
img_part3(M*6/16:M*10/16, M*11/16:M*15/16, [1 2]) = 255; % yellow color

img_part3(M*11/16:M*15/16, M*6/16:M*10/16, [1 2 3]) = 255; % white color

imshow(img_part3);
% imwrite(img_part3, 'img_part3.jpg');

% hue values
img_part3_hsi(M*1/16:M*5/16, M*1/16:M*5/16, 1) = uint8(0*(255/7)); % red color
img_part3_hsi(M*1/16:M*5/16, M*6/16:M*10/16, 1) = uint8(2*(255/7)); % green color
img_part3_hsi(M*1/16:M*5/16, M*11/16:M*15/16, 1) = uint8(5*(255/7)); % blue color

img_part3_hsi(M*6/16:M*10/16, M*1/16:M*5/16, 1) = uint8(6*(255/7)); % magenta color
img_part3_hsi(M*6/16:M*10/16, M*6/16:M*10/16, 1) = uint8(4*(255/7)); % cyan color
img_part3_hsi(M*6/16:M*10/16, M*11/16:M*15/16, 1) = uint8(2*(255/7)); % yellow color

img_part3_hsi(M*11/16:M*15/16, M*6/16:M*10/16, 1) = uint8(0*(255/7)); % white color

% saturation values
img_part3_hsi(M*1/16:M*5/16, M*1/16:M*5/16, 2) = uint8(7*(255/7)); % red color
img_part3_hsi(M*1/16:M*5/16, M*6/16:M*10/16, 2) = uint8(7*(255/7)); % green color
img_part3_hsi(M*1/16:M*5/16, M*11/16:M*15/16, 2) = uint8(7*(255/7)); % blue color

img_part3_hsi(M*6/16:M*10/16, M*1/16:M*5/16, 2) = uint8(7*(255/7)); % magenta color
img_part3_hsi(M*6/16:M*10/16, M*6/16:M*10/16, 2) = uint8(7*(255/7)); % cyan color
img_part3_hsi(M*6/16:M*10/16, M*11/16:M*15/16, 2) = uint8(7*(255/7)); % yellow color

img_part3_hsi(M*11/16:M*15/16, M*6/16:M*10/16, 2) = 0; % white color

% intensity values
img_part3_hsi(M*1/16:M*5/16, M*1/16:M*5/16, 3) = uint8(2*(255/7)); % red color
img_part3_hsi(M*1/16:M*5/16, M*6/16:M*10/16, 3) = uint8(2*(255/7)); % green color
img_part3_hsi(M*1/16:M*5/16, M*11/16:M*15/16, 3) = uint8(2*(255/7)); % blue color

img_part3_hsi(M*6/16:M*10/16, M*1/16:M*5/16, 3) = uint8(5*(255/7)); % magenta color
img_part3_hsi(M*6/16:M*10/16, M*6/16:M*10/16, 3) = uint8(5*(255/7)); % cyan color
img_part3_hsi(M*6/16:M*10/16, M*11/16:M*15/16, 3) = uint8(5*(255/7)); % yellow color

img_part3_hsi(M*11/16:M*15/16, M*6/16:M*10/16, 3) = uint8(7*(255/7)); % white color


figure();
subplot(1,3,1);
imshow(img_part3_hsi(:,:,1))
title('hue')
subplot(1,3,2);
imshow(img_part3_hsi(:,:,2))
title('saturation')
subplot(1,3,3);
imshow(img_part3_hsi(:,:,3))
title('intensity')





