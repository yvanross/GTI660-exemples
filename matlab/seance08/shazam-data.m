

data = round(rand(10, 3) * 4000)

data(11:20, 1:3) = data(1:10, 1:3)

data(1, 4) = 57;
data(2, 4) = 51;
data(3, 4) = 54;
data(4, 4) = 56;
data(5, 4) = 53;
data(6, 4) = 54;
data(7, 4) = 55;
data(8, 4) = 59;
data(9, 4) = 52;
data(10, 4) = 55;


requete = data(1:10, 1:3);
requete(1, 4) = 7;
requete(2, 4) = 1;
requete(3, 4) = 4;
requete(4, 4) = 6;
requete(5, 4) = 3;
requete(6, 4) = 7;
requete(7, 4) = 5;
requete(8, 4) = 9;
requete(9, 4) = 5;
requete(10, 4) = 2;

data(11, 4) = 51;
data(12, 4) = 54;
data(13, 4) = 58;
data(14, 4) = 52;
data(15, 4) = 58;
data(16, 4) = 59;
data(17, 4) = 51;
data(18, 4) = 48;
data(19, 4) = 49;
data(20, 4) = 50;

data(1:10, 5) = 1;
data(11:20, 5) = 2;

data(:, 4:5)

clf;
plot(data(1:10, 4), requete(1:10, 4), 'o')
hold all
plot(data(11:20, 4), requete(1:10, 4), 's')
hold off
grid on
axis([48 62 0 10])
set(gca,'XTick',45:65)
xlabel('Temps segment')
ylabel('Temps échantillon')

legend({'1', '2'})
