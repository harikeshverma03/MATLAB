function [dyn,sum_hydro,objval,objval1] = run_dyn(n,Cost_imp,Beta,Rain_mu,Rain_sd,V1_mu,V1_sd,E_mu,E_sd)
 Dem = csvread('Demand.csv')';
 sum1 = 0;counter = 0;flag = 0; 
t1 = 12;model = 0;
 p = 3;
 z = zeros(n,84);
 objval = 0;
 MDDL = [619.4 646 590.1];
 FRL = [635.2 668 607.1];
 Hp = [51.84 54 216];
 Avg = 1336.232;
 E = zeros(n,t1);
 V1 = zeros(n,p);
 Rain = zeros(t1,p,n);
 
 for i = 1:n
    E(i,:) = E_mu ;%+ E_sd*randn(1,1);
    V1(i,:) = V1_mu ;%+ V1_sd*randn(1,1);
    Rain(:,:,i) = Rain_mu;% + Rain_sd*randn(1,1);
 end
 for i = 1:n
     if V1(i,:) - MDDL > 0 
        Dem_cost = Dem - Beta*E(i,:); % Change this
        Cost = func.Cost(Dem_cost,Cost_imp);
        %model = func.dynamic_stage(Cost,Dem,E(i,:),Beta,V1(i,:),Rain(:,:,i),MDDL,FRL,Hp,t1,p,Avg,V1_mu,flag,0,model);
        %model = func.dynamic_stage(Cost,Dem,E_mu,Beta,V1_mu,Rain_mu,MDDL,FRL,Hp,t1,p,Avg,V1_mu,flag,0,model);
        flag = 0;
        x = func.dynamic_stage(Cost,Dem,E_mu,Beta,V1_mu,Rain_mu,MDDL,FRL,Hp,t1,p,Avg,V1_mu,flag,0,model);
        if isfield(x,'x')
            counter = counter +1;
            objval(counter) = x.objval;
            sum1 = sum1 + x.x';
        end
       
     end
 end
 %{
            model.A = model.A/n;
            model.obj = model.obj/n;
            model.rhs = model.rhs/n;
            model.ub = model.ub/n;
            model.modelsense = 'min';
            model.lb = model.lb/n;
 params.outputflag = 0;
 %disp(model.obj);
 disp(n);
 x = gurobi(model,params);
 if isfield(x,'x')
            count = count +1;
            objval(1,count) = x.objval;
            sum1 = sum1 + x.x';
            
        end
 %disp(count);
 %}
 res_dynamic = sum1/counter;
 flag_count = 0;
 for i = 1:n
    if V1(i,:) - MDDL > 0        
        Dem_cost = Dem - Beta*E(i,:);
        Cost = func.Cost(Dem_cost,Cost_imp);
        flag = 1;
        x = func.dynamic_stage(Cost,Dem,E(i,:),Beta,V1(i,:),Rain(:,:,i),MDDL,FRL,Hp,t1,p,Avg,V1_mu,flag,res_dynamic,model);
        %x = func.dynamic_stage(Cost,Dem,E_mu,Beta,V1_mu,Rain_mu,MDDL,FRL,Hp,t1,p,Avg,V1_mu,flag,res_dynamic,model);
        if isfield(x,'x')
            flag_count = flag_count +1;
            objval1(flag_count) = x.objval;
        end
    end
 end
  disp(counter);
 disp(flag_count);

fprintf('The value of Objective function(Monte Carlo Optimised) is: %e\n', mean(objval));
fprintf('The value of Objective function(Monte Carlo Realistic)is: %e\n', mean(objval1));
objval1 = mean(objval1);

x = 1:counter;
for i = 1:counter
    y(i) = sum(objval(1:i))/i;
end
plot(x,y);
[dyn,sum_hydro] = func.Alloc_dynamic(res_dynamic,t1,p);
%disp(dyn);
end