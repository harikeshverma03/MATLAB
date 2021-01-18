function y = stochastic(H,n)
% this function demonstrates two stage stochastic programming
%z = min 100x1 + 150x2 +E(q1y1 + q2y2)
%stochastic(H1) = min(D-E-H + stochastic(H2)
if(n == 1)
    V(1) = 10;
    
else
Obj  = C(n) * [k -1 stochastic(H,n-1)] ;
Cnstrns = [
end

end
