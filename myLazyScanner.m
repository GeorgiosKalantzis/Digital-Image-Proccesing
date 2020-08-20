img = imread('C:/Users/User/Desktop/HW2-v2/images/im3.jpg');


img = imresize(img, 0.2);

I = rgb2gray(img);
I = double(I)/255;

I = imgaussfilt(I,3.3);

I = edge(I,'sobel');

n = 10;
Dtheta = pi/180;
Drho = 1;
[H,L] = myHoughTransfrom(I,Drho,Dtheta,n);

%%%%%%%%%% Store only the orthogonal lines %%%%%%%%%%%%%%%%%%
z = 1;
k = 2;
for i = 1:size(L,1)
    for j = k:1:size(L,1)
        
        rho_i = L(i,1);
        theta_i = L(i,2);
        
        rho_j = L(j,1);
        theta_j = L(j,2);
        
        
        % Find the points of the i lines
        if theta_i == 0
            x1_i = rho_i;
            x2_i = rho_i;
            
            if rho_i > 0
                y1_i = 1;
                y2_i = size(img,1);
               
            end
        else

            x1_i = 1;
            x2_i = size(img, 2);
            y1_i = (rho_i - x1_i * cos(theta_i)) / sin(theta_i);
            y2_i = (rho_i - x2_i * cos(theta_i)) / sin(theta_i);


        end
        
        % Find the points of the j lines
         if theta_j == 0
            x1_j = rho_j;
            x2_j = rho_j;

            if rho_i > 0
                y1_j = 1;
                y2_j = size(img,1);

            end
        else

            x1_j = 1;
            x2_j = size(img, 2);
            y1_j = (rho_j - x1_j * cos(theta_j)) / sin(theta_j);
            y2_j = (rho_j - x2_j * cos(theta_j)) / sin(theta_j);


         end
        
        % Calculate their angle
        v1 = [x2_i,y2_i]-[x1_i,y1_i];
        v2 = [x2_j,y2_j]-[x1_j,y1_j];
        angle = acos(sum(v1.*v2)/(norm(v1)*norm(v2)));
        
        % Radians to degree
        angle = angle * 180/pi;
        
        % If almost orthogonal store them
        if (angle >= 89.6 && angle <= 90.1)
            
            orthoLines(z,1) = rho_i;
            orthoLines(z,2) = theta_i;
            orthoLines(z+1,1) = rho_j;
            orthoLines(z+1,2) = theta_j;
            z = z + 1;
            
        end
  
    end
    
    k = k + 1;
end

%%%%%%%%%%%% Eliminate Duplicate Lines %%%%%%%%%%%%%%%%%%%%%%%%%%%%

orthoLength = size(orthoLines,1);
i = 1;
k = 0;
j = 2;

while( i <= orthoLength - k  ) 
    while ( j <= orthoLength - k )
    
        if(abs((orthoLines(i,1) - orthoLines(j,1))) <= 1 && ...
                abs((orthoLines(i,2) - orthoLines(j,2))) <= 1 )

            orthoLines(j,:) = [];
            %i = i - 1;
            j = j - 1;
            k = k + 1;

        end

       
        j = j + 1;
    
    end
    
    i = i + 1;
    j = i + 1;
    
end

%%%%%%%%%%%%%% Plot orthogonal Lines %%%%%%%%%%%%%%%%%%%%%%
figure();
imshow(img);
hold on
for i = 1:size(orthoLines,1)
    
    if orthoLines(i,2) == 0
        x1 = orthoLines(i,1);
        x2 = orthoLines(i,1);
        if orthoLines(i,1) > 0
            y1 = 1;
            y2 = size(img,1);
            plot([x1,x2],[y1,y2],'r','LineWidth',2); 
        end
    else

        x1 = 1;
        x2 = size(img, 2);
        y1 = (orthoLines(i,1) - x1 * cos(orthoLines(i,2))) / sin(orthoLines(i,2));
        y2 = (orthoLines(i,1) - x2 * cos(orthoLines(i,2))) / sin(orthoLines(i,2));

        plot([x1,x2],[y1,y2],'r','LineWidth',2);

    end


    

end


%%%%%%%%%%%%%%%% Intersection Points %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hold on;
x = 1:0.05:size(img,2);
k = 2;
for i = 1:size(orthoLines,1)
    
    for j = k:size(orthoLines,1)
        
        rho_i = orthoLines(i,1);
        theta_i = orthoLines(i,2);
        
        rho_j = orthoLines(j,1);
        theta_j = orthoLines(j,2);
        
        
        if orthoLines(i,2) == 0
            
            x1_i = rho_i;
            x2_i = rho_i;

            if orthoLines(i,1) > 0
                
                y1_i = 1;
                y2_i = size(img,1);

                y1 = size(img,1);

            end
        else
            
            x1_i = 1;
            x2_i = size(img, 2);
            y1_i = (rho_i - x1_i * cos(theta_i)) / sin(theta_i);
            y2_i = (rho_i - x2_i * cos(theta_i)) / sin(theta_i);


            y1 = (orthoLines(i,1) - x * cos(orthoLines(i,2))) / sin(orthoLines(i,2));

        end

        if orthoLines(j,2) == 0
            x1_j = rho_j;
            x2_j = rho_j;

            

            if orthoLines(j,1) > 0
                
                y1_j = 1;
                y2_j = size(img,1);

                y2 = size(img,1);

            end

        else
            
            x1_j = 1;
            x2_j = size(img, 2);
            y1_j = (rho_j - x1_j * cos(theta_j)) / sin(theta_j);
            y2_j = (rho_j - x2_j * cos(theta_j)) / sin(theta_j);

            y2 = (orthoLines(j,1) - x * cos(orthoLines(j,2))) / sin(orthoLines(j,2));

        end
        
        v1 = [x2_i,y2_i]-[x1_i,y1_i];
        v2 = [x2_j,y2_j]-[x1_j,y1_j];
        angle = acos(sum(v1.*v2)/(norm(v1)*norm(v2)));
        
        % Radians to degree
        angle = angle * 180/pi;
        
        if (angle >= 89.6 && angle <= 90.1)
            intersectionPoint = find((y2-y1)== min(abs(y2-y1)),1);

            px = x(intersectionPoint);
            py = y1(intersectionPoint);
            plot(px, py, 'sy');

            
        end

       
    end
    
    k = k + 1;
 
end



