classdef func
    methods(Static)
        function y = Vt(V,I,C,H,S)
            y = V + I - H./C - S;
        end
        function y = Cp(Hp,FRL,MDDL)
            y = Hp./(FRL - MDDL);
        end
        function y = sumation (x)
            y = 0;
            for i = 1:length(x)
                y=y+x(i);
            end
        end
        function [y,z] = Alloc_dynamic(res_dynamic,t1,p)
            Alloc_dynamic = zeros(t1+1,p+1);
            sum = zeros(1,t1);
            for i = 1:p
                Alloc_dynamic(1,1+i) = i;
            end
            for i = 1:t1
                Alloc_dynamic(1+i,1) = i;
            end
            w=2;
            for i=1:t1
                for j =1:p
                    Alloc_dynamic(1+i,1+j) = res_dynamic(w);
                    sum(i) = sum(i) + res_dynamic(w);
                    w=w+1;
                end
                w = 2 + (1+2*p)*i;
            end
            y = Alloc_dynamic;
            z = sum;
        end
        function Cost = Cost(Dem_cost)
            Cost = zeros(1,12);
            for  i = 1:12
         if Dem_cost(i) >= 669.6 && Dem_cost(i) <= 1129
             Cost(i) = (2131.8 + (Dem_cost(i)-669.6)*4.15)/Dem_cost(i);
         elseif Dem_cost(i) >= 1129 && Dem_cost(i) <= 1489
                 Cost(i) = (3625.8 + (Dem_cost(i)-1029)*10.76)/Dem_cost(i);
         elseif Dem_cost(i) >= 1489 && Dem_cost(i) <= 1630
             Cost(i) = (7499.4 + (Dem_cost(i)-1489)*14.18)/Dem_cost(i);
         else 
             Cost(i) = 6.030;
          end
            end
        end
        function y = value(C,D,E,H)
            t = 0;
            if t == 13
                y(13) = 0;
                return;
            end
            y(t) = C(t)*(D(t)- k*E(t) - func.sumation(H(t,:))) + y(t+1);
        end
        function [x,y,z] = Alloc_linear(res_linear,t,n)
                    Alloc_linear = zeros(t+1,3+2*n);
                    sum_reg = zeros(1,t);
                    sum_hol = zeros(1,t);
                    for i = 1:n
                        Alloc_linear(1,1+i) = i;
                        Alloc_linear(1,1+i+n) = i;

                    end
                    Alloc_linear(1,2+2*n) = 1;
                    Alloc_linear(1,3+2*n) = 1;
                    for i = 1:t
                        Alloc_linear(1+i,1) = i;
                    end
                    w = 1;h= 1+n*t;
                    for i=1:t
                        for j =1:n
                            Alloc_linear(1+i,1+j) = res_linear(w);
                            Alloc_linear(1+i,1+j+n) = res_linear(w+t*(n+2));
                            sum_reg(i) = sum_reg(i) + res_linear(w);
                            sum_hol(i) = sum_hol(i) + res_linear(w+t*(n+2));
                            w=w+t;
                        end
                        Alloc_linear(1+i,2+2*n) = res_linear(h);
                        Alloc_linear(1+i,3+2*n) = res_linear(h+t*(n+2));
                        h=h+1;
                        w=1+i;
                    end
                    x = Alloc_linear;
                    y = sum_reg;
                    z = sum_hol;
        end
        function y = linear_stage(Day, Cost,Cost_imp,Demand,Hydro_cap, Thermal_cap,Hydro_avg,Ramp_Rate,Sol_E,n,t,Beta)
            %day = 1*2 matrix for no. of holidays and regular days
            %cost is a 1*n matrix for per power plant
            %demand is a t*2 matrix for demand in holiday and typical day
            %cost_imp is a 1*1 matrix for cost of import
            %Hydro_cap is a 1*1 matrix for hydro capacity of the hour
            %Thermal_cap = 1*n matrix for n power plants
            %Hydro_avg 1*1 matrix for hydro capacity of the month
            %Ramp_Rate = 1*n matrix for hourly ramp rate of n power plants
            %Sol_E = t*2 matrix for solar radiance per hour in hoiday and normal day
            %n = no. of thermal plants 
            %t = no. of stages for which the calculation needs to be done(for day =24)
            %Allocating Memory and variable
            Davg = Demand - Beta*Sol_E;
            ub = zeros(1,2*t*(n+2));
            lb = zeros(1,2*t*(n+2));
            Obj = zeros(1,2*t*(n+2));
            Cnstrns = zeros(1+(4*n*(t-1)+4*t),2*t*(n+2));
            RHS = zeros(1+(4*n*(t-1)+4*t),1);
            %creating objective matrix
            w = 1;
            for i = 1:n
                for j = 1:t
                    Obj(1,w) = Day(1)* (Cost(i) - Cost_imp);
                    Obj(1,w+t*(n+2)) = Day(2)*(Cost(i) - Cost_imp);
                    w = w+1;
                end
            end
            for i = 1:t
                Obj(1,w) = -Day(1)*Cost_imp;
                Obj(1,w+t*(n+2)) = -Day(2)*Cost_imp;
                w=w+1;
            end
            for i = 1:t
                Obj(1,w) = Day(1)*Cost_imp;
                Obj(1,w+t*(n+2)) = Day(2)*Cost_imp;
                w = w+1;
            end

            %creating constrains matrix
            w = 1 + t*(n);
            for i =1:t %for 1st constrain
                Cnstrns(1,w) = 1*Day(1);
                Cnstrns(1,w+t*(n+2)) = 1*Day(2);
                w=w+1;
            end
            inc = 2;
            w=0;h = t*(n+2);
            for i = 1:n %for 2 - 4*t*n+1
                w = w+1;h = h+1;
                for j = 1:t-1
                Cnstrns(inc,w) = -1;Cnstrns(inc,w+1) = 1; %for regular day
                Cnstrns(inc+(t-1)*n,w) = 1;Cnstrns(inc+(t-1)*n,w+1) = -1;%for regular day
                Cnstrns(inc+((t-1)*n)*2,h) = -1;Cnstrns(inc+((t-1)*n)*2,h+1) = 1;%for holiday
                Cnstrns(inc+((t-1)*n)*3,h) = 1;Cnstrns(inc+((t-1)*n)*3,h+1) = -1;%for holiday
                w = w+1; h=h+1;
                inc = inc+1;
                end
            end
            w=1;h=1;inc = 2+4*n*(t-1);
            for i = 1:t %for 4*(t-1) +1-4*(t-1)+2*t
                Cnstrns(inc,w+n*t) = -1;
                Cnstrns(inc,w+t*(n+1)) = 1;
                for j = 1:n 
                    Cnstrns(inc,h) = -1;
                    h =  h+t;
                end
                h=w;
                Cnstrns(inc+t,w+t*(2*n+2)) = -1;
                Cnstrns(inc+t,w+t*(2*n+3)) = 1;
                for j = 1:n 
                    Cnstrns(inc+t,h+t*(n+2)) = -1;
                    h =  h+t;
                end
                w = w+1;inc = inc+1;
                h=w;
            end
            inc = 2+(4*n*(t-1)+2*t);
            w = 1+t*(n+1);
            for i = 1:t
                 Cnstrns(inc,w) = 1;
                 Cnstrns(inc+t,w+t*(n+2)) = 1;
                 w =w+1;inc = inc+1;
            end
            %creating RHS matrix
            RHS(1,1) = Hydro_avg;
            w=2;
            for i = 1:n
                for j = 1:t-1
                     RHS(w,1) = Ramp_Rate(i);
                     RHS(w+n*(t-1),1) = Ramp_Rate(i);
                     RHS(w+2*n*(t-1),1) = Ramp_Rate(i);
                     RHS(w+3*n*(t-1),1) = Ramp_Rate(i);
                     w=w+1;
                end
            end
            w = 2+(4*n*(t-1)+2*t);
            for i = 1:2
                for j = 1:t
                    RHS(w,1) = Davg(j,i);
                     w =w+1;
                end
            end
            %creating bounds
            w = 1;h=1;
            %upper bounds 
            for i= 1:t
                ub(1,w+n*t) = Hydro_cap/1000;                  lb(1,w+n*t) = 0;
                ub(1,w+t*(n+1)) = 10;           lb(1,w+t*(n+1)) = 0;
                ub(1,w+t*(n)+t*(n+2)) = Hydro_cap/1000;   lb(1,w+t*(n+1)+t*(n+2)) = 0;
                ub(1,w+t*(n+1)+t*(n+2)) = 10;
                for j = 1:n
                    ub(1,h) = Thermal_cap(j)/1000;           lb(1,h) = 0.1*Thermal_cap(j)/1000;
                    ub(1,h+t*(n+2)) = Thermal_cap(j)/1000;   lb(1,h+t*(n+2)) = 0.1*Thermal_cap(j)/1000;
                    h = h+t;
                end
                w=w+1;h=w;
            end
            %creating sense
            sense1 = '=';
                for i = 1:4*(t-1)*n
                    sense1 = strcat(sense1,'<');
                end 
                for i = 1:2*t
                    sense1 = strcat(sense1,'>');
                end
                for i = 1:2*t
                    sense1 = strcat(sense1,'=');
                end
            %creating structure according to gurobi
            model.A = sparse(Cnstrns);
            model.obj = Obj;
            model.rhs = RHS;
            model.sense = sense1;
            model.ub = ub;
            model.modelsense = 'min';
            model.lb = lb;
            params.outputflag = 0;
            result = gurobi(model,params);
            %{
            % for result matrix
            res = result.x';
            %disp(res);
            Alloc = zeros(t+1,1+2*n);
            for i = 1:n
                Alloc(1,1+i) = i;
                Alloc(1,1+i+n) = i;
            end
            for i = 1:t
                Alloc(1+i,1) = i;
            end
            w = 1;
            for i=1:t
                for j =1:n
                    Alloc(1+i,1+j) = res(w);
                    Alloc(1+i,1+j+n) = res(w+t*(n+2));
                    w=w+t;
                end
                w=1+i;
            end
            %}
             y = result;

        end
        function y = dynamic_stage(Cost,Dem,Sol_E,Beta,Vol_1,Rain,MDDL,FRL,Hp,t,p,Avg)
            %Here we are solving a dynamic programming problem in the 
            %form of a linear problem using gurobi solver
            %Dem = 1*t matrix for demand in t stages
            %Cost = 1*t matrix for cost in t stages
            %Sol_E = 1*t matrix for solar radiance in t stages
            %Beta = fraction of solar PV array
            %Vol_1 = 1*1 matrix for the volume at the start of 1st stage
            %Rain = t*p matrix for the incoming water due to rainfall - spillway discharge for p plant in t stage
            %MDDL = 1*p matrix for Min. draw down level of p plant
            %FRL = 1*p matrix for full reservoir level of p plant
            %t = No. of stages for which we want to solve
            %p = no. of hydro plants available
            %Avg = Average generation in last five years
            Davg = Dem -Beta*Sol_E;
            Cp = Hp./(FRL-MDDL);
            %Allocating Memory and variable
            Cnstrns = zeros((3*t*p+1+t),(1+2*p)*t);
            ub = zeros(1,(1+2*p)*t);
            lb = zeros(1,(1+2*p)*t);
            Obj = zeros(1,(1+2*p)*t);
            RHS = zeros((3*t*p+t+1),1);
            w = 1; inc = 1;
            %creating objective matrix
            for i = 1:t % for Objective Function
                Obj(1,w)= Cost(i);
                w=w+1;
                for j = 1:p
                    Obj(1,w)= -Cost(i);
                    w=w+1;
                end
                w = 1+(1+2*p)*i;
            end
            w = 2;

            %creating constrain matrix
            for i = 1:t % for Constrain Matrix(1)-(24*p)
                for j = 1:p
                    Cnstrns(inc,w) = 1;
                    Cnstrns(inc,w+p) = -Cp(j); 
                    Cnstrns(inc+(t*p),w) = -1;
                    Cnstrns(inc+(t*p),w+p) = 0.1*Cp(j);
                    w = w+1; inc = inc+1;
                end
                 w = 2+(1+2*p)*i;
            end
            inc = inc + (t*p);
            w=2;
            for i = 1:p
                Cnstrns(inc,w+p) = 1;
                inc = inc + 1;
                w = w+1;
            end
            w =2;
            for i = 1:t-1 % for Constrain Matrix (1+24*p)-(36*p) 
                for j = 1:p
                    Cnstrns(inc,w+(3*p+1)) = 1;
                    Cnstrns(inc,w+p) = -1;
                    Cnstrns(inc,w) = 1/Cp(j);
                    w = w+1; inc = inc+1;
                end
                 w = 2+(1+2*p)*i;
            end
            w =1;
            for i = 1:t % for Constrain (36*p)+12
                Cnstrns(inc, w) = 1;
                w = 1 + (1+2*p)*i;
                inc = inc+1;
            end
            w = 2;
            for i =1:t %for Constrain (36*p)+13
                for j =1:p
                    Cnstrns(inc,w) = 1;
                    w = w+1;
                end
                w = 2+(1+2*p)*i;
            end
            inc = 1;

            %creating RHS matrix
            for i= 1:t %for RHS 1-36*p
                for j = 1:p
                    RHS(inc,1) = -Cp(j)*MDDL(j);
                    RHS(inc+t*p,1) = 0.1*Cp(j)*MDDL(j);
                    RHS(inc+2*t*p,1) = Rain(i,j);
                    inc = inc+1;
                end
            end
            inc = 3*t*p +1;
            for i = 1:t %for RHS (24*p+1)-(24*p+12)
                RHS(inc) = Davg(i);
                inc = inc +1;
            end
            RHS(3*t*p+t+1,1) = Avg;
            for i = 1:p
                RHS(2*t*p+i,1) = Vol_1(i);
            end
            w =1;
            %upper bound and lower bound matrices
            for i = 1:t %for upper bound and lower bound
                ub(w) = 10000;
                lb(w) = 0;
                w = w+1;
                for j = 1:p
                    ub(w) = 100000;
                    ub(w+p) = FRL(j);
                    lb(w) = 0;
                    lb(w+p) = MDDL(j);
                    w = w+1;
                end
                w = w+p;
            end

            %creating sense of the constrains
            sense1 = '<';
                for i = 2:2*t*p
                    sense1 = strcat(sense1,'<');
                end % for sense
                for i = 1:t*(p+1)
                    sense1 = strcat(sense1,'=');
                end
                sense1 = strcat(sense1,'<');

            %creating structure according to gurobi
            model.A = sparse(Cnstrns);
            model.obj = Obj;
            model.rhs = RHS;
            model.sense = sense1;
            model.ub = ub;
            model.modelsense = 'min';
            model.lb = lb;
            params.outputflag = 0;
            result = gurobi(model,params);
            %disp(result);
            %{ 
            %for result matrix
            res = result.x';
            Alloc = zeros(t+1,p+1);
            for i = 1:p
                Alloc(1,1+i) = i;
            end
            for i = 1:t
                Alloc(1+i,1) = i;
            end
            w=2;
            for i=1:t
                for j =1:p
                    Alloc(1+i,1+j) = res(w);
                    w=w+1;
                end
                w = 2 + (1+2*p)*i;
            end
            %}
            y = result;    
            end 


        end
end
      