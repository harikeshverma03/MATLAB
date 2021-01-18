function y = dynamic(Cost,D,E,V1,Rain,p,MDDL,FRL,Hp)
k = 0.9;
Avg = 21600;
Davg = D - k*E;
Cp = Hp./(FRL-MDDL);
Cnstrns = zeros((36*p+13),(1+2*p)*12);
ub = zeros(1,(1+2*p)*12);
lb = zeros(1,(1+2*p)*12);
Obj = zeros(1,(1+2*p)*12);
RHS = zeros((36*p+13),1);
w = 1; inc = 1;
for i = 1:12 % for Objective Function
    Obj(1,w)= Cost(i);
    w=w+1;
    for j = 1:p
        Obj(1,w)= -Cost(i);
        w=w+1;
    end
    w = 1+(1+2*p)*i;
end
w = 2;
for i = 1:12 % for Constrain Matrix(1)-(24*p)
    for j = 1:p
        Cnstrns(inc,w) = 1;
        Cnstrns(inc,w+p) = -Cp(j); 
        Cnstrns(inc+(12*p),w) = -1;
        Cnstrns(inc+(12*p),w+p) = 0.01*Cp(j);
        w = w+1; inc = inc+1;
    end
     w = 2+(1+2*p)*i;
end
inc = inc + (12*p);
w=2;
for i = 1:p
    Cnstrns(inc,w+p) = 1;
    inc = inc + 1;
    w = w+1;
end
w =2;
for i = 1:11 % for Constrain Matrix (1+24*p)-(36*p) 
    for j = 1:p
        Cnstrns(inc,w+(3*p+1)) = 1;
        Cnstrns(inc,w+p) = -1;
        Cnstrns(inc,w) = 1/Cp(j);
        w = w+1; inc = inc+1;
    end
     w = 2+(1+2*p)*i;
end
w =1;
for i = 1:12 % for Constrain (36*p)+12
    Cnstrns(inc, w) = 1;
    w = 1 + (1+2*p)*i;
    inc = inc+1;
end
w = 2;
for i =1:12 %for Constrain (36*p)+13
    for j =1:p
        Cnstrns(inc,w) = 1;
        w = w+1;
    end
    w = 2+(1+2*p)*i;
end
inc = 1;
for i= 1:12 %for RHS 1-36*p
    for j = 1:p
        RHS(inc,1) = -Cp(j)*MDDL(j);
        RHS(inc+12*p,1) = 0.01*Cp(j)*MDDL(j);
        RHS(inc+24*p,1) = Rain(i,j);
        inc = inc+1;
    end
end
inc = 36*p +1;
for i = 1:12 %for RHS (36*p+1)-(36*p+12)
    RHS(inc) = Davg(i);
    inc = inc +1;
end
RHS(36*p+13,1) = Avg;
for i = 1:p
    RHS(24*p+i,1) = V1(i);
end
w =1;
for i = 1:12 %for upper bound and lower bound
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
sense1 = '<';
    for i = 2:24*p
        sense1 = strcat(sense1,'<');
    end
    for i = 1:12*(p+1)
        sense1 = strcat(sense1,'=');
    end
    sense1 = strcat(sense1,'<');
model.A = sparse(Cnstrns);
model.obj = Obj;
model.rhs = RHS;
model.sense = sense1;
model.ub = ub;
model.modelsense = 'min';
model.lb = lb;
params.outputflag = 0;
result = gurobi(model,params);
disp(result);
for v=1:p
    fprintf(' %d\n', result.x(1+v));
end

fprintf('Obj: %e\n', result.objval);
 y = result.x';   
end