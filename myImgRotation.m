function rotImg = myImgRotation(img,angle)

    % myImgRotation:         - Rotation by area mapping
    %
    %
    % Format:                 rotImg = myImgRotation(img,angle)
    %
    % Input: img             - RGB/grayscale image
    %        angle           - angle to rotate in radians
    %
    % Output: rotImg         - rotated image with black background
    %


    img = imresize(img,0.3);

    degree = angle * 180/pi;
    
    switch mod(degree, 360)
        
    % Special cases
    case 0
        imagerot = img;
    case 90
        imagerot = rot90(img);
    case 180
        imagerot = img(end:-1:1, end:-1:1);
    case 270
        imagerot = rot90(img(end:-1:1, end:-1:1));
        
        
    otherwise
        % rotation matrix
        R = [cos(angle) sin(angle) ; -sin(angle) cos(angle)];
        
        % Figure out the size of the transformed image
        [m,n,p] = size(img);
        dest = round( [1 1; 1 n; m 1; m n]*R );
        dest = bsxfun(@minus, dest, min(dest)) + 1;
        imagerot = zeros([max(dest) p],class(img));
        
        % Map all pixels of the transformed image to the original image
        for i = 1:size(imagerot,1)
            for j = 1:size(imagerot,2)
                
                % Get the original's image pixels, by multiplying 
                % by the transpose(R), which in this case is the 
                % inverse rotation matrix
                source = ([i j] - dest(1,:))*R.';
                
                if all(source >= 1) && all(source <= [m n])
                    
                    % Get all 4 surrounding pixels
                    C = ceil(source);
                    F = floor(source);

                    % Compute the relative areas
                    A = [...
                        ((C(2)-source(2))*(C(1)-source(1))),...
                        ((source(2)-F(2))*(source(1)-F(1)));
                        ((C(2)-source(2))*(source(1)-F(1))),...
                        ((source(2)-F(2))*(C(1)-source(1)))];


                    % Extract colors and re-scale them relative to area
                    cols = bsxfun(@times, A, double(img(F(1):C(1),F(2):C(2),:)));

                    % Assign                     
                    imagerot(i,j,:) = sum(sum(cols),2);
                
                end

            end
        end
    
    end
        
    rotImg = imagerot;
 
end