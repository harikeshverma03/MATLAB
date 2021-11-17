    Pb2l = zeros(49,1);
    Ppv2b = zeros(49,1);   
    Pg2b = zeros(49,1);
    Pg2l = zeros(49,1);
    sz = size(Pg);
    
    Eb(1) = Ebint;y = -1000;j = 1;
    while j ~= (sz(2)+1)
        y = -1000;
        while y(1) == -1000
            y = Priortization(Pd(1),Pb(1,j),Pg(1,j),EPTb,Cg(1),Eb(1));
            Ppv2b(1) = y(1);
            Pg2l(1) = y(2);
            Pb2l(1) = y(3); 
            Pg2b(1) = y(4);
            Pb1(1) = y(5);
            disp(y);j = j+1;count = count + 1;
        end
        disp(j);
        if (y(5) + y(6)) ~= -Pd(1)
            j = (sz(2)+1);
        end   
    end
    for i = 2:49
        Eb(i) = Eb(i-1) + Pb(i,j)
        j = 1;
        while j ~= (sz(2)+1)
        y = -1000;
        while y(1) == -1000
            Eb(i) = Eb(i-1) + Pb(i,j);
            y = Priortization(Pd(i),Pb(i,j),Pg(i,j),EPTb,Cg(1),Eb(i));
            Ppv2b(i) = y(1);
            Pg2l(1) = y(2);
            Pb2l(1) = y(3); 
            Pg2b(1) = y(4);
            Pb1(1) = y(5);
            disp(y);j = j+1;count = count + 1;
        end
        disp(j);
        if (y(5) + y(6)) ~= -Pd(1)
            j = (sz(2)+1);
        end   
        end
    end
    
    
    
    
    
    
     sz = size(Pb1);
    for j = 1:sz(2)
        Eb(1,j) = Ebint - Pb1(1,j)*0.5;
        if(Pb1(1,j) < 0)
            EPT(1,j) = (EPTb*Ebint + Pg2b(1,j)*0.5*Cg(1))/(Eb(1,j));
        else
            EPT(1,j) = EPTb;
        end
        for i = 2:49
            Eb(i,j) = Eb(i-1) - Pb1(i,j)*0.5;
            if(Pb1(i,j) < 0)
                EPT(i,j) = (EPT(i-1)*Eb(i-1)+Pg2b(i,j)*0.5*Cg(i))/(Eb(i,j));
%                 disp(EPT(i,j));
            else
                EPT(i,j) = EPT(i-1);
        end
        end
    end
    
    
    
    
    
    
    function [z,alloc] = bems(n,t)
    Pl = xlsread('load.csv', 'A1:X1');
    Ppv = xlsread('solar_perm2.csv', 'A1:X1');
    Ppv = Ppv.*8;
    Pd = Ppv - Pl;
    %Cg = xlsread('data.csv', 'C1:C49');
    Cg = ones(1,24) * 1.5;
    SOCbmin = 0.2;SOCbmax = 0.8;
    SOCint = 0.6;SOCfin = 0.6;
    Bcap = 300;
    EPTb = 2;
    
    Ebint = SOCint*Bcap;
    Ebfin = SOCfin*Bcap;
    Pmax = 100; Pmin = -100;
    %Generate Initial Population of Pg, Pb and Selected Points based on operational constraints
    Pg = zeros(t,10);
    Pb = zeros(t,10);
    for i = 1:t
        count = 1;
        for j = 0:0.1:(-Pd(i)+Pmax)
            Pg(i,count) = j;
            Pb(i,count) = -Pd(i) - j;
            count = count+1;
        end
        %disp(Pd);
    end
    sz = size(Pb);
%    disp(Pg);
%    disp(Pb(:,1));
    %Basic structure of the priotization algorithm
    %case-1,6,13 infeasible due to no PEV
    EPT = ones(1,t)*EPTb;
    j = ones(1,t);
    for it = 1:n
%         disp(EPT);
        Pb2l = zeros(t,1);
        Ppv2b = zeros(t,1);   
        Pg2b = zeros(t,1);
        Pg2l = zeros(t,1);
        Eb = zeros(1,t);
        Eb(1) = Ebint;y = -1000;
        while (y(1) == -1000) 
            y = Priortization(Pd(1),Pb(1,j(1)),Pg(1,j(1)),EPT(1),Cg(1),Eb(1));
                if (y(1) == -1000)
                else
                    Ppv2b(1) = y(1);
                    Pg2l(1) = y(2);
                    Pb2l(1) = y(3); 
                    Pg2b(1) = y(4);
                    Pb1(1) = y(5);
                end
                j(1) = j(1)+1;count = count + 1;
                if(j(1) > sz(2))
                   j(1) = 1;
                end
        end  
        
        for i = 2:t
            y = -1000;
            count = 1;
            while y(1) == -1000
                Eb(i) = Eb(i-1) - Pb(i,j(i));
                y = Priortization(Pd(i),Pb(i,j(i)),Pg(i,j(i)),EPT(i),Cg(i),Eb(i));
                if (y(1) ~= -1000)
%                   disp(y);disp(Eb(i));
                    Ppv2b(i) = y(1);
                    Pg2l(i) = y(2);
                    Pb2l(i) = y(3); 
                    Pg2b(i) = y(4);
                    Pb1(i) = y(5);
                end
                j(i) = j(i)+1;count = count + 1;
                if(j(i) > sz(2))
                   j(i) = 1;
                end
                if (count == sz(2))
                    break;
                end
            end 
        end
%         disp(Pb1);
%         disp(-(Pd'+Pb1));
    %     disp(Pb);
    %     disp(Ppv2b + Pg2b);
    %     disp(Pb2l);
    %      disp(Pb1)
        %Calculate EPT
        
            if(Pb1(1) < 0)
                EPT(1) = (EPTb*Ebint + Pg2b(1)*0.5*Cg(1))/(Eb(1));
            else
                EPT(1) = EPTb;
            end
            for i = 2:t
                if(Pb1(i) < 0)
                    EPT(i) = (EPT(i-1)*Eb(i-1)+Pg2b(i)*0.5*Cg(i))/(Eb(i));
    %                 disp(EPT(i,j));
                else
                    EPT(i) = EPT(i-1);
                end
            end
    %      disp(Eb);disp(EPT);
        %Compute objective function
        Cf = zeros(1,t*2+1);
        Cf(1) = Cg(1);
        Cf(2) = EPTb-Cg(1);
        for i = 1:t-1
            Cf(i*2+1) = Cg(i+1);
            Cf(i*2+2) = EPT(i)-Cg(i+1); 
        end
%         disp(Cf);disp(Cg');
        %Upper and Lower Bounds
        Up = zeros(1,t*2+1);
        Low = zeros(1,t*2+1);
        Up(t*2+1) = Ebfin+0.28;
        Low(t*2+1) = Ebfin-0.28;
        for i = 1:t
            Up((i-1)*2 + 1) =  max(Pl)+Pmax*0.5;
            Up((i-1)*2 + 2) = Pmax*0.5;
            Low((i-1)*2 + 1) = 0;
            Low((i-1)*2 + 2) = Pmin*0.5;
        end
        %Creating Constraints
        Cnstrns = zeros(t*2-2,t*2+1);
        for i = 1:t
            Cnstrns(i,(i-1)*2 + 1) = 1;
            Cnstrns(i,(i-1)*2 + 2) = 1;
        end
        for i = t+1:t*2-1
            Cnstrns(i,t*2+1) = 1;
            for p = 1:i-(t-1)
                Cnstrns(i,(p-1)*2 + 2) = -1;
            end
        end
        for i = t*2:t*3-2
            Cnstrns(i,t*2+1) = 1;
            for p = 1:i-(t*2-2)
                Cnstrns(i,(p-1)*2 + 2) = -1;
            end
        end
%         disp(Cnstrns);
        %Creating RHS
        RHS = zeros(t,1);
        for i = 1:t
            RHS(i,1) = abs(Ppv(i) - Pl(i))*0.5;
        end
        for i = t+1:t*2-1
            RHS(i,1) = SOCbmax*Bcap;
        end
        for i = t*2:t*2-3
            RHS(i,1) = SOCbmin*Bcap;
        end
        RHS(t*3-2,1) = Ebint;
    %     disp(RHS);
    %     %Sense
        sense1 = '=';
        for i = 1:t-1
            sense1 = strcat(sense1,'=');
        end
        for i = 1:t-1
            sense1 = strcat(sense1,'<');
        end
        for i = 1:t-2
            sense1 = strcat(sense1,'>');
        end
        sense1 = strcat(sense1,'=');
%         disp(sense1);
%         disp(size(sense1));
        %Stochastic Fractal Search
        model.A = sparse(Cnstrns);
        model.obj = Cf;
        model.rhs = RHS;
        model.sense = sense1;
        model.ub = Up;
        model.modelsense = 'min';
        model.lb = Low;
        params.outputflag = 0;
        result = gurobi(model,params);
        y = result;
%          disp(y);
        disp(y.objval);
        
        z(it) = y.objval;
        for i = 1:t
            alloc(1,i,it) = y.x((i-1)*2+1);
            alloc(2,i,it) = y.x((i-1)*2+2);
            alloc(3,i,it) = abs(Ppv(i) - Pl(i))*0.5;
            alloc(4,i,it) = Ppv(i);
            alloc(5,i,it) = Pl(i);
            alloc(6,i,it) = Eb(i);
        end
    end
    csvwrite('bems.csv',alloc);
%     disp(z);
    csvwrite('bems1.csv',z);
    E1 = 0;
    E2 = 0;
end
