function [dyn,sum] = run_dyn(n)
 Beta = 1;
 t1 = 12;
 p = 3;
 z = zeros(n,84);
 objval = 0;
 Rain_mu = csvread('rainfall_avg.csv')';
 Rain_sd = csvread('rain_sd.csv')';
 V1_sd = [7.3338    7.6809    6.9982];
 V1_mu = [627.3 656.99 598.6];
 MDDL = [619.4 646 590.1];
 FRL = [635.2 668 607.1];
 Hp = [51.84 54 216];
 Avg = 2336.232;
 E_mu = csvread('solar.csv');
 E_sd = csvread('solar_sd.csv');
 E = zeros(n,t1);
 V1 = zeros(n,p);
 Rain = zeros(t1,p,n);
 for i = 1:n
    E(i,:) = E_mu + E_sd*randn(1,1);
    V1(i,:) = V1_mu + V1_sd*randn(1,1);
    Rain(:,:,i) = Rain_mu + Rain_sd*randn(1,1);
 end
 Dem = csvread('Demand.csv')';
 sum1 = 0;
 for j = 1:n
        Dem_cost = Dem - Beta*E(j,:);
        Cost = func.Cost(Dem_cost);
        
        x = func.dynamic_stage(Cost,Dem,E(j,:),Beta,V1_mu,Rain(:,:,j),MDDL,FRL,Hp,t1,p,Avg);
        z(j,:) = x.x';
        objval = objval + x.objval;
        sum1 = sum1 + z(j,:);
 end
res_dynamic = sum1/n;
objval = objval/n;
fprintf('The value of Objective function is: %e\n', objval);
x = 1:t1;        
[dyn,sum] = func.Alloc_dynamic(res_dynamic,t1,p);
plot (x,sum);
end