function dsp21()
%Program to perform Linear Convolution
    clc;
    clear all;
    close all;
    
    x1=input('Enter the first sequence to be convoluted:');
    subplot(3,1,1);
    stem(x1);
    xlabel('Time');
    ylabel('Amplitude');
    title('First sequence');
    x2=input('Enter the second sequence to be convoluted:');
    subplot(3,1,2);
    stem(x2);
    xlabel('Time');
    ylabel('Amplitude');
    title('Second sequence');
    f=conv(x1,x2);
    disp('The Linear convoluted sequence is');
    disp(f);
    subplot(3,1,3);
    stem(f);
    xlabel('Time');
    ylabel('Amplitude');
    title('Linear Convoluted sequence');
end
