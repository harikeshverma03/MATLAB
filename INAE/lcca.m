function y = lcca()
    Nd = [30 28 31 30 31 30 31 31 30 31 30 31];
    D = 0; i = 0;e = 0.05; d = 0.025;g = 0.03;
    N = 25;
    Ndel = 10;
    Egs = bems_ann;
    disp(Egs);
    OM = 600;
    E = 2376*3  ;
    R = 34713;
    Esold = [464.728	-2055.86	-4516.284	-4551.862	-4411.476	-3796.392	-3106.72	-2901.93	-3019.416	-1675.64	-692.918	-2786.162];
    Esold = Esold.*Nd;
    Esold = sum(Esold)/1000;
    disp(Esold);
    PVreg = func.PVener(E,d,e,N) + func.PVmisc(OM,d,g,N);
    disp(PVreg);
    y = PVreg;
    PVenhanced = 248470 + func.PVrep(R,g,d,N,1) + func.PVabs(0,0,d,e,N) + func.PVgs1(Esold,3,d,g,N);
    disp(func.PVgs1(Esold,3,d,g,N));
    GSV = PVenhanced - PVreg;
    disp(GSV);
    disp(func.PVabs(Egs,1.5,d,e,N));
    y = func.PVgs(Egs,GSV,d,g,N);
end