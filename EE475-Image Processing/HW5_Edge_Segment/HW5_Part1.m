clear;
pcb = double(imread('PCB.bmp')); % N=3 for only color, N=45 for color+coordinates 
gazete = double(imread('HW_Segmen_Image_Gazete.bmp')); % N=2 for only color, N=30 for color+coordinates
starfish = double(imread('12003.jpg')); % N=5 for only color, N=34 for color+coordinates


choose_img = 1; % 1 for pcb, 2 for gazete, 3 for starfish
include_coordinate = false; % includes the coordinates to the feature vector

if choose_img == 1 
    img = pcb;
    ndim = 1; % number of color dimension
    N = 3; % number of clusters
    if include_coordinate, N = 45; end
elseif choose_img == 2 
    img = gazete;
    ndim = 1; % number of color dimension
    N = 2; % number of clusters
    if include_coordinate, N = 30; end
elseif choose_img == 3 
    img = starfish;
    ndim = 3; % number of color dimension
    N = 5; % number of clusters
    if include_coordinate, N = 34; end
end

r_size = size(img, 1);
c_size = size(img, 2);  

M(N).index=[];
for n=1:N
    M(n).index = ceil([r_size.*rand,c_size.*rand]);
    M(n).feature(1:3) = img(M(n).index(1),M(n).index(2),:);
    if include_coordinate
       M(n).feature(ndim+1:ndim+2) = M(n).index; 
    end
end

while true
    for rN = 1:r_size
        for cN = 1:c_size
            temp = zeros(1,N);
            feature_current(1:ndim) = img(rN,cN,:);
            if include_coordinate
               feature_current(ndim+1:ndim+2) = [rN cN]; 
            end
            for n=1:N
                temp(n) = norm(feature_current-M(n).feature);
            end
            [~,ind] = min(temp);
            M(ind).index = [M(ind).index; [rN cN]];
        end
    end 
        
    % updating the mean feature of the clusters
    feature_change = zeros(1,N);
    for n=1:N
        sum_feature=0;
        for eN = 1:length(M(n).index(:,1))
            feature_current(1:ndim) = img(M(n).index(eN,1),M(n).index(eN,2),:);
                if include_coordinate
                   feature_current(ndim+1:ndim+2) = M(n).index(eN,:); 
                end
            sum_feature = sum_feature + feature_current;
        end
        old_feature = M(n).feature;
        M(n).feature = sum_feature/eN;
        feature_change(n) = norm(M(n).feature-old_feature);
    end
    disp('Please wait!')
    if norm(feature_change)<length(feature_current) % since the color values are integer, 1 is sufficient for stopping condition
        disp('The algorithm converges. :)')
        break; 
    else
        for n=1:N, M(n).index=[]; end % removing the old clusters' members
    end
   
end
%%
img_new = zeros(size(img, 1),size(img, 2),ndim,'uint8');
img_seg = zeros(size(img, 1),size(img, 2),'uint8');
for n=1:N
    for eN = 1:length(M(n).index(:,1))
        img_new(M(n).index(eN,1),M(n).index(eN,2),:) = uint8(M(n).feature(1:ndim));
        img_seg(M(n).index(eN,1),M(n).index(eN,2),:) = n;
    end
end

figure(1); imshow(img_new); title('Segmented image with its mean intensity values');
figure(2); imshow(img_seg,[]); title('Segments of the image');
figure(3); imshow(uint8(img)); title('Original image');

