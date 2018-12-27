
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% The function takes two images as argument and using edge detection
% checks whether they are the same or not...a cool and simple code which
% can be used in security systems.
% The level at which the two pictures should be matched can be controlled
% by changing the code at line 100.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% USAGE (SAMPLE CODE)
%
%
%       pic1 = imread('cameraman.tif');
%       pic2 = imread('cameraman.tif');
%       ait_picmatch(pic1,pic2);
%       
%       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   

function total_matched_percentage=ait_picmatch(pic1,pic2)

[x,y,z] = size(pic1);
if(z==1)
    ;
else
    pic1 = rgb2gray(pic1);
end

[x,y,z] = size(pic2);
if(z==1)
    ;
else
    pic2 = rgb2gray(pic2);
end



%applying edge detection on first picture
%so that we obtain white and black points and edges of the objects present
%in the picture.

edge_det_pic1 = edge(pic1,'prewitt');

%%applying edge detection on second picture
%so that we obtain white and black points and edges of the objects present
%in the picture.

edge_det_pic2 = edge(pic2,'prewitt');

%definition of different variables to be used in the code below



%initialization of different variables used
matched_data = 0;
white_points = 0;
black_points = 0;
x=0;
y=0;
l=0;
m=0;

%for loop used for detecting black and white points in the picture.
for a = 1:1:256
    for b = 1:1:256
        if(edge_det_pic1(a,b)==1)
            white_points = white_points+1;
        else
            black_points = black_points+1;
        end
    end
end

%for loop comparing the white (edge points) in the two pictures
for i = 1:1:256
    for j = 1:1:256
        if(edge_det_pic1(i,j)==1)&(edge_det_pic2(i,j)==1)
            matched_data = matched_data+1;
            else
                ;
        end
    end
end
    



%calculating percentage matching.
total_data = white_points;
total_matched_percentage = (matched_data/total_data)*100;


