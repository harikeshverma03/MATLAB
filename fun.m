classdef fun
    methods(Static)
        function y = func(x)
            if (x==1) || (x==2)
                 y=1;
                return
            end

          y = fibonacci(x-1)+fibonacci(x-2);
        end
        function y = sumation(x)
            y = 0;
            for i = 1:length(x)
                disp(i);
                y=y+x(i);
            end
        end
    end
end    