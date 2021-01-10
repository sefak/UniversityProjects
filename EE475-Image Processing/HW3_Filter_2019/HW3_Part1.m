cirb = imread('circuitboard.jpg'); 
cirB = rgb2gray(cirb);
varn0 = 1024; % variance of the gaussian noise
cirB_noisy = imnoise(cirB, 'gaussian', 0, varn0/256^2);

cirB_noisy_extended = zeros(size(cirB_noisy, 1)+6,size(cirB_noisy, 2)+6, 'uint8');
cirB_noisy_extended(4:end-3,4:end-3) = cirB_noisy; % 0 padding is applied

figure(1)
imshow(cirB)
title('The original circuit board image');
figure(2)
imshow(cirB_noisy)
title('The noisy circuit board image');

%% ---------------------------Part a)------------------------------------

cirB_arithFiltered = zeros(size(cirB_noisy, 1),size(cirB_noisy, 2));
cirB_noisy_d=im2double(cirB_noisy_extended);
for k=4:size(cirB_noisy_extended, 1)-3
    for l=4:size(cirB_noisy_extended, 2)-3
       mat = cirB_noisy_d(k-3:k+3,l-3:l+3); % the filter window
       cirB_arithFiltered(k-3,l-3)=sum(sum((mat)))/49; % the mean of the matrix
    end
end

figure(3)
imshow(cirB_arithFiltered)
title('The arithmetic filtered circuit board image');
%% ---------------------------Part b)------------------------------------

cirB_geoFiltered = zeros(size(cirB_noisy, 1),size(cirB_noisy, 2));
cirB_noisy_d=im2double(cirB_noisy_extended);
for k=4:size(cirB_noisy_extended, 1)-3
    for l=4:size(cirB_noisy_extended, 2)-3
       mat = cirB_noisy_d(k-3:k+3,l-3:l+3);% the filter window
       cirB_geoFiltered(k-3,l-3)=prod(prod((mat)))^(1/49); % geo mean of the matrix
    end
end

figure(4)
imshow(cirB_geoFiltered)
title('The geometric filtered circuit board image');
%% ---------------------------Part c)------------------------------------

cirB_adapFiltered = zeros(size(cirB_noisy, 1),size(cirB_noisy, 2));
cirB_noisy_d=im2double(cirB_noisy_extended);
varn0 = varn0/256^2; % since im2double maps the image into [0 1]
for k=4:size(cirB_noisy_extended, 1)-3
    for l=4:size(cirB_noisy_extended, 2)-3
       mat = cirB_noisy_d(k-3:k+3,l-3:l+3);% the filter window
       varxy = var(mat,0,'all');
       if varn0>varxy
           coeff=1;
       else
           coeff = varn0/varxy;
       end
       cirB_adapFiltered(k-3,l-3)= cirB_noisy_d(k,l)-coeff*(cirB_noisy_d(k,l)-sum(sum((mat)))/49);
    end
end

figure(5)
imshow(cirB_adapFiltered)
title('The adaptive filtered circuit board image');

