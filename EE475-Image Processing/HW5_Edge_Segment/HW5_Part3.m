clear;
%% generating the given image
xsize = 256; ysize = 256;

diamond = uint8(64 + (-2+4*rand(xsize,ysize))); % initially set everywhere as background
[col, row] = meshgrid(1:xsize, 1:ysize); % indexing the pixels

xcenter = xsize/2; ycenter = ysize/2; % center of the equilateral 
edge1 = 32*sqrt(2); % edge of the inner equilateral 
edge2 = 64*sqrt(2); % edge of the outer equilateral 

equilateral1px = abs((col - xcenter)) + abs((row - ycenter)) <= edge1;
equilateral2px = (abs((col - xcenter)) + abs((row - ycenter)) <= edge2) ... 
    & (abs((col - xcenter)) + abs((row - ycenter)) > edge1);

diamond(equilateral1px) =  192 + (-2 + 4*rand(1,sum(sum(equilateral1px))));
diamond(equilateral2px) =  128 + (-2 + 4*rand(1,sum(sum(equilateral2px))));
diamond_groundTruth =  ~(abs((col - xcenter)) + abs((row - ycenter))==floor(edge1) ...
               | abs((col - xcenter)) + abs((row - ycenter))==floor(edge2));


diamond_noisy = imnoise(diamond, 'gaussian', 0, 484/256^2);
figure(1); imshow(diamond); title('Original Image')
figure(2); imshow(diamond_noisy); title('Noisy Image')

% imwrite(diamond,'mydiamond.png');
% imwrite(diamond_noisy,'mynoisydiamond.png');
%% edge detection - LoG
sigma = 2; % in the class sigma is said to be 2
LoG_window = fspecial('LoG', sigma*6+1,sigma); % 6*sigma+1 by 6*sigma+1 filter window is used
gradient_window = [-1 -1 -1; -1 8 -1; -1 -1 -1];

diamond_LoG = imfilter(double(diamond), LoG_window,'replicate');
diamond_gradient = imfilter(double(diamond), gradient_window,'replicate');
diamond_noisy_LoG = imfilter(double(diamond_noisy), LoG_window,'replicate');
diamond_noisy_gradient = imfilter(double(diamond_noisy), gradient_window,'replicate');

diamond_edge_LoG = false(xsize,ysize);
rN = 2:xsize-1; cN = 2:ysize-1;
% searching for zero crossings of the LoG filter output horizontally and
% vertically.
[rind,cind] = find( diamond_LoG(rN,cN) < 0 & diamond_LoG(rN+1,cN) > 0);   % - -> + vertically
diamond_edge_LoG((rind+1) + cind*xsize) = 1;
[rind,cind] = find( diamond_LoG(rN-1,cN) > 0 & diamond_LoG(rN,cN) < 0);   % + -> - vertically
diamond_edge_LoG((rind+1) + cind*xsize) = 1;
[rind,cind] = find( diamond_LoG(rN,cN) < 0 & diamond_LoG(rN,cN+1) > 0);   % - -> + horizontally
diamond_edge_LoG((rind+1) + cind*xsize) = 1;
[rind,cind] = find( diamond_LoG(rN,cN-1) > 0 & diamond_LoG(rN,cN) < 0);   % + -> - horizontally
diamond_edge_LoG((rind+1) + cind*xsize) = 1;

diamond_edge_LoG = ~(diamond_edge_LoG & abs(diamond_gradient)>30); % weak gradients are eliminated



diamond_noisy_edge_LoG = false(xsize,ysize);
% searching for zero crossings of the LoG filter output horizontally and
% vertically. 
[rind,cind] = find( diamond_noisy_LoG(rN,cN) < 0 & diamond_noisy_LoG(rN+1,cN) > 0);   % - -> + vertically
diamond_noisy_edge_LoG((rind+1) + cind*xsize) = 1;
[rind,cind] = find( diamond_noisy_LoG(rN-1,cN) > 0 & diamond_noisy_LoG(rN,cN) < 0);   % + -> - vertically
diamond_noisy_edge_LoG((rind+1) + cind*xsize) = 1;
[rind,cind] = find( diamond_noisy_LoG(rN,cN) < 0 & diamond_noisy_LoG(rN,cN+1) > 0);   % - -> + horizontally
diamond_noisy_edge_LoG((rind+1) + cind*xsize) = 1;
[rind,cind] = find( diamond_noisy_LoG(rN,cN-1) > 0 & diamond_noisy_LoG(rN,cN) < 0);   % + -> - horizontally
diamond_noisy_edge_LoG((rind+1) + cind*xsize) = 1;

diamond_noisy_edge_LoG = ~(diamond_noisy_edge_LoG & abs(diamond_noisy_gradient)>30); % weak gradients are eliminated

figure(3); imshow(diamond_edge_LoG);  title('Edges of original image found by LoG')
figure(4); imshow(diamond_noisy_edge_LoG);  title('Edges of noisy image found by LoG')


%% edge detection - sobel & canny
diamond_edge_sobel = ~edge(diamond,'sobel');
diamond_noisy_edge_sobel = ~edge(diamond_noisy,'sobel');

figure(5); imshow(diamond_edge_sobel);  title('Edges of original image found by Sobel')
figure(6); imshow(diamond_noisy_edge_sobel);  title('Edges of noisy image found by Sobel')

diamond_edge_canny = ~edge(diamond,'canny');
diamond_noisy_edge_canny = ~edge(diamond_noisy,'canny');

figure(7); imshow(diamond_edge_canny);  title('Edges of original image found by Canny')
figure(8); imshow(diamond_noisy_edge_canny);  title('Edges of noisy image found by Canny')

%% edge detector performance 

edges_found = {diamond_edge_LoG diamond_edge_sobel diamond_edge_canny ...
    diamond_noisy_edge_LoG diamond_noisy_edge_sobel diamond_noisy_edge_canny}; 
EP = zeros(1,6);
for n = 1:6
    estimate_edge = edges_found{n}; % select which edge estimater to find its performance
    tot_EP = 0;
    nEdge = 0;
    for nR = 3:ysize-2
        for nC = 3:xsize-2
            if ~diamond_groundTruth(nR,nC)
                nEdge = nEdge +1;
                if ~estimate_edge(nR,nC)
                    tot_EP = tot_EP + 1;
                elseif any(estimate_edge(nR+(-2:2),nC) == diamond_groundTruth(nR+(-2:2),nC)) || ...
                        any(estimate_edge(nR,nC+(-2:2)) == diamond_groundTruth(nR,nC+(-2:2))) 
                    tot_EP = tot_EP + 0.5;
                end
            end
        end
    end
    EP(n) = tot_EP/nEdge;
end
