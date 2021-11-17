clear all
r=[1:0.1:100];
%r=4;
gamma=1.4;
n_c=0.85;
n_t=0.87;
n_m=0.99;
n_b=0.98;
gamma_gas=1.333;
cpa=1.005;
cpg=1.148;
t01=288;
p01=1;
delp_regena=r*p01*0.03;
delp_regeng=0.04;
delp_b=r*p01*0.02;
e_regen=0.9;
cv=43100;

%t=1100/288;
tmax=5;
t=[2:1:tmax];

c=r.^((gamma-1)/gamma);

n_simple=1-(1./c);
figure(1);
plot(r,n_simple,'-ks',...
    'LineWidth',2,...
    'MarkerSize',2,...
    'MarkerEdgeColor','k')
xlim([0 30])
ylim([0 1])

hold on;

pause


for ii=1:tmax-1

t02=t01+t01.*(r.^((gamma-1)/gamma)-1)./n_c;
t03=t(ii)*t01;

p03=p01.*r-delp_b;
p04=p01;
t04=t03-n_t.*t03*(1-(p04./p03).^((gamma_gas-1)/gamma_gas));

wt=cpg*(t03-t04);
wc=cpa*(t02-t01);

wtc=wc/n_m;

wnet=wt-wtc;

qin=cpg*(t03-t02);

f=qin./(cv*n_b);

sfc=f./wnet;

n_cycle=1./(sfc*cv);


plot(r,n_cycle,'--b',...
    'LineWidth',ii,...
    'MarkerSize',8,...
    'MarkerEdgeColor','r')

pause
end

for ii=1:tmax-1
n_regen=1-(c./t(ii));
plot(r,n_regen,'r',...
    'LineWidth',ii,...
    'MarkerSize',8,...
    'MarkerEdgeColor','r')

pause
end


for ii=1:tmax-1

t02=t01+t01.*(r.^((gamma-1)/gamma)-1)./n_c;
t03=t(ii)*t01;

p03=p01.*r-delp_regena-delp_b;
p04=p01+delp_regeng;
t04=t03-n_t.*t03*(1-(p04./p03).^((gamma_gas-1)/gamma_gas));

wt=cpg*(t03-t04);
wc=cpa*(t02-t01);

wtc=wc/n_m;

wnet=wt-wtc;

t05=t02+e_regen*(t04-t02);

qin=cpg*(t03-t05);

f=qin./(cv*n_b);

sfc=f./wnet;

n_cycle=1./(sfc*cv);


plot(r,n_cycle,'--g',...
    'LineWidth',ii,...
    'MarkerSize',8,...
    'MarkerEdgeColor','r')

pause
end

