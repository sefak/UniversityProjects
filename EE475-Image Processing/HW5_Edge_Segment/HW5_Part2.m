clear;
gauss_rgb = double(imread('Gauss_rgb1.png'));
berkeley_horses = double(imread('Berkeley_horses.jpg')); 

gauss_rgb_seed = [32,32;32,96;96,64];
berkeley_horses_seed = [34,326;144,144;170,382];% [120,219;34,325;125,293;304,270];%[35,235;129,125;162,378;228,42];

choose_img = 0; % 0 for gauss_rgb, 1 for berkeley_horses

if choose_img == 0
    img = gauss_rgb; 
    r_size = size(img, 1);
    c_size = size(img, 2); 
    seed = gauss_rgb_seed;
    Th = 5; delta_t = 10;
    a = [ 0 0 0]; % threshold values are the same for each region in rbg image
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
    Th = 5; delta_t = 19;
    a = [ 0 0 -4]; % for the small horse, the treshold should be small since it joins with the other regions 
    load('berkeley_horses.mat');
    ground_truth_segments = groundTruth{1, 1}.Segmentation;
end

N = size(seed,1);
temp_img = img;
M(N).index=[];
for n=1:N
    M(n).index = seed(n,:);
    M(n).feature(1:3) = temp_img(M(n).index(1),M(n).index(2),:);
    M(n).length = 1;
    temp_img(M(n).index(1),M(n).index(2),:) = -1;
end

while true
    feature_change = zeros(1,N);
    total_pixel = 0;
    for n=1:N
        old_feature = M(n).feature;
        newAdded = M(n).index; 
        while ~isempty(newAdded)
            newAdded_loop = [];
            for nNew = 1:size(newAdded,1)
                rN =newAdded(nNew,1); cN =newAdded(nNew,2);
                if rN<r_size && rN>1 && cN<c_size && cN>1 
                    for nrN = -1:1
                        for ncN = -1:1
                            current_feature(1:3) = temp_img(rN+nrN,cN+ncN,:);
                            if current_feature == -1, continue; end % if the pixel is labeled then skip it
                            temp = norm(current_feature-M(n).feature);
                            if temp < Th + a(n)
                                 M(n).index = [M(n).index; [rN+nrN cN+ncN]];
                                 M(n).feature = (M(n).feature*M(n).length + current_feature) ./ (M(n).length+1); % updating the mean of the regions
                                 M(n).length = M(n).length + 1;
                                 temp_img(rN+nrN,cN+ncN,:) = -1;
                                 newAdded_loop = [newAdded_loop; [rN+nrN cN+ncN]];
                            end
                        end
                    end
                end
            end
            newAdded = newAdded_loop; 
        end
        feature_change(n) = norm(M(n).feature-old_feature);
        total_pixel = total_pixel + M(n).length;
    end 
    disp('Please wait!')
    if norm(feature_change)<length(M(1).feature) && total_pixel> r_size*c_size-1 % since the color values are integer, 1 is sufficient for stopping condition
        disp('The algorithm converges. :)')
        break; 
    else
        Th = Th + delta_t;  % updating the threshold at every iteration
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
figure(1); imshow(img_new); title('Regions with its mean intensity values');
figure(2); imshow(predected_segments,[]); title('Regions of the image');
figure(3); imshow(uint8(img)); title('Original image');

% Intersection over Union
IoU = zeros(1,N); 
for n = 1:N
    num_intersections = sum(predected_segments==n & ground_truth_segments==n,'all');
    num_union = sum(predected_segments==n | ground_truth_segments==n,'all');
    IoU(n) = num_intersections / num_union;
end

disp(IoU)


