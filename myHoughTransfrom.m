function [H,L,res] = myHoughTransfrom(img_binary, Drho, Dtheta,n)

    % myHoughTransfrom:  Implements Hough acculumator algorithm,
    %                    the fastest version, by scanning only the nonzero
    %                    elements of the binary image.Then find the n most
    %                    promiment lines (Hough peaks) and also the number
    %                    of the residual points that do not belong to hough
    %                    lines.
    %
    % Format:            [H,L,res] = myHoughTransfrom(img_binary, Drho, Dtheta,n)
    %
    %
    % Input: img_binary   - binary image , after gaussian smoothing and edge
    %                      detector.
    %        Drho         - rho step.
    %        Dtheta       - theta step.
    %        n            - n most promiment lines.
    %
    %
    % Output: H           - Hough matrix.
    %         L           - [n x 2] matrix containing the rho,theta
    %                       coordinates of the n most promiment lines.
    %         res         - number of residual points
    %                    
   

    [height , width] = size(img_binary);
    % maximum distance
    diag_len = ceil(sqrt(width.^2 + height.^2));
    
    thetas = (0:Dtheta:pi);
    rhos = (0:Drho:diag_len);
   
    %%%%%%%%%%%% Hough accumulator %%%%%%%%%%%%%%%%%%%%
    
    H = zeros(length(rhos) , length(thetas));

    % Indexes to edges ( nonzero elements)
    [y,x] = find(img_binary);
    
    k = length(x);
    
    for i = 1:k
        
        x1 = x(i);
        y1 = y(i);

         for theta = thetas

            rho = round( x1 * cos(theta) + y1 * sin(theta));
            if(rho >= 0)
                rho_idx = floor(rho/Drho) + 1;
                theta_idx = floor(theta/Dtheta) + 1;
                H(rho_idx,theta_idx) = H(rho_idx,theta_idx) + 1;
            end

         end
  
    end
   
    %%%%%%%%%%%%%% Hough peaks %%%%%%%%%%%%%%%%%%%%

    Hf = H;
    L = zeros(n,2);
    
    for k = 1:n
        
        maximum = 0;
    
        for i = 1:size(Hf,1)
            for j = 1:size(Hf,2)
                
                if Hf(i,j) >= maximum
                    maximum = Hf(i,j);
                    rho_index = i;
                    theta_index = j;
                end


            end 
        end
        
        Hf(rho_index,theta_index) = 0;
        
        L(k,1) = (rho_index - 1) * Drho;
        L(k,2) = (theta_index-1) * Dtheta ;
        
        
    end
    
    %%%%%%%%%%% Residual points that do not belong to hough lines %%%%%%%%%%
    
    res = height * width;
    linesLength = zeros(n,1);
    
    for i = 1 : size(L,1)
        
        rho_i = L(i,1);
        theta_i = L(i,2);

        if theta_i == 0
            x1 = rho_i;
            x2 = rho_i;
            if rho_i > 0
                y1 = 1;
                y2 = size(img_binary,1);
                
            end
            
            linesLength(i,1) = round(sqrt((y2 - y1)^2 + (x2 - x1)^2));
            
            
        else

            x1 = 1;
            x2 = size(img_binary, 2);
            y1 = (rho_i - x1 * cos(theta_i)) / sin(theta_i);
            y2 = (rho_i - x2 * cos(theta_i)) / sin(theta_i);
            
            linesLength(i,1) = round(sqrt((y2 - y1)^2 + (x2 - x1)^2));


        end
        
    end
    
    for i = 1:n
        res = res - linesLength(i,1);
    end
   
    
    
    
end