%% Histogram Flattening and Matching

% reading the images
A = imread('subject1_photo2.jpg');
B = imread('subject1_photo3.jpg');
C = imread('subject1_photo1.jpg');
D = imread('subject2_photo1.jpg'); 

% applying the equalization 
eqA = histEqu_part3(A);
eqB = histEqu_part3(B);
eqC = histEqu_part3(C);
eqD = histEqu_part3(D);

% applying the matching with A
matA = imgMatch(A,A);
matB = imgMatch(B,A);
matC = imgMatch(C,A);
matD = imgMatch(D,A);

% histogram distances
% chi-square distance
chi_disA = zeros(3,4);

% distance between orginal A and A B C D, respectively
chi_disA(1,1)=chi_dis(A,A);
chi_disA(1,2)=chi_dis(A,B);
chi_disA(1,3)=chi_dis(A,C);
chi_disA(1,4)=chi_dis(A,D);

% distance between orginal A and A B C D, respectively
chi_disA(2,1)=chi_dis(A,eqA);
chi_disA(2,2)=chi_dis(A,eqB);
chi_disA(2,3)=chi_dis(A,eqC);
chi_disA(2,4)=chi_dis(A,eqD);

% distance between orginal A and A B C D, respectively
chi_disA(3,1)=chi_dis(A,matA);
chi_disA(3,2)=chi_dis(A,matB);
chi_disA(3,3)=chi_dis(A,matC);
chi_disA(3,4)=chi_dis(A,matD);

% Kullback-Leibler distance
kuLe_disA = zeros(3,4);

% distance between orginal A and A B C D, respectively
kuLe_disA(1,1)=kuLe_dis(A,A);
kuLe_disA(1,2)=kuLe_dis(A,B);
kuLe_disA(1,3)=kuLe_dis(A,C);
kuLe_disA(1,4)=kuLe_dis(A,D);

% distance between orginal A and A B C D, respectively
kuLe_disA(2,1)=kuLe_dis(A,eqA);
kuLe_disA(2,2)=kuLe_dis(A,eqB);
kuLe_disA(2,3)=kuLe_dis(A,eqC);
kuLe_disA(2,4)=kuLe_dis(A,eqD);

% distance between orginal A and A B C D, respectively
kuLe_disA(3,1)=kuLe_dis(A,matA);
kuLe_disA(3,2)=kuLe_dis(A,matB);
kuLe_disA(3,3)=kuLe_dis(A,matC);
kuLe_disA(3,4)=kuLe_dis(A,matD);

% showing the original images
figure(1)
subplot(2,2,1)
imshow(A);
subplot(2,2,2)
imshow(B);
subplot(2,2,3)
imshow(C);
subplot(2,2,4)
imshow(D);

% showing the equalized images
figure(2)
subplot(2,2,1)
imshow(eqA);
subplot(2,2,2)
imshow(eqB);
subplot(2,2,3)
imshow(eqC);
subplot(2,2,4)
imshow(eqD);

% showing the matched images with A
figure(3)
subplot(2,2,1)
imshow(matA);
subplot(2,2,2)
imshow(matB);
subplot(2,2,3)
imshow(matC);
subplot(2,2,4)
imshow(matD);
