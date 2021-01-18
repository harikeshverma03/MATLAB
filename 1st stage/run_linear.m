function [reg,hol] = run_linear(Day,Demand,Cost_imp,Hydro_avg,Sol_E)
n = 7;
t = 24;
Beta = 1;
Hydro_cap = 447;
Thermal_cap = [180 250 250 250 500 500 150];
Cost_1 = [2.81 2.88 2.88 4.06 4.15 10.76 14.18];
Ramp_Rate = [0.3050    0.0610    0.0610    0.0610    0.0610    0.3050    0.6100];
%{
Day = [26,5];
Demand = csvread('Demand_Jan.csv');
Cost_imp = 15;
Hydro_avg = 16.0895;
Sol_E = csvread('Solar_Jan.csv');
%}
y = func.linear_stage(Day, Cost_1,Cost_imp,Demand,Hydro_cap, Thermal_cap,Hydro_avg,Ramp_Rate,Sol_E,n,t,Beta);
 res_linear = y.x';
[Alloc_linear,sum_reg,sum_hol] = func.Alloc_linear(res_linear,t,n);
reg = sum_reg;
hol = sum_hol;
fprintf('The value of Objective function is: %e\n', y.objval);
x = 1:t;
plot(x,sum_reg);
end