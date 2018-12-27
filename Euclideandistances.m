function OutputName = Euclideandistances(Im, m, A, Eigenfaces,datanum)
TestImage=Im;
ProjectedImages = [];
Train_Number = datanum;

for i = 1 : Train_Number
    temp = Eigenfaces'*max(A(:,i)); 
    ProjectedImages = [ProjectedImages temp]; 
end

InputImage = TestImage;
warning('off')

temp = InputImage(:,:,1);

[irow icol] = size(temp);
InImage = double(reshape(temp',irow*icol,1));
Difference = InImage-m; 
ProjectedTestImage = max(max(Eigenfaces'))*Difference; 

Euc_dist = [];
for i = 1 : Train_Number
    q = ProjectedImages(:,i);
    temp = ( norm( ProjectedTestImage - q ) )^2;
    Euc_dist = [Euc_dist temp];
end

[Euc_dist_min , Recognized_index] = min(Euc_dist);
OutputName = strcat(int2str(Recognized_index),'.jpg');






    

    
