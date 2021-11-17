function Egs = bems_ann()
    x = [7685.321417	7533.188667	7520.718333	7688.434167	7355.185	7697.664167	7357.1775	7337.249417	7336.778	7383.8935	7194.59525	5629.90625];
    %disp(size(x));
    SOCmin = 9600*0.2;
    Maxav = x - SOCmin;
    Nd = [30 28 31 30 31 30 31 31 30 31 30 31];
    Pcont = 1800;
    Emax = Pcont*24*Nd;
    %disp(Emax);
    Estored = Maxav.*Nd;
    E = zeros(1,12);
    for i = 1:12
        j = i+2;
        if(j > 12)
            j = j - 12;
        end
        if(Estored(j) > Estored(i))
            if(Emax(i) > Estored(i))
                E(i) = Estored(i);
            else
                E(i) = Emax(i);
            end
        else
            if(Emax(i) > Estored(j))
                E(i) = Estored(j);
            else
                E(i) = Emax(i);
            end
        end
    end
    %disp(Estored);
    %disp(E);
    Egs = sum(E)/1000;
    
    %disp(sum(Estored));
    %disp(Egs);
end