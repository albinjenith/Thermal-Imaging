function [thermalimage shapSkeleton]=thermalprocess(U)
I=imresize(U,[301 445]);
[r c d]=size(I);
I1=rgb2gray(I);


t=graythresh(I1);
I2=im2bw(I1,t);


%% 2) Thermal Signature Extraction:
% a) Face segmentation

I1=double(I1);
I2=double(I2);
I3=I2.*I1;
I3=uint8(I3);


m = zeros(size(I3,1),size(I3,2));          %-- create initial mask
m(80:103,123:232) = 1;

I4 = imresize(I3,.5);  %-- make image smaller 
m = imresize(m,.5);  %     for fast computation

seg = DFACRS(I4, m, 240); %-- Run segmentation

seg=double(imresize(seg,[r c]));
I3=double(I3);
act_cont_seg=I3.*seg;
act_cont_seg=uint8(act_cont_seg);


% b) Noise removal
num_iter=15;
delta_t=1/7;
kappa = 30;
option = 2;

diff_im = anisodiff2D(act_cont_seg, num_iter, delta_t, kappa, option);
diff_im=uint8(diff_im);


% c) Image morphology
diff_im=double(diff_im);
se = strel('disk',2);
tophatFiltered = imtophat(diff_im,se);
tophatFiltered=~tophatFiltered;               


% d) Postprocessing
interval = [0 1 1; 1  1 1; 0  1  0];
hitmiss = bwhitmiss(tophatFiltered,interval);


imagen_binario_complemento = imcomplement(hitmiss);


imagen_previa = imfill(imagen_binario_complemento ,'holes');


Skeleton = bwmorph(imagen_previa ,'skel',inf);


% e) Generation of thermal signature template
se1 = strel('disk',1);
closeSkeleton = imdilate(Skeleton,se1);


shapSkeleton = bwareaopen(closeSkeleton,30);


temp=double(~shapSkeleton);
thermalimage=I1.*temp;
thermalimage=uint8(thermalimage);

