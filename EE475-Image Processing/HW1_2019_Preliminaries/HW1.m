%% Generating Image Patterns

xsize = 480; ysize = 480; % size of the image

img_pat = zeros(xsize, ysize, 'uint8'); % initializing the image
[col, row] = meshgrid(1:xsize, 1:ysize); % indexing the pixels

xcenter = xsize/2; ycenter = ysize/2; % center of the circles
radius1 = 64; % radius of the inner circle
radius2 = 128; % radius of the outer circle

circle1px = (col - xcenter).^2 + (row - ycenter).^2 <= radius1.^2;
circle2px = ((col - xcenter).^2 + (row - ycenter).^2 <= radius2.^2) ... 
    & ((col - xcenter).^2 + (row - ycenter).^2 > radius1.^2);
% except the circles, the remaining part is background
background = not(or(circle1px, circle2px)); 

img_pat(circle1px) =  192 + (-16 + 32*rand(1,sum(sum(circle1px))));
img_pat(circle2px) =  128 + (-42 + 84*rand(1,sum(sum(circle2px))));
%to represent the background smoother, normal dist. is used with s.d. 10 
img_pat(background) =  64 + 10*randn(1,sum(sum(background)));

imwrite(img_pat, 'img_pat.tif'); % image is saved a tif file

%% Image Read & Write; Histogram Plots 

I = imread('peppers.png');  % reading the image

imshow(I); % displaying the image
title('Peppers');

imwrite(I, 'peppers.bmp');

img_info = imfinfo('peppers.bmp');

%% Image Read & Write; Histogram Plots part a)

I = imread('peppers.png');  % reading the image

I_r = I; I_r(:,:,[2 3]) = zeros; 
I_g = I; I_g(:,:,[1 3]) = zeros; 
I_b = I; I_b(:,:,[1 2]) = zeros; 


subplot(1,3,1);
imshow(I_r);
title('Peppers with only red color');

subplot(1,3,2);
imshow(I_g);
title('Peppers with only green color');

subplot(1,3,3);
imshow(I_b);
title('Peppers with only blue color');

%% Image Read & Write; Histogram Plots part b)
I = imread('peppers.png');  % reading the image

newI = (I(:,:,1)>90) & (I(:,:,2)>10) & (I(:,:,3)<40);
% newI will be a logical matrix that contains 1 if this conditions are true
% or 0 if not. Then if it is displayed by using imshow, 1 corresponds
% white, 0 corresponds black. a(:,:,3) = I(:,:,3).*uint8(newI);

[ys, xs] = find(newI == 1); % the spatial coordinates that satisfies this 
% conditions.
imshow(newI);
title('The Binary Image Under the Given Conditions');

%% Image Read & Write; Histogram Plots part c)
I = imread('peppers.png');  % reading the image

% Since the values are stored an array type uint8, the max value is 255.
% When they are added to each other, they can exceed this level. So they
% should be converted to higher bit sequences and converted back to uint8.
gray = uint8((int16(I(:,:,1))+int16(I(:,:,2))+int16(I(:,:,3)))/3);

imshow(gray);
title('Gray Version of the Peppers Image');

imwrite(gray, 'gray.bmp');


%% Image Read & Write; Histogram Plots part d)
I = imread('gray.bmp');  % reading the image

imhist(I);

title('Histogram of the Gray Version of the Peppers Image');
%% Image Read & Write; Histogram Plots part e)
I = imread('gray.bmp');  % reading the image

I_divby2 = I./2;

figure(1)
subplot(1,2,1);
imshow(I_divby2);
title('The Gray Version Divided its Pixels Values by 2');
subplot(1,2,2);
imhist(I_divby2);
title('The Histogram of the Gray Version Divided its Pixels Values by 2');

I_add64 = I + 64;

figure(2)
subplot(1,2,1);
imshow(I_add64);
title('The Gray Version Added its Pixels Values 64');
subplot(1,2,2);
imhist(I_add64);
title('The Histogram of the Gray Version Added its pixels values 64');

% The comments for the results are in the report.

%% Pixels Varieties a)

cetus = imread('Cetus_NGC1052Galaxy.jpg');

grayCetus = rgb2gray(cetus); % the gray image can be analyzed
totalofRgb = sum(int16(cetus),3); % total value of RGB can be analyzed; in
% not to exceed the boundaries of uint8, cetus converted to int16.

% Finding the brighest points
[maxValues, Indecies] = max(grayCetus);
[rows1, cols1] = find(grayCetus == max(maxValues)); 

% Finding the brighest point 
[maxValues, Indecies] = max(totalofRgb);
[rows2, cols2] = find(totalofRgb == max(maxValues)); 

% Selecting only the brighest points according to gray scale
new1 = 255*ones(1000,1500,3);
for i=1:length(rows1)
    new1(rows1(i), cols1(i), :) = 0;
end

% Selecting only the brighest points according to total values
new2 = 255*ones(1000,1500,3);
for i=1:length(rows2)
    new2(rows2(i), cols2(i), :) = 0;
end

% showing the brightest points on the image; Also the coordinates can be 
% displayed but showing the images is more convenient.
subplot(1,2,1);
imshow(new1);
title('The Brightest Points Using Gray Scale');
subplot(1,2,2);
imshow(new2);
title('The Brightest Points Using Total RGB Values');

%% Pixels Varieties b)

office = imread('Office.png');

% Since the image is gray, the 1st method in the a part can be used
grayOffice = rgb2gray(office);

% the brighest point is the closest point
[maxValues, Indecies] = max(grayOffice);
[rowsC, colsC] = find(grayOffice == max(maxValues)); 

% the darkest point is the farhest point
[minValues, Indecies] = min(grayOffice);
[rowsF, colsF] = find(grayOffice == min(minValues)); 

% Displaying the results
fprintf('The closest point coordinates are (%d, %d)\n', rowsC, colsC); 
fprintf('The farthest point coordinates are (%d, %d)\n', rowsF, colsF); 
fprintf('And the image size is (%d, %d)\n', size(office,1), size(office,2));

%% Pixels Varieties c)Skull

skull = imread('SKULL_head24.tif');

% the brighest point is the most transperant point
[maxValues, Indecies] = max(skull);
[rowsST, colsST] = find(skull == max(maxValues)); 

% Since the background has the lowest value, in order to find the darkest
% point in the region of interest, the background should have some value
% larger than their values.(It is inspected that background pixel values  
% are between 0 and 16). 
skull_woBackground = skull > 16;
skull_woBackground = skull.*uint8(skull_woBackground) + ...
    255*ones(size(skull,1), size(skull,2), 'uint8').*uint8(~skull_woBackground);
% skull_woBackground is formed by making white the pixels that have their 
% values lower than 16.

imshow(skull_woBackground);
title('The Skull with White Background');


%% Pixels Varieties c)Breast
breast = imread('Breast_density.jpg');

% the brighest point is the most transperant point
[maxValues, Indecies] = max(breast);
[rowsBT, colsBT] = find(breast == max(maxValues)); 

% Since the background has the lowest value, in order to find the darkest
% point in the region of interest, the background should have some value
% larger than their values.(It is inspected that background pixel values  
% are between 0 and 3). 
breast_woBackground = breast > 3;
breast_woBackground = breast.*uint8(breast_woBackground) + ...
    255*ones(size(breast,1), size(breast,2), 'uint8').*uint8(~breast_woBackground);
% breast_woBackground is formed by making white the pixels that have their 
% values lower than 3.

imshow(breast_woBackground);
title('The Breast with White Background');

%% Pixels Varieties d)

thermal = imread('Thermal_pedestrian_00005.bmp');

% the brighest point is the hotest point
[maxValues, Indecies] = max(thermal);
[rows, cols] = find(thermal >= max(maxValues)-16); % range of max to max-15

% displaying the results
fprintf('The hotest points coordinates are \n');
for i=1:length(cols)
    fprintf('(%d, %d)\n', rows(i), cols(i));
end

%% Pixels Varieties e)

seq1 = imread('taxi36.pgm');
seq2 = imread('taxi38.pgm');
seq3 = imread('taxi40.pgm');

% 1st way

% averaging 3 sequences to reveal the changed and unchanged pixels' colors. 
ave = uint8((int16(seq1)+int16(seq2)+int16(seq3))/3);
figure(1)
imshow(ave);
title('The Average Image of the Three Sequences');
% analyzing the image there are 3 moving objects and detailed explaination 
% is given in the report.


% 2nd way

% in order to get the negative changes, the values are converted to int8.
% Since the negative values in an image will not be meaningfull, the
% absolute values are taken.
diff1 = uint8(abs(int8(seq2) - int8(seq1)));
diff2 = uint8(abs(int8(seq3) - int8(seq2)));
diff3 = uint8(abs(int8(seq3) - int8(seq1)));

figure(2)
subplot(1,3,1);
imshow(diff1);
title('The Difference from 2nd to 1st Sequence');
subplot(1,3,2);
imshow(diff2);
title('The Difference from 3rd to 2nd Sequence');
subplot(1,3,3);
imshow(diff3);
title('The Difference from 3rd to 1st Sequence');

%% Imaging System Design


