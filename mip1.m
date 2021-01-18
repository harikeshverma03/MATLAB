function  mip1()
% Copyright 2020, Gurobi Optimization, LLC
% This example formulates and solves the following simple MIP model:
%  maximize
%        x +   y + 2 z
%  subject to
%        x + 2 y + 3 z <= 4
%        x +   y       >= 1
objval = 0;
names = {'pi'; 'y';'beta'};
y1 = [2.5 3 20];
model.obj = [150 230 260 238 210 -170 -150 -36 -10];
model.rhs = [500; 200; 240; 0];
model.sense = '<>><';
%model.ub = [134.1 57.2 308.5 10000 10000 10000 10000 6000 10000];

%model.lb = [134 57.1 308.4 0 0 0 0 0 0];
model.ub = [500 500 500 10000 10000 10000 10000 6000 10000];

model.lb = [0 0 0 0 0 0 0 0 0];
%model.vtype = 'B';
model.modelsense = 'min';
%model.varnames = {'x'; 'y'; 'z'};
model.A = zeros(4,9);
%gurobi_write(model, 'mip1.lp');
n = 1000;
sum1 = zeros(1,9);
count2 = 0;
params.outputflag = 0;
for i =1:n
    per(i) = 1 + 0.2*randn(1,1);
end

%per = [0.8 1 1.2];
for i = 1:n
        y = y1*per(i);
       model.A = sparse([1 1 1 0 0 0 0 0 0;y(1) 0 0 1 0 -1 0 0 0;0 y(2) 0 0 1 0 -1 0 0; 0 0 -y(3) 0 0 0 0 1 1]);

 %model.A = sparse(model.A / n);
x = gurobi(model,params);
        if isfield(x,'x')
        z(i,:) = x.x';
         objval = objval+ x.objval;
        sum1 = sum1 + z(i,:);
        count2 = count2 +1;
        %disp(count2);
        else
        end
end
res_dynamic = sum1/count2;
disp(objval/count2);% wrong objective value for given solution but maximun objective value which can be achieved for perfect information
for i = 1:n
     y = y1*per(i);
       model.A = sparse([1 1 1 0 0 0 0 0 0;y(1) 0 0 1 0 -1 0 0 0;0 y(2) 0 0 1 0 -1 0 0; 0 0 -y(3) 0 0 0 0 1 1]);
       A = sparse([1 1 1 0 0 0 0 0 0;y(1) 0 0 1 0 -1 0 0 0;0 y(2) 0 0 1 0 -1 0 0; 0 0 -y(3) 0 0 0 0 1 1]);
       model.ub = [res_dynamic(1) res_dynamic(2) res_dynamic(3) 10000 10000 10000 10000 6000 10000];
       model.lb = [res_dynamic(1)-0.1 res_dynamic(2)-0.1 res_dynamic(3)-0.1 0 0 0 0 0 0];
       x = gurobi(model,params);
       if isfield(x,'x')
           objval(1,i) = x.objval;%right objective value which we will obtain from the given solution
           %disp(objval(1,i));
           %disp(x.x');
       end
 end
%objval1 = 150*res_dynamic(1)+230*res_dynamic(2)+260*res_dynamic(3)+238*res_dynamic(4)+210*res_dynamic(5)-170*res_dynamic(6)-150*res_dynamic(7)-36*res_dynamic(8)-10*res_dynamic(1);
%objval1 = model.obj*res_dynamic';
%disp(objval1);% wrong objective value
for v=1:9
    fprintf('%d    ', res_dynamic(v));
end
fprintf('Obj: %e\n', mean(objval));
end