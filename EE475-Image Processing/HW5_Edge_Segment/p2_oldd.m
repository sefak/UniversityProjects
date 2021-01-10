gauss_rgb = double(imread('Gauss_rgb1.png'));
berkeley_horses = double(imread('Berkeley_horses.jpg')); 

gauss_rgb_seed = [32,32;32,96;96,64];
berkeley_horses_seed = [136,67;146,186;170,382];

choose_img = 1; % 0 for gauss_rgb, 1 for berkeley_horses

if choose_img == 0
    img = gauss_rgb; 
    r_size = size(img, 1);
    c_size = size(img, 2); 
    seed = gauss_rgb_seed;
    Th = 5; delta_t = 2;
    ground_truth_segments = zeros(r_size,c_size);
    for rN = 1:r_size
        for cN = 1:c_size
            if rN <= r_size/2
                if cN <= c_size/2
                    ground_truth_segments(rN,cN) = 1;
                else
                    ground_truth_segments(rN,cN) = 2;
                end
            else
                ground_truth_segments(rN,cN) = 3;
            end
        end
    end
else
    img = berkeley_horses;
    r_size = size(img, 1);
    c_size = size(img, 2); 
    seed = berkeley_horses_seed;
    Th = 5; delta_t = 10;
    load('berkeley_horses.mat');
    ground_truth_segments = groundTruth{1, 1}.Segmentation;
end

N = size(seed,1);
temp_img = img;
M(N).index=[];
for n=1:N
    M(n).index = seed(n,:);
    M(n).feature = temp_img(M(n).index(1),M(n).index(2),:);
    M(n).length = 1;
    temp_img(M(n).index(1),M(n).index(2),:) = -1;
end

count = 0;
while true
    feature_change = zeros(1,N);
    total_pixel = 0;
    for n=1:N
        old_feature = M(n).feature;
        flag = true;
        rN = M(n).index(1,1); cN = M(n).index(1,2);
        dis_cen = 0;
        while flag
            dis_cen = dis_cen + 1;
            for nrN = -dis_cen:dis_cen
                for ncN = -dis_cen:dis_cen
                    if temp_img(rN+nrN,cN+ncN,:) == -1, continue; end % if the pixel is labeled then skip it
                    temp = vecnorm(temp_img(rN+nrN,cN+ncN,:)-M(n).feature);
                    if temp < Th
                         M(n).index = [M(n).index; [rN+nrN cN+ncN]];
                         M(n).feature = (M(n).feature*M(n).length + temp_img(rN+nrN,cN+ncN,:)) ./ (M(n).length+1); % updating the mean of the regions
                         M(n).length = M(n).length + 1;
                         temp_img(rN+nrN,cN+ncN,:) = -1;
                         flag = true;
                    else
                        flag = false;
                    end
                end
            end
        end
        
        
        feature_change(n) = vecnorm(M(n).feature-old_feature);
        total_pixel = total_pixel + M(n).length;
    end 
    disp(vecnorm(feature_change))
    disp(total_pixel)
    if vecnorm(feature_change)<length(M(1).feature) && total_pixel> r_size*c_size-1 % since the color values are integer, 1 is sufficient for stopping condition
        break; 
    else
        count = count + 1;
        if count == 1, Th = Th + delta_t; count = 0; end % updating the threshold at every iteration
        %if Th > 60, delta_t = 20; break; end % to increase the speed the delta_t is updated
    end
    
end
%%
img_new = zeros(size(img, 1),size(img, 2),3,'uint8');
predected_segments = zeros(size(img, 1),size(img, 2),'uint8');
for n=1:N
    for eN = 1:length(M(n).index(:,1))
        img_new(M(n).index(eN,1),M(n).index(eN,2),:) = uint8(M(n).feature(1:3));
        predected_segments(M(n).index(eN,1),M(n).index(eN,2)) = n;
    end
end
figure; imshow(img_new);% figure; imshow(uint8(img));
%%
% Intersection over Union

IoU = zeros(1,N); 
for n = 1:N
    num_intersections = 0;
    num_union = 0;
    for rN = 1:r_size
        for cN = 1:c_size
            if ground_truth_segments(rN,cN) == n
                if predected_segments(rN,cN) == ground_truth_segments(rN,cN)
                    num_intersections = num_intersections + 1;
                    num_union = num_union + 1;
                else
                    num_union = num_union + 1;
                end
            end
        end
    end
    IoU(n) = num_intersections / num_union;
end

disp(IoU)


