function panelA()
    dem = 4393*365;
    year = [30 28 31 30 31 30 31 31 30 31 30 31];
    solarE = xlsread('solar_perm2.csv');
    solarY = sum(solarE');
    solarY = solarY'.*year';
    solar = sum(solarY);
    disp(dem/solar);
%     disp(solar);
%     disp(solarY);
end