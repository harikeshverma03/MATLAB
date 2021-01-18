function Solar = Data()
j = [1:31]';
f = [1:28]';
a = [1:30]';
month_31 = [j; j; j; j; j];
month_30 = [a; a; a; a; a];
month_28 = [f; f; f; f; f];
Solar(1:155,1:26) = [xlsread('Solar-Jan.csv','A1:EY24')' month_31 ones(155,1)];
Solar(156:295,1:26) = [xlsread('Solar-Feb.csv','A1:EJ24')' month_28 2*ones(140,1)];
Solar(296:450,1:26) = [xlsread('Solar-Mar.csv','A1:EY24')' month_31 3*ones(155,1)];
Solar(451:600,1:26) = [xlsread('Solar-April.csv','A1:ET24')' month_30 4*ones(150,1)];
Solar(601:755,1:26) = [xlsread('Solar-May.csv','A1:EY24')' month_31 5*ones(155,1)];
Solar(756:905,1:26) = [xlsread('Solar-Jun.csv','A1:ET24')' month_30 6*ones(150,1)];
Solar(906:1060,1:26) = [xlsread('Solar-Jul.csv','A1:EY24')' month_31 7*ones(155,1)];
Solar(1061:1215,1:26) = [xlsread('Solar-Aug.csv','A1:EY24')' month_31 8*ones(155,1)];
Solar(1216:1365,1:26) = [xlsread('Solar-Sep.csv','A1:ET24')' month_30 9*ones(150,1)];
Solar(1366:1520,1:26) = [xlsread('Solar-Oct.csv','A1:EY24')' month_31 10*ones(155,1)];
Solar(1521:1670,1:26) = [xlsread('Solar-Nov.csv','A1:ET24')' month_30 11*ones(150,1)];
Solar(1671:1825,1:26) = [xlsread('Solar-Dec.csv','A1:EY24')' month_31 12*ones(155,1)];
csvwrite('Solar-Monthly.csv',Solar);
end
%{
Solar(1:155,1:15) = [xlsread('Solar-Jan.csv','A7:EY19')' month_31 ones(155,1)];
Solar(156:295,1:15) = [xlsread('Solar-Feb.csv','A7:EJ19')' month_28 2*ones(140,1)];
Solar(296:450,1:15) = [xlsread('Solar-Mar.csv','A7:EY19')' month_31 3*ones(155,1)];
Solar(451:600,1:15) = [xlsread('Solar-April.csv','A7:ET19')' month_30 4*ones(150,1)];
Solar(601:755,1:15) = [xlsread('Solar-May.csv','A7:EY19')' month_31 5*ones(155,1)];
Solar(756:905,1:15) = [xlsread('Solar-Jun.csv','A7:ET19')' month_30 6*ones(150,1)];
Solar(906:1060,1:15) = [xlsread('Solar-Jul.csv','A7:EY19')' month_31 7*ones(155,1)];
Solar(1061:1215,1:15) = [xlsread('Solar-Aug.csv','A7:EY19')' month_31 8*ones(155,1)];
Solar(1216:1365,1:15) = [xlsread('Solar-Sep.csv','A7:ET19')' month_30 9*ones(150,1)];
Solar(1366:1520,1:15) = [xlsread('Solar-Oct.csv','A7:EY19')' month_31 10*ones(155,1)];
Solar(1521:1670,1:15) = [xlsread('Solar-Nov.csv','A7:ET19')' month_30 11*ones(150,1)];
Solar(1671:1825,1:15) = [xlsread('Solar-Dec.csv','A7:EY19')' month_31 12*ones(155,1)];
for m = 1:2
    if (m == 1 || m==3 || m==5 || m==7 || m==8 || m==10 || m==12)
        Solar(:,:,m) = [Solar(:,:,m) zeros(155,2)];
        for i = 1:31
            count = i;
            for j = 1:5 
            Solar(count,25) = i;
            count = count + 31;
            end
        end
    elseif (m ==2)
        Solar(:,:,m) = [Solar(:,:,m) zeros(140,2)];
        for i = 1:28
            count = i;
            for j = 1:5 
            Solar(count,25) = i;
            count = count + 28;
            end
        end
    else
        Solar(:,:,m) = [Solar(:,:,m) zeros(150,2)];
        for i = 1:30
            count = i;
            for j = 1:5 
            Solar(count,25) = i;
            count = count + 30;
            end
        end
    end
end
%}
