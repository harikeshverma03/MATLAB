function dsp11()
    %WAVE FORM GENERATION
    %CT SIGNAL
    %UNIT IMPULSE
    clc;
    clear all;
    close all;
    t1=-3:1:3;
    x1=[0,0,0,1,0,0,0];
    subplot(2,3,1);
    plot(t1,x1);
    xlabel('time');
    ylabel('Amplitude');
    title('Unit impulse signal');
    %UNIT STEP SIGNAL
    t2=-5:1:25;
    x2=[zeros(1,5),ones(1,26)];
    subplot(2,3,2);
    plot(t2,x2);
    xlabel('time');
    ylabel('Amplitude');
    title('Unit step signal');
    %EXPONENTIAL SIGNAL
    a=input('Enter the value of a:');
    t3=-10:1:20;
    x3=exp(-1*a*t3);
    subplot(2,3,3);
    plot(t3,x3);
    xlabel('time');
    ylabel('Amplitude');
    title('Exponential signal');
    %UNIT RAMP SIGNAL
    t4=-10:1:20;
    x4=t4;
    subplot(2,3,4);
    plot(t4,x4);
    xlabel('time');
    ylabel('Amplitude');
    title('Unit ramp signal');
    %SINUSOIDAL SIGNAL
    A=input('Enter the amplitude:');
    f=input('Enter the frequency:');
    t5=-10:1:20;
    x5=A*sin(2*pi*f*t5);
    subplot(2,3,5);
    plot(t5,x5)
    xlabel('time');
    ylabel('Amplitude');
    title('Sinusoidal signal');
    %RANDOM SIGNAL
    t6=-10:1:20;
    x6=rand(1,31);
    subplot(2,3,6);
    plot(t6,x6);
    xlabel('time');
    ylabel('Amplitude');
    title('Random signal');
end