function J = computeCostMulti(X, y, theta)
%COMPUTECOSTMULTI Compute cost for linear regression with multiple variables
%   J = COMPUTECOSTMULTI(X, y, theta) computes the cost of using theta as the
%   parameter for linear regression to fit the data points in X and y

% Initialize some useful values
m = length(y); % number of training examples
f =  size(X,2); % number of features
% You need to return the following variables correctly 
J = 0;
Cost = 0;
Htheta = X*theta;
for i = 1:m
    Cost = Cost + (Htheta(i) - y(i))^2;
end
J = Cost/(2*m);
% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost of a particular choice of theta
%               You should set J to the cost.





% =========================================================================

end
