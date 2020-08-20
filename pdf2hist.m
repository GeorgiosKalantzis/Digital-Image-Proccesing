function h = pdf2hist(d, f)

n = size(d);

h = zeros(1,n(2)-1);

% Numerical Discrete integration using fitting rectangles
% An expected error exists in the integration due to the numerical method


% Number of points K
K = 10;

for i = 1:n(2)-1
    
    % Length of rectangles
    dx = (d(i+1)-d(i))/K;
    % Middle of rectangles
    x = [0.5:K-0.5]*dx + d(i);
    
    % height of rectangles
    y = f(x);
    
    % Calculate the area under the rectangle's surface for each
    % sub-interval
    h(i) = sum(y)*dx;

    
end


% Normalize the vector to sum up to 1 by using the first norm
normalize = norm(h,1);

if normalize > 0
    hnorm = h/normalize;
   
else % if zero do not divide!!
    hnorm = normalize;
end

h = hnorm;


end
