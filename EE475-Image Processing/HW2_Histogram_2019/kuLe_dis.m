function  dist = kuLe_dis(img1,img2)
%kuLe_dis calculates the distances according to the Kullback-Leibler 
%distance  between each RGB component of the img1 and img2 and outputs
%the average of the three.
%   Detailed explanation goes here

dist=zeros(1,3);
for i=1:3
    
    [hist1, ~]=imhist(img1(:,:,i));
    [hist2, ~]=imhist(img2(:,:,i));
    
      
    % since all pixels should be non zero due to division by zero, the
    % zeros values are made 1 to be defined over the domain of log
    
    hist1(hist1==0)=1;
    hist2(hist2==0)=1;
    
    % since this distance calculation uses the probability density, the
    % histograms are normalized
    hist1 = hist1./sum(hist1);
    hist2 = hist2./sum(hist2);
   
    dist(i)=(sum(hist1.*log2(hist2./hist1))+sum(hist2.*log2(hist1./hist2)))/2;
   
end
dist=-sum(dist)/3;
end

