function Y = pointtransform(X, x1, y1, x2,y2)

[n,m]=size(X);
Y=zeros(n,m);

% The transformation based on the given graph ( O(n^2) complexity )
for i=1:n
    for j=1:m
       
        if 0 <= X(i,j) < x1
            Y(i,j) = (y1/x1)*X(i,j);
            
        elseif x1 <= X(i,j) < x2
                Y(i,j)=((y2-y1)/(x2-x1))*(X(i,j)-x1)+y1;
                
        else 
            Y(i,j)=((1-y2)/(1-x2))*(X(i,j)-x2)+y2;
        end
        
    end
end

% Plot image and its histogram
figure; imshow(Y);
[hn, hx] = hist(Y(:), 0:1/255:1);
figure;
bar(hx,hn)

end
