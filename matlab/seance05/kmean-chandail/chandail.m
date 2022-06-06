longeur = [41, 40, 36, 34, 38, 45, 43, 35, 44];
tour =    [30, 29, 28, 28, 29, 32, 31, 27, 31];

[classes, centroid] = kmeans([longeur; tour]', 3);

scatter(longeur, tour, 50);
hold on 
scatter(centroid(:,1), centroid(:,2), 200, 'kx');
scatter(centroid(:,1), centroid(:,2), 200, 'ko');
hold off
title('Taille de Chandails')
xlabel('Longueur');
ylabel('Tour de taille');
axis([32 46 26 34])

