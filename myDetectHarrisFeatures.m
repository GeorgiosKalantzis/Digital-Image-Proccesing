function corners = myDetectHarrisFeatures(I)

    %
    % myDetectHarrisFeatures:      - Implements the Harris corner detector
    %                                algorithm, after downsampling the
    %                                image cause of the O(n^2)
    %                                complexity.And at the end we apply a
    %                                threshold to extract the most
    %                                promiment corners.
    %
    % Format:                       corners = myDetectHarrisFeatures(I)
    %
    % Input:   I                    - grayscale image. 
    %
    % Output:  corners              - coordinates of the corners.
    %
    %
    
    I = imresize(I,0.6);
    
    k = 0.05; % Empirical value
    Threshold = 1;
    sigma = 1;
    halfwid = sigma * 7;
    
    % The grid for the window 
    [xx, yy] = meshgrid(-halfwid:halfwid, -halfwid:halfwid);

    Gxy = exp(-(xx .^ 2 + yy .^ 2) / (2 * sigma ^ 2));

    Gx = xx .* exp(-(xx .^ 2 + yy .^ 2) / (2 * sigma ^ 2));
    Gy = yy .* exp(-(xx .^ 2 + yy .^ 2) / (2 * sigma ^ 2));
    
    numOfRows = size(I, 1);
    numOfColumns = size(I, 2);

    %  Compute x and y derivatives of image
    Ix = conv2(Gx, I);
    Iy = conv2(Gy, I);



    %  Compute products of derivatives at every pixel
    Ix2 = Ix .^ 2;
    Iy2 = Iy .^ 2;
    Ixy = Ix .* Iy;

    % Compute the sums of the products of derivatives at each pixel
    Sx2 = conv2(Gxy, Ix2);
    Sy2 = conv2(Gxy, Iy2);
    Sxy = conv2(Gxy, Ixy);
    
   
    
    im = zeros(numOfRows,numOfColumns);
    for x=1:numOfRows
       for y=1:numOfColumns
           
           %  Define at each pixel(x, y) the matrix H
           H = [Sx2(x, y) Sxy(x, y); Sxy(x, y) Sy2(x, y)];

           %  Compute the response of the detector at each pixel
           R = det(H) - k * (trace(H) ^ 2);

           im(x,y) = R;
       end
    end
    
    
    [row,col] = find(im > Threshold);
    
    corners = [row,col];
  
    
    
end
