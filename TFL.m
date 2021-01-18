function TFL()
Demand_mu(:,1) = xlsread('Book1.csv', 'A1:A11');
Demand_mu(:,2) = xlsread('Book1.csv', 'B1:B11');
Demand_mu(:,3) = xlsread('Book1.csv', 'C1:C11');
Mavg = [11.44636974	12.07263958	10.42969153];
X = xlsread('Book1.csv', 'D1:D11');
e = ones(11,1)*2.718281;
Tx(:,1) = 29.8*e.^(-Mavg(1)*X)+30.2;
Tx(:,2) = 29.8*e.^(-Mavg(2)*X)+30.2;
Tx(:,3) = 29.8*e.^(-Mavg(3)*X)+30.2;
plot(X,Tx(:,1));
csvwrite('TFL_data.csv',Tx);
