rose = imread('Gonzalez_Rose.jpg');

rose_noisy = zeros(size(rose,1),size(rose,2), 60, 'uint8');
rose_medianFiltered = zeros(size(rose,1),size(rose,2), 60, 'uint8');
for k=1:10
   for n=1:6
       % applying each combination of noise and filter window
       [rose_noisy(:,:,6*(k-1)+n), rose_medianFiltered(:,:,6*(k-1)+n) ]=part4_addNoise_medianFilter(rose,6*k,2*n+1);
   end
end


%% ssim indecies
ssim_inds_noise = zeros(10,6);
ssim_inds_filtered = zeros(10,6);
for k=1:10
   for n=1:6
       ssim_inds_noise(k,n) = ssim(rose_noisy(:,:,6*(k-1)+n), rose);
       ssim_inds_filtered(k,n) = ssim(rose_medianFiltered(:,:,6*(k-1)+n), rose);
   end
end
%%
yvar = '3x3                    5x5                7x7                  9x9             11x11            13x13';
xvar = '3%     6%     9%      12%      15%      18%     21%      24%      27%     30%';


figure(1);
hMap_filtered = heatmap(ssim_inds_filtered');
hMap_filtered.Colormap = flipud(jet);
hMap_filtered.XLabel = xvar;
hMap_filtered.YLabel = yvar; % it is needed to sort the rows backward 
title('The heatmap of ssim indecies between after filter');

figure(2);
hMap_noise = heatmap(ssim_inds_noise');
hMap_noise.Colormap = flipud(jet);
hMap_noise.XLabel = xvar;
hMap_noise.YLabel = yvar; % it is needed to sort the rows backward 
title('The heatmap of ssim indecies between before filter');

%%
% represent an example of noisy and filtered image
x=10; % 10*3% = 30% salt pepper noise
y=5; % 5*2+1 = 11by11 window size of median filter

figure(3)
imshow(rose_noisy(:,:,6*(x-1)+y))
figure(4)
imshow(rose_medianFiltered(:,:,6*(x-1)+y))

