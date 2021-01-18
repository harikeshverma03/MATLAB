function dynamic_linear(n)

[dyn,sum] = run_dyn(n);
Day = [26,5];
Demand = csvread('Demand_Jan.csv');
Cost_imp = 15;
Sol_E = csvread('Solar_Jan.csv');
for i = 1:12
    Hydro_avg = sum(i);
   [reg(i,:),hol(i,:)] = run_linear(Day,Demand,Cost_imp,Hydro_avg,Sol_E);
   
end

   














end