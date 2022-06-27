clc; clear;
load('ex3data1.mat');

[h w ~] = size(X);
randIndex = randperm(h);

numTrain = round(h / 3 * 2);

f = fopen('digits.train', 'w');

for i = 1: numTrain;
   idx = randIndex(i);
   fprintf(f, '%d', y(idx)); 
   for j = 1:w
       fprintf(f, ' %d:%f', j, X(idx,j));
   end
   fprintf(f, '\n');
end

fclose(f);


f = fopen('digits.test', 'w');

for i = numTrain: h;
   idx = randIndex(i);
   fprintf(f, '%d', y(idx)); 
   for j = 1:w
       fprintf(f, ' %d:%f', j, X(idx,j));
   end
   fprintf(f, '\n');
end

fclose(f);