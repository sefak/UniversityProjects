function img_match = imgMatch(img,refImg)
%imgMatch matches the histogram of the refImg to img
%   Detailed explanation goes here

G = 255; % G is the max value of a pixel. 

% finding the equalizated histogram of img
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
% the formula covered in the lecture is used 


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

% this step should be done at the end of the transform.
% the formula covered in the lecture is used 
%img_eqHist=uint8(G.*img_eqHist+0.5);% converting to the double type to uint8



% determining the cdf of the reference image refImg

% cdf of R component
[histR, ~] = imhist(refImg(:,:,1)); % histogram of the image
histR([1 256])=0; % disregarding 255 and 0 values in the histogram    

totalPixel = sum(histR);
p_histR = histR./totalPixel; % probability of the pixels being a particular 
% value from 0 to G

cdf_histR = cumsum(p_histR); % cummulative density of the pixels

% cdf of G component
[histG, ~] = imhist(refImg(:,:,2)); % histogram of the image
histG([1 256])=0; % disregarding 255 and 0 values in the histogram    

totalPixel = sum(histG);
p_histG = histG./totalPixel; % probability of the pixels being a particular 
% value from 0 to G

cdf_histG = cumsum(p_histG); % cummulative density of the pixels

% cdf of the B component
[histB, ~] = imhist(refImg(:,:,3)); % histogram of the image
histB([1 256])=0; % disregarding 255 and 0 values in the histogram    

totalPixel = sum(histB);
p_histB = histB./totalPixel; % probability of the pixels being a particular 
% value from 0 to G

cdf_histB = cumsum(p_histB); % cummulative density of the pixels



% Mapping the pixels in the equalized img into the inverse cdf of the refImg

% determining the values for R component
imgMatchR=zeros(size(img,1),size(img,2));
uniqR = unique(img_eqHistR);
for n=1:length(uniqR)
    % determining the pixels value according to the inverse cdf of refImg.
    [val, ind] = min(abs(cdf_histR-uniqR(n)));
    % the index of the closest pixel is the value of the inverse cdf 
    if(unique(ind)==1)
        imgMatchR(img_eqHistR==uniqR(n))=ind+1;
    else 
        % if there exists more than 1 index than  it choose the smallest 
        % one as covered in the lecture 
        imgMatchR(img_eqHistR==uniqR(n))=min(ind)+1;
    end
end

% determining the values for G component
imgMatchG=zeros(size(img,1),size(img,2));
uniqG = unique(img_eqHistG);
for n=1:length(uniqG)
    % determining the pixels value according to the inverse cdf of refImg.
    [val, ind] = min(abs(cdf_histG-uniqG(n)));
    % the index of the closest pixel is the value of the inverse cdf
    if(unique(ind)==1)
        imgMatchG(img_eqHistG==uniqG(n))=ind+1;
    else
        % if there exists more than 1 index than  it choose the smallest 
        % one as covered in the lecture
        imgMatchG(img_eqHistG==uniqG(n))=min(ind)+1;
    end
end

% determining the values for B component
imgMatchB=zeros(size(img,1),size(img,2));
uniqB = unique(img_eqHistB);
for n=1:length(uniqB)
    % determining the pixels value according to the inverse cdf of refImg.
    [val, ind] = min(abs(cdf_histB-uniqB(n)));
    % the index of the closest pixel is the value of the inverse cdf
    if(unique(ind)==1)
        imgMatchB(img_eqHistB==uniqB(n))=ind+1;
    else
        % if there exists more than 1 index than  it choose the smallest 
        % one as covered in the lecture
        imgMatchB(img_eqHistB==uniqB(n))=min(ind)+1;
    end
end

img_match = zeros(size(img,1),size(img,2),3);

img_match(:,:,1)=imgMatchR;
img_match(:,:,2)=imgMatchG;
img_match(:,:,3)=imgMatchB;

img_match=uint8(img_match);% converting to the double type to uint8


end

