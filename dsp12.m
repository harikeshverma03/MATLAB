function dsp12()
    %WAVE FORM GENERATION
    %DT SIGNAL
    %UNIT IMPULSE
    clc;
    clear all;
    close all;
    n1=-3:1:3;
    x1=[0,0,0,1,0,0,0];
    subplot(2,3,1);
    stem(n1,x1);
    xlabel('time');
    ylabel('Amplitude');
    title('Unit impulse signal');
    %UNIT STEP SIGNAL
    n2=-5:1:25;
    x2=[zeros(1,5),ones(1,26)];
    subplot(2,3,2);
    stem(n2,x2);
    xlabel('time');
    ylabel('Amplitude');
    title('Unit step signal');
    %EXPONENTIAL SIGNAL
    a=input('Enter the value of a:');
    n3=-10:1:20;
    x3=power(a,n3);
    subplot(2,3,3);
    stem(n3,x3);
    xlabel('time');
    ylabel('Amplitude');
    title('Exponential signal');
    %UNIT RAMP SIGNAL
    n4=-10:1:20;
    x4=n4;
    subplot(2,3,4);
    stem(n4,x4);
    xlabel('time');
    ylabel('Amplitude');
    title('Unit ramp signal');
    %SINUSOIDAL SIGNAL
    A=input('Enter the amplitude:');
    f=input('Enter the frequency:');
    n5=-10:1:20;
    x5=A*sin(2*pi*f*n5);
    subplot(2,3,5);
    stem(n5,x5);
    xlabel('time');
    ylabel('Amplitude');
    title('Sinusoidal signal');
    %RANDOM SIGNAL
    n6=-10:1:20;
    x6=rand(1,31);
    subplot(2,3,6);
    stem(n6,x6);
    xlabel('time');
    ylabel('Amplitude');
    title('Random signal');
end