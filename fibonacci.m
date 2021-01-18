  function [y] = fibonacci(x)
if (x==1) || (x==2)
    y=1;
    return
end

y = fibonacci(x-1)+fibonacci(x-2);

end

