clc; clear;
load('ex3data1.mat');

[h w ~] = size(X);
randIndex = randperm(h);

numTrain = round(h / 3 * 2);
%%
numTrainData = 3000; %[10, 50, 100, 200, 500, 1000, 2000];



f = fopen('digits.train', 'w');

for i = 1: numTrainData;
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
!cd /Users/luke/Dropbox/GTI660/Cours6
!pwd
!./svm_multiclass_learn -c 5000 digits.train

!./svm_multiclass_classify digits.test svm_struct_model output

%%
error(1) = 62.71;
error(2) = 36.63;
error(3) = 25.66;
error(4) = 22.36;
error(5) = 15.59;
error(6) = 12.59;
error(7) = 11.27;
error(8) = 10.25;


plot([10, 50, 100, 200, 500, 1000, 2000, 3000], error, '-o');
xlabel('Nombre d''''expériences (E)')
ylabel('% Erreur')
plot2svg('learning.svg')