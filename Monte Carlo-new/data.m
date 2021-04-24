function data()
Hydro_in = xlsread('Hydro_Alloc_dyn.csv');
size(Hydro_in)
j = 1;
for i = 1:4:16384
    sum1(:,j) = Hydro_in(:,i+1) + Hydro_in(:, i+2) + Hydro_in(:, i+3);
    j = j+1;
end
csvwrite('test.csv', sum1);
x = zeros(3,13);
x(1,:) = prctile(sum1', 97.5);
x(2,:) = mean(sum1');
x(3,:) = prctile(sum1', 2.5);
csvwrite('Hydro_final.csv',x');
disp(prctile(sum1', 97.5));
disp(mean(sum1'));
disp(prctile(sum1', 2.5));
hist(sum1(2,:),100)
end