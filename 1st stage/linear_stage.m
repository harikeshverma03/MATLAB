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
%disp(ub); disp(lb);
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
    %disp(Obj);
    %disp(Cnstrns);
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
