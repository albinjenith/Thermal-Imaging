function [J,h] = directional_filter(I,arg1)

if ~exist('I','var') || isempty(I)
   I = imread('cameraman.tif');
end
I = mean(double(I),3);


if ~exist('arg1','var') || ~isstruct(arg1)
   

    usageMode = 1;
    

    if ~exist('arg1','var') || isempty(arg1)
      arg1 = 0;
    end
    theta = -arg1*(pi/180);


    if ~exist('arg2','var') || isempty(arg2)
       arg2 = 1;
    end
    sigma = arg2;
    

    if ~exist('arg3','var') || isempty(arg3)
       arg3 = false;
    end
    vis = arg3;    
    
else
    

    usageMode = 2;
    

    h = arg1;
    theta = -h.theta*(pi/180);
    sigma = h.sigma;
    g = h.g;
    gp = h.gp;
    

    if ~exist('arg2','var') || isempty(arg2)
       arg2 = false;
    end
    vis = arg2;    
    
end


if usageMode == 1


   Wx = floor((5/2)*sigma); 
   if Wx < 1
      Wx = 1
   end
   x = [-Wx:Wx];


   g = exp(-(x.^2)/(2*sigma^2));
   gp = -(x/sigma).*exp(-(x.^2)/(2*sigma^2));


   h.g = g;
   h.gp = gp;
   h.theta = -theta*(180/pi);
   h.sigma = sigma;
   
end


Ix = conv2(conv2(I,-gp,'same'),g','same');
Iy = conv2(conv2(I,g,'same'),-gp','same');


J = cos(theta)*Ix+sin(theta)*Iy;


if vis
   figure(1); clf; set(gcf,'Name','Oriented Filtering');
   subplot(2,2,1); imagesc(I); axis image; colormap(gray);
      title('Input Image');
   subplot(2,2,2); imagesc(J); axis image; colormap(gray);
      title(['Filtered Image (\theta = ',num2str(-theta*(180/pi)),'{\circ})']);
   subplot(2,1,2); imagesc(cos(theta)*(g'*gp)+sin(theta)*(gp'*g));
      axis image; colormap(gray);
      title(['Oriented Filter (\theta = ',num2str(-theta*(180/pi)),'{\circ})']);
end
   
