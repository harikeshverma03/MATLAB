clc
clear all;

m = 1;
K = 1*10^6;
c = 200;

wn = sqrt(K/m);
w = 0:0.01:2000;
zeta = c/(2*wn*m);
r = w / wn;
a = (1-r.^2);
b = ((1-r.^2).^2 + (2*zeta*r).^2);
Re = (1/K)*a./b;
Im = (1/K)*(-2*zeta*r)./b;
phase = atan(Im./Re);
mag = sqrt(Re.^2 + Im.^2);

%%
%Magnitude versus Frequency and phase versus frequency
hold on;
tiledlayout(2,1)
% Top plot
nexttile;
plot(w,mag);
grid on; 
title('Magnitude versus Frequency');
xlabel('Frequency'); ylabel('Magnitude');
hold off;
% Bottom plot
nexttile;
hold on;
plot(w, phase);
grid on; 
title('Phase versus Frequency');
xlabel('Frequency'); ylabel('Phase');
hold off;

%%
%log Magnitude versus Frequency and phase versus frequency
figure
hold on;
tiledlayout(2,1)
% Top plot
nexttile;
semilogy(w,mag);
grid on;
title('Log Magnitude versus Frequency');
xlabel('Frequency'); ylabel('Log Magnitude');
hold off;
% Bottom plot
nexttile;
hold on;
plot(w, phase);
grid on;
title('Phase versus Frequency');
xlabel('Frequency'); ylabel('Phase');
hold off;

%%
%Real versus Frequency and Imaginary versus frequency
figure;
tiledlayout(2,1)
% Top plot
nexttile;
plot(w,Re);
hold on;grid on; 
title('Real versus Frequency');
xlabel('Frequency'); ylabel('Real');
hold off;
% Bottom plot
nexttile;
plot(w, Im);
hold on;grid on; 
title('Imaginary versus Frequency');
xlabel('Frequency'); ylabel('Imaginary');
hold off;
%%
figure;
plot(Re, Im);
hold on; grid on;
title('Nyquist Plot');
xlabel('Real Axis'); ylabel('Imaginary Axis');
hold off;