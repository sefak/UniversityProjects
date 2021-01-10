function [img_noisy,img_medianFiltered] = part4_addNoise_medianFilter(img, percentage, winSize)
%input:  img        -> image to be added noise and median filtered.
%        percentage -> percentage value of the salt&pepper noise
%        winSize    -> window size of the median filter
%
%output: img_noisy  -> image added salt&pepper noise
% img_medianFiltered-> median filtered image
%
%
%   It takes img, adds salt&pepper noise with the given percentage and 
%   applies median filter with the window size of winSize. It outputs 
%   noisy image and filtered image.

x = floor(winSize/2); % it rounds it to the previous integer value

img_noisy = imnoise(img,'salt & pepper', percentage/100);

img_noisy_extended = zeros(size(img_noisy, 1)+12,size(img_noisy, 2)+12, 'uint8');
img_noisy_extended(7:end-6,7:end-6) = img_noisy; % 0 padding is applied

img_medianFiltered = zeros(size(img_noisy, 1),size(img_noisy, 2), 'uint8');

for k=7:size(img_noisy_extended, 1)-6
    for l=7:size(img_noisy_extended, 2)-6
       mat = img_noisy_extended(k-x:k+x,l-x:l+x);
       img_medianFiltered(k-6,l-6)=median(mat,'all');
    end
end

end

