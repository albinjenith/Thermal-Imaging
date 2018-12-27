function [shapSkeleton thermalimage Ioo U out]=enhancement(I)

%% 1) Thermal Infrared Image Registration


[r c d]=size(I);

I1=rgb2gray(I);
figure;imshow(I1);title('gray');
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
figure;imshow(act_cont_seg);title('Face Segmentation');
% b) Noise removal
num_iter=15;
delta_t=1/7;
kappa = 30;
option = 2;

act_cont_seg=double(act_cont_seg);
dircfil = directional_filter(act_cont_seg,45);
dircfil=uint8(dircfil);

diff_im = anisodiff2D(dircfil, num_iter, delta_t, kappa, option);
diff_im=uint8(diff_im);
figure;imshow(diff_im);title('Noise Removal');
% c) Image morphology
diff_im=double(diff_im);
se = strel('disk',2);
tophatFiltered = imtophat(diff_im,se);
tophatFiltered=~tophatFiltered;               
figure;imshow(tophatFiltered);title('TopHat');
% d) Postprocessing
interval = [0 1 1; 1  1 1; 0  1  0];
hitmiss = bwhitmiss(tophatFiltered,interval);

imagen_binario_complemento = imcomplement(hitmiss);
figure;imshow(imagen_binario_complemento);title('dirction1');
imagen_previa = imfill(imagen_binario_complemento ,'holes');

Skeleton = bwmorph(imagen_previa ,'skel',inf);
figure;imshow(Skeleton);title('skeleton');
% e) Generation of thermal signature template
se1 = strel('disk',1);
closeSkeleton = imdilate(Skeleton,se1);

shapSkeleton = bwareaopen(closeSkeleton,30);
figure;imshow(shapSkeleton);title('Image shape Skeleton');

temp=double(~shapSkeleton);
thermalimage=I1.*temp;

thermalimage=uint8(thermalimage);


%% C. Distance-Based Similarity Measure for Thermal Infrared Signatures and Template Matching

TrainDatabasePath =('./DATABASE/');
TrainFiles = dir(TrainDatabasePath);
Train_Number = 0;
  
for i = 1:size(TrainFiles,1)
    if not(strcmp(TrainFiles(i).name,'.')|strcmp(TrainFiles(i).name,'..')|strcmp(TrainFiles(i).name,'Thumbs.db'))
        Train_Number = Train_Number + 1;
    end
end
datanum=Train_Number;

T = [];
                   
for i = 1 : Train_Number
    str = int2str(i);
    str = strcat('\',str,'.jpg');
    str = strcat(TrainDatabasePath,str);
    indata = imread(str);
    img=imresize(indata,[301 445]);
    [r c d]=size(img);
    if d==3
        img = rgb2gray(img);
    else
        img=img;
    end

    [irow icol] = size(img);
    temp = reshape(img',irow*icol,1);
    
    T = [T temp];
    
end
      
m = mean(T,2);
Train_Number = size(T,2);          
A = [];
          
for i = 1 : Train_Number
    temp = double(T(:,i)) - m;
    A = [A temp];
end

L = A'*A;
[V D] = eig(L);
L_eig_vec = [];
          
for i = 1 : size(V,2)
    if( D(i,i)>1 )
        L_eig_vec = [L_eig_vec V(:,i)];
    end
end

Eigenfaces = A'.* max(max(L_eig_vec));
dataimage=img;  
          
OutputName = Euclideandistances(thermalimage,m, A, Eigenfaces,datanum);
        
str = strcat(TrainDatabasePath,OutputName);
U=imread(str);


[dataimg shSkel]=enhanthermalprocess(U);
          
X=shapSkeleton-shSkel;
Xmax=max(max(X));
          
total_matched_percentage=ait_picmatch(thermalimage,dataimg)

if Xmax==0
    if(total_matched_percentage >= 90) 
        X= num2str(total_matched_percentage);
        A_B=sprintf('%s PERCENTAGE *MATCHED*',X);
        out=1;
    else
        X=num2str(total_matched_percentage);
        A_B=sprintf('%s PERCENTAGE *NOT MATCHED*',X);
        OutputName='ImgNotIndB.jpg';
        U=imread(OutputName);
        out=0;
    end
else
    X=num2str(total_matched_percentage);
    A_B=sprintf('%s PERCENTAGE *NOT MATCHED*',X);
    OutputName='ImgNotIndB.jpg';
    U=imread(OutputName);
    out=0;
end

result=imresize(text2im(A_B),[50 600]);

Ioo(:,:,1)=result*255;
Ioo(:,:,2)=0;
Ioo(:,:,3)=0;

