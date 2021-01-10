pentago = imread('pentagon.jpg');

pentagon = rgb2gray(pentago); % converting it to gray scale

figure(1)
imshow(pentagon)
title('The original pentagon image');

%% ---------------------------Part a)------------------------------------
pentagon_noisy = imnoise(pentagon,'salt & pepper', 0.5);

pentangon_noisy_extended = zeros(size(pentagon_noisy, 1)+6,size(pentagon_noisy, 2)+6, 'uint8');
pentangon_noisy_extended(4:end-3,4:end-3) = pentagon_noisy; % 0 padding is applied

figure(2)
imshow(pentagon_noisy)
title('The noisy pentagon image');

%% ---------------------------Part b)------------------------------------

pentagon_medianFiltered = zeros(size(pentagon_noisy, 1),size(pentagon_noisy, 2));
pentagon_noisy_d=im2double(pentangon_noisy_extended);
for k=4:size(pentangon_noisy_extended, 1)-3
    for l=4:size(pentangon_noisy_extended, 2)-3
       mat = pentagon_noisy_d(k-3:k+3,l-3:l+3);% the filter window
       pentagon_medianFiltered(k-3,l-3)=median(mat,'all');
    end
end

figure(3)
imshow(pentagon_medianFiltered)
title('The median filtered pentagon image');

%% ---------------------------Part c)------------------------------------

pentagon_adapFiltered = zeros(size(pentagon_noisy, 1),size(pentagon_noisy, 2));
pentagon_noisy_d=im2double(pentangon_noisy_extended);
for k=4:size(pentangon_noisy_extended, 1)-3
    for l=4:size(pentangon_noisy_extended, 2)-3
       for n=1:3
          mat = pentagon_noisy_d(k-n:k+n,l-n:l+n);% the filter window
          med = median(mat,'all');
          if(med~=max(max(mat))&&med~=min(min(mat)))
              break; % breaks if median is found as different from the min or max
          end
       end
       if(pentagon_noisy_d(k,l)~=max(max(mat))&&pentagon_noisy_d(k,l)~=min(min(mat)))
          med = pentagon_noisy_d(k,l); %assigns if original value is different from min or max
       end
       pentagon_adapFiltered(k-3,l-3) = med;
    end
end

figure(4)
imshow(pentagon_adapFiltered)
title('The adaptive filtered pentagon image');




