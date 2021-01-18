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