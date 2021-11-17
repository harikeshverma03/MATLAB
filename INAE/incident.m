function theta = incident(N)
L = 13;   %Chennai Lattitude
Zs = 0;   %wall azimuth angle = 0 S-facing PVs for maximum power generation
B = 20;     %tilt angle
D = 23.45*sind((360*(284+N))/365);  %Declination Angle
h = -90:15:105;
for i = 1:14
    a = sind(L)*sind(D)*sind(B);
    b = cosd(L)*sind(D)*sind(B);
    c = cosd(L)*cosd(D)*cosd(B)*cosd(h(i));
    d = sind(L)*cosd(D)*cosd(h(i))*sind(B);
    
    temp = a +b +c+d;
    theta(i)= acosd(temp);
end