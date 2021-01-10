function img_eqHist = histEqu_part3(img)
%histEqu_part3 takes an image to equalize its histogram, 
%   It is specialized version of the 'histEqu' function, it equalizes the
%   histogram of each RGB component and it ignores the pixel with 0 and
%   255 value.

G = 255; % G is the max value of a pixel. 

% equalization of the R component
[histR, ~] = imhist(img(:,:,1)); % histogram of the image
histR([1 256])=0; % disregarding 255 and 0 values in the histogram    

totalPixel = sum(histR);
p_histR = histR./totalPixel; % probability of the pixels being a particular 
% value from 0 to G

cdf_histR = cumsum(p_histR); % cummulative density of the pixels

img_eqHistR=zeros(size(img,1),size(img,2));
for n=0:G
    % the disregared pixels having 0 and 255 value become black, and white,
    % respectively. And they don't contribute the cdf of the other pixels
    % determining the pixels value according to the cdf.
    img_eqHistR(img(:,:,1)==n)=cdf_histR(n+1); 
end

% equalization of the G component
[histG, ~] = imhist(img(:,:,2)); % histogram of the image
histG([1 256])=0; % disregarding 255 and 0 values in the histogram    

totalPixel = sum(histG);
p_histG = histG./totalPixel; % probability of the pixels being a particular 
% value from 0 to G

cdf_histG = cumsum(p_histG); % cummulative density of the pixels

img_eqHistG=zeros(size(img,1),size(img,2));
for n=0:G
    % the disregared pixels having 0 and 255 value become black, and white,
    % respectively. And they don't contribute the cdf of the other pixels
    % determining the pixels value according to the cdf.
    img_eqHistG(img(:,:,2)==n)=cdf_histG(n+1); 
end


% equalization of the B component
[histB, ~] = imhist(img(:,:,3)); % histogram of the image
histB([1 256])=0; % disregarding 255 and 0 values in the histogram    

totalPixel = sum(histB);
p_histB = histB./totalPixel; % probability of the pixels being a particular 
% value from 0 to G

cdf_histB = cumsum(p_histB); % cummulative density of the pixels

img_eqHistB=zeros(size(img,1),size(img,2));
for n=0:G
    % the disregared pixels having 0 and 255 value become black, and white,
    % respectively. And they don't contribute the cdf of the other pixels
    % determining the pixels value according to the cdf.
    img_eqHistB(img(:,:,3)==n)=cdf_histB(n+1); 
end

img_eqHist=zeros(size(img,1),size(img,2),3);

img_eqHist(:,:,1)=img_eqHistR;
img_eqHist(:,:,2)=img_eqHistG;
img_eqHist(:,:,3)=img_eqHistB;

% the formula covered in the lecture is used 
img_eqHist=uint8(G.*img_eqHist+0.5);% converting to the double type to uint8

end

