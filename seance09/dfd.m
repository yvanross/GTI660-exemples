f1 = imread('Frame1.png');
f2 = imread('Frame2.png');

imwrite(imabsdiff(f1(1:260,1:247,:), f2(1:260, 1:247,:)), 'dfd.png');