%% Histogram equalization of color image
kugu = imread('kugu.jpg');
beach = imread('beach.jpg');

% part a) 
% applying the equalization 
eqKugu = histEqu_color(kugu);
eqBeach = histEqu_color(beach);

% showing the original images
figure(1)
subplot(1,2,1)
imshow(kugu);
subplot(1,2,2)
imshow(beach);

% showing the equalized images
figure(2)
subplot(1,2,1)
imshow(eqKugu);
subplot(1,2,2)
imshow(eqBeach);

% part b)

kugu_hsv1 = rgb2hsv(kugu); %transforming to the h-s-v domain

kugu_hsv1(:,:,3) = histeq(kugu_hsv1(:,:,3)); % equalization of intensity

kuguNew1 = uint8(255.*hsv2rgb(kugu_hsv1)); % tranforming back to rgb domain
% hsv2rgb gives the value in the range 0-1, so it is transformed to 0-255

beach_hsv1 = rgb2hsv(beach); %transforming to the h-s-v domain

beach_hsv1(:,:,3) = histeq(beach_hsv1(:,:,3)); % equalization of intensity

beachNew1 = uint8(255.*hsv2rgb(beach_hsv1)); % tranforming back to rgb domain
% hsv2rgb gives the value in the range 0-1, so it is transformed to 0-255

% showing the equalized intensity images
figure(3)
subplot(1,2,1)
imshow(kuguNew1);
subplot(1,2,2)
imshow(beachNew1);

% part c)
kugu_hsv2 = rgb2hsv(kugu); %transforming to the h-s-v domain

kugu_hsv2(:,:,2) = histeq(kugu_hsv2(:,:,2)); % equalization of saturation

kuguNew2 = uint8(255.*hsv2rgb(kugu_hsv2)); % tranforming back to rgb domain
% hsv2rgb gives the value in the range 0-1, so it is transformed to 0-255

beach_hsv2 = rgb2hsv(beach); %transforming to the h-s-v domain

beach_hsv2(:,:,2) = histeq(beach_hsv2(:,:,2)); % equalization of intensity

beachNew2 = uint8(255.*hsv2rgb(beach_hsv2)); % tranforming back to rgb domain
% hsv2rgb gives the value in the range 0-1, so it is transformed to 0-255

% showing the equalized saturation images
figure(4)
subplot(1,2,1)
imshow(kuguNew2);
subplot(1,2,2)
imshow(beachNew2);