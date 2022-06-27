clc;clear

nsx = imread('scionFRS.jpg');
%createColorHistograms(frs)

%%
frs = imread('AcuraNSX.jpg');
%createColorHistograms(nsx)

%%
imshow(edge(rgb2gray(nsx),'canny'));
imshow(edge(rgb2gray(frs),'canny'));

%%
colormap hot
subplot(1,2,1)
nsxEdge = edge(rgb2gray(nsx), 'canny');
imagesc(hough(nsxEdge));

subplot(1,2,2)
frsEdge = edge(rgb2gray(frs), 'canny');
imagesc(hough(frsEdge));

%%
h = fspecial('gaussian', [90, 90], 2);
nsxBlur = imfilter(nsx, h);
imshow(nsxBlur);

[accum, circen, cirrad] = CircularHough_Grd(rgb2gray(nsx), [20, 40], ...
    80, 30, 1);

if any(cirrad <= 0)
    inds = find(cirrad>0);
    cirrad = cirrad(inds);
    circen = circen(inds,:);
end

imshow(rgb2gray(nsx));
hold on;
plot(circen(:,1), circen(:,2), 'r+');
for ii = 1 : size(circen, 1)
    rectangle('Position',[circen(ii,1) - cirrad(ii), circen(ii,2) - cirrad(ii), 2*cirrad(ii), 2*cirrad(ii)],...
        'Curvature', [1,1], 'edgecolor', 'b', 'linewidth', 1.5);
end
hold off;

