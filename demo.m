%%%%%%%% First task, pointwise transform %%%%%%%%%

% Load image and conversion to gray-scale
x = imread('C:\Users\User\Desktop\dip_hw1_2020\lena.bmp');
x = rgb2gray(x);
x = double(x)/255;

% Plot image and its histogram
figure; imshow(x);
[hn, hx] = hist(x(:), 0:1/255:1);
figure;
bar(hx,hn)

% Point transformation with the given parameters
Y = pointtransform(x,0.1961, 0.0392, 0.8039, 0.9608);


% Point transformation for transforming the image to black & white.
Y = pointtransform(x , 0.5 , 0, 0.5, 1);



%%%%%%%% Second task, transform based on histogram %%%%%%%%%

% Case 1
L = 10; 
v = linspace(0, 1, L); 
h = ones([1, L]) / L; 

Y = histtransfrom(x,h,v);

% Case 2
L = 20; 
v = linspace(0, 1, L); 
h = ones([1, L]) / L; 

Y = histtransfrom(x,h,v);

% Case 3

L = 10; 
v = linspace(0, 1, L); 
h = normpdf(v, 0.5) / sum(normpdf(v, 0.5));

Y = histtransfrom(x,h,v);

%%%%%%%% Third task ,transform based on histogram of given distributions %%%%%%%%%

% uniform on [0,1] with sub-intervals of length 0.1
f = @(x) 1;
d = 0:1/10:1;

h = pdf2hist(d,f);

% Lighting volume based on the middle of each sub-interval
v = zeros(1,size(d,2)-1);
for i=1:size(d,2)-1
    v(i) = (d(i) + d(i+1))/2;
end

% Call histogram
Y = histtransfrom(x,h,v);

% uniform on [0,2] with subintervals of length 0.1
f = @(x) 1;
d = 0:1/10:2;

h = pdf2hist(d,f);

% In this case I am taking this vector v , cause the middle
% of the subinterval will exceed 1 , and I won't be able
% to print a normalized histogram.
v = linspace(0,1,20);

% Call histogram
Y = histtransfrom(x,h,v);



% Gaussian distribution

f = @(x)1/(0.1*sqrt(2*pi))*exp(-1/2*((x-1/2)/0.1).^2);

% Interval [0,1] with step 0.01
d = 0:1/10:1;

% Plot the gaussian for visualization
figure;
plot(d,f(d))

h = pdf2hist(d,f);

% Lighting volume based on the middle of each sub-interval
v = zeros(1,size(d,2)-1);
for i=1:size(d,2)-1
    v(i) = (d(i) + d(i+1))/2;
end

% Call histogram
Y = histtransfrom(x,h,v);



