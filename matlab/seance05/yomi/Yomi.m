data = [1066, 2253;
920, 1986;
833, 1672;
836, 1613;
706, 1483;
786, 1430;
702, 1405;
712, 1329;
651, 1220;
482, 992];

playedGames = data(:,2) ./ max(data(:,2));
wins = data(:,1) ./ data(:,2);
wins = wins ./ max(wins);


[idx, centers] = kmeans([wins, playedGames], 3);

colormap(lines(5))
scatter(wins, playedGames, 50, idx, 's')

hold on
scatter(centers(:,1), centers(:,2), 100, 'ko')
scatter(centers(:,1), centers(:,2), 100, 'rx')
hold off

title('Nuage de points Yomi')
xlabel('Victoires (normalisée)')
ylabel('Popularité (normalisée)')
axis([0.84 1.01 0.4 1.02])
