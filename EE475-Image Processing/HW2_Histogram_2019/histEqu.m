function img_eqHist = histEqu(img)
%histEqu takes an image to equalize its histogram, 
%   Detailed explanation goes here
G = 255; % G is the max value of a pixel. 


[hist, ~] = imhist(img); % histogram of the image

totalPixel = sum(hist);
p_hist = hist./totalPixel; % probability of the pixels being a particular 
% value from 0 to G

cdf_hist = cumsum(p_hist); % cummulative density of the pixels

img_eqHist=zeros(size(img,1),size(img,2));
for n=0:G
    % determining the pixels value according to the cdf.
    img_eqHist(img(:,:)==n)=cdf_hist(n+1); 
end
% the formula covered in the lecture is used 
img_eqHist=uint8(G.*img_eqHist+0.5);% converting to the double type to uint8

end

