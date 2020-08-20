function Y = histtransfrom(X, h, v)

[N,M] = size(X);
Z = zeros(N*M,1);
k = 1;

% Transform 2D array into 1D in order to sort it
for i = 1 : N
    for j = 1 : M
        Z(k) = X(i,j);
        k = k +1;
    end
end

% Sort it and maintain the previous indexing
[Zsorted, initIndex] = sort(Z);

counter = 0 ;
m = 1;
g = size(v,2);

% Greedy algorithm to allocate the pixel based on the given histogram
for k = 1 : g
    
    while((counter)/(N*M) < h(k))
        
        % If we surpass the array's length
        if(m <= N*M)
            Zsorted(m) = v(k);
            counter = counter + 1;
            m = m + 1;
        else
            counter = counter + 1;
        end
    end
    
    counter = 0 ;
end

% Use the original indexing to reform the array
Zf(initIndex) = Zsorted;
Y = reshape(Zf,[N,M]);
Y = transpose(Y);


% Plot its histogram 
[hn, hx] = hist(Y(:), 0:1/255:1);
figure;
bar(hx,hn)

% Calcute the error on the new histogram
error = hn/(size(Y,1)*size(Y,2));
errors = zeros(size(h,2),1);

% Remove zeros
u = 1;
for i=1:size(error,2)
    if(error(i) ~= 0 )
        errors(u) = error(i);
        u = u + 1;
    end
end

%%%%%% !!!!! The command (transpose(errors) - h)/100 gives us the errors in each
% column in percentage !!!! %%%%%%%



% Plot image
figure;
imshow(Y);
end


