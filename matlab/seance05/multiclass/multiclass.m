clc; clear;

data1 = [1 2;
 2 2;
 2 1;
 1 1;
 3 1];

data2 = [4 5;
 5 5;
 7 5;
 5 4;
 7 5;
 6 6];

data3 = [10 12;
 14 12;
 11 11;
 12 12;
 11 12;
 13 11;
 14 13];


scatter(data1(:,1), data1(:,2), 100, 'sb');
hold all;
scatter(data2(:,1), data2(:,2), 100, 'sb');
scatter(data3(:,1), data3(:,2), 100, '^m');
hold off;

axis([0 15 0 15])


figure

allData=cat(1,data1,data2,data3);
[idx, centers] = kmeans(allData, 3);

colormap(lines(5))
scatter(allData(:,1), allData(:,2), 50, idx, 's')

hold on
scatter(centers(:,1), centers(:,2), 100, 'ko')
scatter(centers(:,1), centers(:,2), 100, 'rx')
hold off

title('Nuage de points Yomi')
xlabel('X')
ylabel('Y')
axis([0 15 0 15])
