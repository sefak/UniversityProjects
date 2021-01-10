%% Hough transform
theta_res = 5; % 5 degree resolution
rho_res = 8; % rho resolution, rho is the distance from origin

theta = -90:5:90;
theta_size = length(theta);

max_distance = sqrt((r_size-1)^2 + (c_size-1)^2);
max_q = ceil(max_distance/rho_res);
rho = (-max_q:max_q)*rho_res; % rho_size = 2*max_q - 1;linspace(-max_q*rho_res, max_q*rho_res, rho_size);
rho_size = length(rho);

[x, y, val] = find(diamond); % extrating the indices of the image as a row vector
x = x - 1; y = y - 1;

diamond_h = zeros(rho_size,theta_size);
for nT = 1:theta_size
    temp = x.*cos(theta(nT)/180*pi)+y.*sin(theta(nT)/180*pi);
    [~,ind] = min(abs(temp'-rho')); % nearest rho value is found
    %ind = unique(ind);
    for n = 1:length(ind)
       diamond_h(ind(n),nT) = diamond_h(ind(n),nT) + 1;
    end
end
%%
figure; imshow((diamond_h),[],'XData',theta,'YData',rho,...
            'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;