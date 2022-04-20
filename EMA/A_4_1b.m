clc
clear all
close all

Ts = 0.04;
t = 0:Ts:1;
x_t = 5*sin(2*pi*12*t) + 17*sin(2*pi*20*t - 70);
N = length(t); n = 0:N-1;
x_s = 5*sin(2*pi*12*n*Ts) + 17*sin(2*pi*20*n*Ts - 70);
%%
figure
plot(t,x_t)
xlabel('Time (seconds)')
ylabel('x(t)')
title('Apmlitude versus time')
%%
figure
plot(n,x_s)
xlabel('n')
ylabel('x(n)')
title('Amplitude versus n')
%%
y = fft(x_t);   
fs = 1/Ts;
f = (0:length(y)-1)*fs/length(y); 
figure;
plot(f,abs(y))
xlabel('Frequency (Hz)')
ylabel('Magnitude')
title('Magnitude (using FFT command)')
%%
 if(N>length(x_s))
    for i=1:N-length(x_s)
        x=[x 0];
     end
 end
 X=[];
 xx=0;
 for k=0:N-1
     for n=0:N-1
         xx=xx+x_s(n+1)* exp(-j*2*pi*n*k/N);
     end
     X=[X xx];
     xx=0;
 end
figure
plot(f,abs(X))
xlabel('Frequency (Hz)')
ylabel('Magnitude')
title('Magnitude (using Matlab code)')

