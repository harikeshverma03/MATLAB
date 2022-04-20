mass = 1;
K = 1*10^6;
C = 200;

wn = sqrt(K/mass); 
zeta = C / (2*mass*wn);
frequency = 0:0.01:2000;
fr = frequency/wn;
magnitude = (1/K)*sqrt(1./( (1-fr.^2).^2 + (2*zeta*fr).^2 ));
phase = atan( (-2*zeta*fr)./(1-fr.^2) );

figure; 
grid on;
plot(frequency, magnitude, 'o-- '); 
grid on;
xlabel('Frequency'); ylabel('Plots'); 
title('Part A');

figure;
plot(frequency, phase, 'r--'); 
grid on;
xlabel('Frequency'); 
ylabel('Plots'); 
title('Part A');
%%
r = fr;
a = (1-r.^2);
b = ((1-r.^2).^2 + (2*zeta*r).^2);
Re = (1/K)*a./b;
Im = (1/K)*(-2*zeta*r)./b;
figure; hold on;
plot(frequency, Im);
plot(frequency, Re);
xlabel('frequency'); ylabel('Plots'); grid on;
legend('Real', 'Imaginary'); hold off;

%%
figure;
plot(Re, Im); hold on; grid on; xlabel('Real'); ylabel('Imaginary');hold off;