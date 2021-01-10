clear;
%% forming the edge map using canny detector
diamond = imread('mydiamond.png');
diamond_noisy = imread('mynoisydiamond.png');

diamond_edge_canny = edge(diamond,'canny');
diamond_noisy_edge_canny = edge(diamond_noisy,'canny');

%% original image
BW = diamond_edge_canny;

[H,T,R] = hough(BW, 'RhoResolution', 0.5, 'Theta', -90:0.5:90-0.5);
figure(1);imshow(H,[],'XData',T,'YData',R,...
            'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
title('Hough Transform of the image')

P  = houghpeaks(H,8,'threshold',ceil(0.2*max(H(:))));
x = T(P(:,2)); y = R(P(:,1));
plot(x,y,'s','color','white', 'linewidth', 1.3);

lines = houghlines(BW,T,R,P,'FillGap',5,'MinLength',7);
diamond_edge_canny(1,1)=1; diamond_edge_canny(end,end)=1;
figure(2), imshow(~diamond_edge_canny), hold on
title('The Hough lines')
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','red');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','blue');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','green');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end

%% noisy image
BW = diamond_noisy_edge_canny;

[H,T,R] = hough(BW, 'RhoResolution', 0.5, 'Theta', -90:0.5:90-0.5);
figure(3);imshow(H,[],'XData',T,'YData',R,...
            'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;
title('Hough Transform of the image')

P  = houghpeaks(H,8,'threshold',ceil(0.5*max(H(:))));
x = T(P(:,2)); y = R(P(:,1));
plot(x,y,'s','color','black', 'linewidth', 1.5);

lines = houghlines(BW,T,R,P,'FillGap',3,'MinLength',12);
figure(4), imshow(~diamond_noisy_edge_canny), hold on
title('The Hough lines')
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','red');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','blue');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','green');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      xy_long = xy;
   end
end