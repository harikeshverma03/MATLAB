function dsp22()
%Program to perform Circular Convolution
    clc;
    close all;
    clear all;
    a1= input('1st Sequence x:');
    b1= input('2nd Sequence h:');
    ax=length(a1);
    bx=length(b1);
    n=max(ax,bx);
    n3=ax-bx;
    if(n3<=0)
    a1=[a1,zeros(1,-n3)];
    else
    b1=[b1,zeros(1,n3)];
    end
    for r=1:n
    y(r)=0;
    for i=1:n
    j=r-i+1;
    if j<=0
    j=j+n;
    end
    y(r)=y(r)+b1(j)*a1(j);
    end
    end
    subplot(3,1,1);
    stem(a1);a1
    xlabel('n');
    ylabel('a(n)');
    title('first sequence');
    subplot(3,1,2);
    stem(b1);b1
    xlabel('n');
    ylabel('b(n)');
    title('second sequence');
    subplot(3,1,3);
    stem(y);
    xlabel('n');
    ylabel('y(n)');
    title('circular convolution sequence');
    disp('The resultant signal is:' );y
end