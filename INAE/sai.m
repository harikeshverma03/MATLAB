function sai
Kval = [1.8751, 4.6941];
K1val = [1.8751, 4.6941];
Rval = [0.734, 1.0018];
R1val = [0.734, 1.0018];
% X = 0:0.01:1;
for i = 1:2
    for j = 1:2
        K = Kval(i); K1 = K1val(j);
        R = Rval(i); R1 = R1val(j);
        S = @(X) (cosh(K .* X).*(cosh(K1 .* X) - cos(K1 .* X) - R1.*(sinh(K1 .* X) - sin(K1 .* X))) - cos(K .* X).*(cosh(K1 .* X) - cos(K1 .* X) - R1.*(sinh(K1 .* X) - sin(K1 .* X)))- R.*(sinh(K .* X).*(cosh(K1 .* X) - cos(K1 .* X) - R1.*(sinh(K1 .* X) - sin(K1 .* X)))- sin(K .* X).*(cosh(K1 .* X) - cos(K1 .* X) - R1.*(sinh(K1 .* X) - sin(K1 .* X)))));
        disp(i); disp(j);
        q = integral(S,0,1);
        disp(q);
    end
end
X = 0:0.01:1;
Y = -X.*(X.*X.*X - 2.*X.*X + 1);
plot(X,Y);


end