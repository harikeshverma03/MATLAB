%%
%To verify the frequency using beam theory 
d = [1.875 4.694 7.885 10.99];
d = d.^2;
E = 2*10^11;
l = .45;
b = 0.05;
t = 0.005;
ro = 7800;
m = 0.785;
I = b*(t^3)./12;
A = b * t;
p = sqrt(E*I/(ro*A*l^4)) / (2*pi);

disp(p*d);