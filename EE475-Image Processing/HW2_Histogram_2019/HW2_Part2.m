%% Histogram Equalization 
I1 = imread('lumbercamp.jpg');
I2 = imread('moon.jpg');

eqI1 = histEqu(I1);
eqI2 = histEqu(I2);

J1 = histeq(I1);
J2 = histeq(I2);

% displaying the lumbercamp image
figure(1);
subplot(2,2,1)
imshow(eqI1);
subplot(2,2,2)
imshow(J1);
subplot(2,2,3)
imhist(eqI1);
%xlabel('Gray Level');
ylabel('# of Pixels');
subplot(2,2,4)
imhist(J1);
%xlabel('Gray Level');
ylabel('# of Pixels');

% displaying the moon image
figure(2);
subplot(2,2,1)
imshow(eqI2);
subplot(2,2,2)
imshow(J2);
subplot(2,2,3)
imhist(eqI2);
%xlabel('Gray Level');
ylabel('# of Pixels');
subplot(2,2,4)
imhist(J2);
%xlabel('Gray Level');
ylabel('# of Pixels');

% adaptive histogram equalization

A_J1 = adapthisteq(I1);
A_J2 = adapthisteq(I2);

% displaying the adaptive histogram equalization results
figure(3);
subplot(2,2,1)
imshow(A_J1);
subplot(2,2,2)
imshow(A_J2);
subplot(2,2,3)
imhist(A_J1);
%xlabel('Gray Level');
ylabel('# of Pixels');
subplot(2,2,4)
imhist(A_J2);
%xlabel('Gray Level');
ylabel('# of Pixels');

% displaying the original images and their histograms
figure(4);
subplot(2,2,1)
imshow(I1);
subplot(2,2,2)
imshow(I2);
subplot(2,2,3)
imhist(I1);
%xlabel('Gray Level');
ylabel('# of Pixels');
subplot(2,2,4)
imhist(I2);
%xlabel('Gray Level');
ylabel('# of Pixels');
