clear all
r=[1:0.1:100];
gamma=1.4;

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

tmax=6;
t=[2:1:tmax];
for ii=1:5
n_regen=1-(c./t(ii));
plot(r,n_regen,'-r',...
    'LineWidth',ii,...
    'MarkerSize',8,...
    'MarkerEdgeColor','r')

pause
end

for ii=1:5
n_reheat=((2*t(ii).*(1-1./sqrt(c)))-(c-1))./(2*t(ii)-c-t(ii)./sqrt(c));
plot(r,n_reheat,'-g',...
    'LineWidth',ii,...
    'MarkerSize',8,...
    'MarkerEdgeColor','g')

pause
end


for ii=1:5
n_regen_reheat=((2*t(ii).*(1-1./sqrt(c)))-(c-1))./(2*t(ii)-2.*t(ii)./sqrt(c));
plot(r,n_regen_reheat,'-b',...
    'LineWidth',ii,...
    'MarkerSize',8,...
    'MarkerEdgeColor','b')

pause
end

% Intercooled cycle
for ii=1:5
n_int=(t(ii)-(t(ii)./c)+2-2*sqrt(c))./(t(ii)-sqrt(c));
plot(r,n_int,'-.k',...
    'LineWidth',ii,...
    'MarkerSize',8,...
    'MarkerEdgeColor','k')

pause
end


% Intercooled cycle with regeneration 
for ii=1:5
n_int_regen=1-((2.*sqrt(c)-2)./(t(ii)-t(ii)./c));
plot(r,n_int_regen,'-.r',...
    'LineWidth',ii,...
    'MarkerSize',8,...
    'MarkerEdgeColor','r')

pause
end

% Intercooled cycle with reheat
for ii=1:5
n_int_reheat=2*(t(ii)-(t(ii)./sqrt(c))-sqrt(c)+1)./(2*t(ii)-sqrt(c)-t(ii)./sqrt(c));
plot(r,n_int_reheat,'-.g',...
    'LineWidth',ii,...
    'MarkerSize',8,...
    'MarkerEdgeColor','g')

pause
end

% Intercooled cycle with regeneration and reheat
for ii=1:5
n_int_regen_reheat=1-(sqrt(c)./t(ii));
plot(r,n_int_regen_reheat,'-.b',...
    'LineWidth',ii,...
    'MarkerSize',8,...
    'MarkerEdgeColor','b')

pause
end




%----------------------------------------------------------------------------
figure(2);
for ii=1:5
w_simple=t(ii).*(1-1./c)-(c-1);

plot(r,w_simple,'-k',...
    'LineWidth',ii)
xlim([0 30])
ylim([0 4])

hold on;
pause
end 

for ii=1:5
w_reheat=((2*t(ii).*(1-1./sqrt(c)))-(c-1));
plot(r,w_reheat,'-b',...
    'LineWidth',ii)

pause
end

for ii=1:5
w_int=(t(ii)-(t(ii)./c)+2-2*sqrt(c));
plot(r,w_int,'-.k',...
    'LineWidth',ii)

pause
end

for ii=1:5
w_int=2*(t(ii)-(t(ii)./sqrt(c))-sqrt(c)+1);
plot(r,w_int,'-.b',...
    'LineWidth',ii)

pause
end
