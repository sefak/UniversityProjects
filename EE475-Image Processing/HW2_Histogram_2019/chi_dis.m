function dist = chi_dis(img1,img2)
%chi_dis calculates the distances according to the chi-square histogram 
%distance  between each RGB component of the img1 and img2 and outputs 
%the average of the three.
%   Detailed explanation goes here

dist=zeros(1,3);
for i=1:3
    
    [hist1, ~]=imhist(img1(:,:,i));
    [hist2, ~]=imhist(img2(:,:,i));
    
    
    
    % since this distance calculation uses the probability density, the
    % histograms are normalized
    hist1 = hist1./sum(hist1);
    hist2 = hist2./sum(hist2);
    
    % at least one of them should be non zero due to division by zero
    ind = hist1~=0 | hist2~=0;
    dist(i)= sqrt(sum(((hist1(ind)-hist2(ind)).^2)./(hist1(ind)+hist2(ind)))/2);
    
end
dist=sum(dist)/3;
end

