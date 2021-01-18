function [Alloc_linear,sum_reg,sum_hol,objval_mu,objval_mu1,obj_lin_sd,obj_lin_sd1] = run_linear(Day,Beta,Hydro_avg,Demand_mu,Demand_sd,Cost_imp_mu,Cost_imp_sd,Sol_mu,Sol_sd,p)
    n = 7;objval_mu1 = 0;sum1=0;counter = 0;
    t = 24;sum1 = 0;objval = 0;
    Hydro_cap = 447;
    Thermal_cap = [180 250 250 250 500 500 150];
    Cost_1 = [2.81 2.88 2.88 4.06 4.15 10.76 14.18];
    Ramp_Rate = [0.3050    0.0610    0.0610    0.0610    0.0610    0.3050    0.6100];
    Sol_E = zeros(24,2,p);
    Demand = zeros(24,2,p);
    Cost_imp = zeros(1,p);
     for i = 1:p
        Sol_E(:,:,i) = Sol_mu ;% + Sol_sd*randn(1,1);
        Demand(:,:,i) = Demand_mu ;%+ Demand_sd*randn(1,1);
        Cost_imp(i) = Cost_imp_mu ;%+ Cost_imp_sd*randn(1,1);
     end
        model = 0;flag = 0;
     for i = 1:p
         if Demand(:,:,i) - Sol_E(:,:,i) > 0.2
            y = func.linear_stage(Day, Cost_1,Cost_imp(i),Demand(:,:,i),Hydro_cap, Thermal_cap,Hydro_avg,Ramp_Rate,Sol_E(:,:,i),n,t,Beta,flag,0,model);
                 if isfield(y,'x')
                     counter = counter +1;
                     objval(counter) = y.objval;
                     sum1 = sum1 +  y.x';
                 end
     end
     end
     res_linear = sum1/counter;
     flag_count = 0;
     for i = 1:p
         if Demand(:,:,i) - Sol_E(:,:,i) > 0.2
             flag = 1;
             y = func.linear_stage(Day, Cost_1,Cost_imp(i),Demand(:,:,i),Hydro_cap, Thermal_cap,Hydro_avg,Ramp_Rate,Sol_E(:,:,i),n,t,Beta,flag,res_linear,0);
                if isfield(y,'x')
                    flag_count = flag_count +1;
                    objval1(flag_count) = y.objval;  
                end
         end
     end 
     disp(counter);
     disp(flag_count); 
     
    objval_mu = mean(objval);
    obj_lin_sd = std(objval);
    objval_mu1 = mean(objval1);
    obj_lin_sd1 = std(objval1);
    fprintf('The value of Objective function(Monte Carlo Optimised) is: %e\n', objval_mu);
    fprintf('The value of Objective function(Monte Carlo Realistic) is: %e\n', objval_mu1);
    x = 1:counter;
    [Alloc_linear,sum_reg,sum_hol] = func.Alloc_linear(res_linear,t,n);
    
end