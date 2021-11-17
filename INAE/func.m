classdef func
    methods(Static)
        function y = PVsys(D,I,C,d,i,Ndel)
            x = (1-D) * I*C *(func.PVF(d,0,Ndel)/ func.PVF(i,0,Ndel));
            y = D + I*C + x;
        end
        function y = PVF(d,g,N)
            y = (1/(d-g))*(1-((1+g)/(1+d))^N);
        end
        function y = PVmisc(OM,d,g,N)
            y = OM*func.PVF(d,g,N);
        end
        function y = PVener(E,d,e,N)
            y = E*func.PVF(d,e,N);
        end
        function y = PVrep(R,g,d,N,r)
            sum = 0;
            for k = 1:r
                x = ((1+g)/(1+d))^(N*k/(r+1));
                sum = sum + x;
            end
            y = (R/(1+g))*sum;
        end 
        function y = PVint(D,IC,d,i,Nd,N)
            N1 = min([N Nd]);
            x = (func.PVF(d,0,N1)/func.PVF(d,0,N));
            z = (1-(1/func.PVF(i,0,N)));
            y = ((1-D)*IC*(func.PVF(d,i,N1)*z+x));
        end
        function y = PVitc(I,D)
            y = I/(1+D);
        end
        function y = PVabs(Eabs, C, d, e, N)
            y = Eabs * C * func.PVF(d,e,N);
        end
        function y = PVgs(Egs,PVgs, d, g, N)
            y = PVgs / (Egs  * ((1+g)^(N-1)/(1+d)^N));
        end
        function y = PVgs1(Egs,A, d, g, N)
            y = (Egs  * A* ((1+g)^(N-1)/(1+d)^N));
        end

    end 
end
      