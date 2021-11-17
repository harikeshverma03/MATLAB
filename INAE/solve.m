function solve()
X = [1; 6; 0; 4];
Y = [1; 5; 4; 0];
C = [1 0 0;
    0 1 0;
    -1 -1 1];
B = [cosd(60) sind(60) 0;
    -sind(60) cosd(60) 0;
     0 0 1];
A = [1 0 0;
    0 1 0;
    1 1 1];
T = C*B*A; 
disp(T);
X = [2 3 1;
    5 5 1;
    4 3 1];
Xn = X*T;
disp(Xn);
M = [0.5^3 0.5^2 0.5 1];
X = 
% disp(size(A));
% disp(size(B));
% disp(size(X));

% P = A*B*X;
% Q = A*B*Y;
% disp(P);
% disp(Q);
end