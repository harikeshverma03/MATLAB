function fit = DeJong(x)
    EPT = xlsread('data.csv', 'D1:D49');
    Cg = xlsread('data.csv', 'C1:C49');
    EPTb = 3.5;
    Cf = zeros(1,98);
    Cf(1) = Cg(1);
    Cf(2) = EPTb-Cg(1);
    for i = 2:48
        Cf(i*2+1) = Cg(i);
        Cf(i*2+2) = EPT(i,1)-Cg(i); 
    end
    fit=sum(Cf.*x);
    end
