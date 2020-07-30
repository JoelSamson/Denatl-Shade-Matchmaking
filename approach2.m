
    close all;
    fontSize = 14;
 
    %enter the location of the image as in your system
    image=imread('D:\College\Dental Shade Matching 2\Patients Photos\01.jpg');
    %figure,imshow(image);    
    
    gray_image=rgb2gray(image);
   
    lmean=conv2(gray_image,ones(3)/9,'same');
    lstd=stdfilt(gray_image);
    % data(:,1)=image(:);
    data(:,1)=lmean(:);
    data(:,2)=lstd(:);
    D(:,1)=abs(data(:,1)-data(:,2));
    D(:,2)=abs(data(:,1)+data(:,2));
    data=double(D);
%Intialize the cluster number%
cluster=3;

%Call FCM algorithm to cluster the input image%
%[center,MF,obj]=fcm(data,cluster);
[MF,Centers,obj,res]=FCM_EU(data,cluster);

%Calculate Cluster validity index%
RF1=0;
Vpec=0;
for j=1:size(MF,2)
    for i=1:cluster
            RF1 =RF1+ (MF(i,j)^2);
            Vpec = Vpec + MF(i,j)*log(MF(i,j));
    end
end
RF1= RF1/size(MF,2);
Vpc1(cluster)= RF1;
Vpe1 = (-Vpec)/size(MF,2);
Vpe(cluster)= Vpe1;
Vfs(cluster)= res.Vfs ;
Vxb(cluster) = res.vxb ;


%Display the image%
figure
subplot(731); imshow(image,[])  
for i=1:cluster
    imgfi=reshape((MF(i,:,:)),size(image,1),size(image,2));
    subplot(7,3,i+1); imshow(imgfi,[])
    title(['Index No: ' int2str(i)])
end

prompt = {'Enter your option:'};
dlgtitle = 'Input';
dims = [1 35];
definput = {'0'};
answer = inputdlg(prompt,dlgtitle,dims,definput);
i = str2double(answer);
imfgi=reshape((MF(i,:,:)),size(image,1),size(image,2));
imfgi=medfilt2(imfgi,[5 5]);

newi=im2bw(imfgi,graythresh(imfgi));
se=strel('square',15);
iopenned=imopen(newi,se);
iopen=bwareaopen(iopenned,10000);
%figure,imshow(iopen);
    
maskedRgbImage = bsxfun(@times, image, cast(iopen, 'like', image));
%figure,imshow(maskedRgbImage);

 

%convert to lab
cform = makecform('srgb2lab');
lab_Image = applycform(im2double(maskedRgbImage),cform);

	% Extract out the color bands from the original image
	% into 3 separate 2D arrays, one for each color component.
	LChannel = lab_Image(:, :, 1); 
	aChannel = lab_Image(:, :, 2); 
	bChannel = lab_Image(:, :, 3);
    [rows,columns,numberOfColorBands] = size(image);
    
     %enter location of image as per your system   
    Aone=imread('D:\College\Dental Shade Matching 2\Dental Shade Matching\a1.jpg');
    cform = makecform('srgb2lab');
	aone_Image = applycform(im2double(Aone),cform);
    % Extract out the color bands from the original image
	% into 3 separate 2D arrays, one for each color component.
	aoneLChannel = aone_Image(:, :, 1); 
	aoneaChannel = aone_Image(:, :, 2); 
	aonebChannel = aone_Image(:, :, 3); 
    LVector = mean(aoneLChannel); % 1D vector of only the pixels within the masked area.
 	LMean = mean(LVector);
	aVector = mean(aoneaChannel); % 1D vector of only the pixels within the masked area.
	aMean = mean(aVector);
	bVector = mean(aonebChannel); % 1D vector of only the pixels within the masked area.
	bMean = mean(bVector);
    % Get the average lab color value.
	% Make uniform images of only that one single LAB color.
	LStandard = LMean * ones(rows, columns);
	aStandard = aMean * ones(rows, columns);
	bStandard = bMean * ones(rows, columns);
    % Create the delta images: delta L, delta A, and delta B.
	deltaL = LChannel - LStandard;
	deltaa = aChannel - aStandard;
	deltab = bChannel - bStandard;
    % Create the Delta E image.
	% This is an image that represents the color difference.
	% Delta E is the square root of the sum of the squares of the delta images.
	deltaE = sqrt(deltaL .^ 2 + deltaa .^ 2 + deltab .^ 2);
    subplot(7,3,5);imshow(deltaE, []);
    title('A1','FontSize',fontSize);
    
    %enter location of image as per your system
    Aone=imread('D:\College\Dental Shade Matching 2\Dental Shade Matching\a2.jpg');
    cform = makecform('srgb2lab');
	aone_Image = applycform(im2double(Aone),cform);
    % Extract out the color bands from the original image
	% into 3 separate 2D arrays, one for each color component.
	aoneLChannel = aone_Image(:, :, 1); 
	aoneaChannel = aone_Image(:, :, 2); 
	aonebChannel = aone_Image(:, :, 3); 
    LVector = mean(aoneLChannel); % 1D vector of only the pixels within the masked area.
 	LMean = mean(LVector);
	aVector = mean(aoneaChannel); % 1D vector of only the pixels within the masked area.
	aMean = mean(aVector);
	bVector = mean(aonebChannel); % 1D vector of only the pixels within the masked area.
	bMean = mean(bVector);
    % Get the average lab color value.
	% Make uniform images of only that one single LAB color.
	LStandard = LMean * ones(rows, columns);
	aStandard = aMean * ones(rows, columns);
	bStandard = bMean * ones(rows, columns);
    % Create the delta images: delta L, delta A, and delta B.
	deltaL = LChannel - LStandard;
	deltaa = aChannel - aStandard;
	deltab = bChannel - bStandard;
    % Create the Delta E image.
	% This is an image that represents the color difference.
	% Delta E is the square root of the sum of the squares of the delta images.
	deltaE = sqrt(deltaL .^ 2 + deltaa .^ 2 + deltab .^ 2);
    subplot(7,3,6);imshow(deltaE, []);
    title('A2','FontSize',fontSize);
    
    %enter location of image as per your system
    Aone=imread('D:\College\Dental Shade Matching 2\Dental Shade Matching\a3.jpg');
    cform = makecform('srgb2lab');
	aone_Image = applycform(im2double(Aone),cform);
    % Extract out the color bands from the original image
	% into 3 separate 2D arrays, one for each color component.
	aoneLChannel = aone_Image(:, :, 1); 
	aoneaChannel = aone_Image(:, :, 2); 
	aonebChannel = aone_Image(:, :, 3); 
    LVector = mean(aoneLChannel); % 1D vector of only the pixels within the masked area.
 	LMean = mean(LVector);
	aVector = mean(aoneaChannel); % 1D vector of only the pixels within the masked area.
	aMean = mean(aVector);
	bVector = mean(aonebChannel); % 1D vector of only the pixels within the masked area.
	bMean = mean(bVector);
    % Get the average lab color value.
	% Make uniform images of only that one single LAB color.
	LStandard = LMean * ones(rows, columns);
	aStandard = aMean * ones(rows, columns);
	bStandard = bMean * ones(rows, columns);
    % Create the delta images: delta L, delta A, and delta B.
	deltaL = LChannel - LStandard;
	deltaa = aChannel - aStandard;
	deltab = bChannel - bStandard;
    % Create the Delta E image.
	% This is an image that represents the color difference.
	% Delta E is the square root of the sum of the squares of the delta images.
	deltaE = sqrt(deltaL .^ 2 + deltaa .^ 2 + deltab .^ 2);
    subplot(7,3,7);imshow(deltaE, []);
    title('A3','FontSize',fontSize);

    %enter location of image as per your system
    Aone=imread('D:\College\Dental Shade Matching 2\Dental Shade Matching\a3_5.jpg');
    cform = makecform('srgb2lab');
	aone_Image = applycform(im2double(Aone),cform);
    % Extract out the color bands from the original image
	% into 3 separate 2D arrays, one for each color component.
	aoneLChannel = aone_Image(:, :, 1); 
	aoneaChannel = aone_Image(:, :, 2); 
	aonebChannel = aone_Image(:, :, 3); 
    LVector = mean(aoneLChannel); % 1D vector of only the pixels within the masked area.
 	LMean = mean(LVector);
	aVector = mean(aoneaChannel); % 1D vector of only the pixels within the masked area.
	aMean = mean(aVector);
	bVector = mean(aonebChannel); % 1D vector of only the pixels within the masked area.
	bMean = mean(bVector);
    % Get the average lab color value.
	% Make uniform images of only that one single LAB color.
	LStandard = LMean * ones(rows, columns);
	aStandard = aMean * ones(rows, columns);
	bStandard = bMean * ones(rows, columns);
    % Create the delta images: delta L, delta A, and delta B.
	deltaL = LChannel - LStandard;
	deltaa = aChannel - aStandard;
	deltab = bChannel - bStandard;
    % Create the Delta E image.
	% This is an image that represents the color difference.
	% Delta E is the square root of the sum of the squares of the delta images.
	deltaE = sqrt(deltaL .^ 2 + deltaa .^ 2 + deltab .^ 2);
    subplot(7,3,8);imshow(deltaE, []);
    title('A3.5','FontSize',fontSize);
    
    %enter location of image as per your system
    Aone=imread('D:\College\Dental Shade Matching 2\Dental Shade Matching\a4.jpg');
    cform = makecform('srgb2lab');
	aone_Image = applycform(im2double(Aone),cform);
    % Extract out the color bands from the original image
	% into 3 separate 2D arrays, one for each color component.
	aoneLChannel = aone_Image(:, :, 1); 
	aoneaChannel = aone_Image(:, :, 2); 
	aonebChannel = aone_Image(:, :, 3); 
    LVector = mean(aoneLChannel); % 1D vector of only the pixels within the masked area.
 	LMean = mean(LVector);
	aVector = mean(aoneaChannel); % 1D vector of only the pixels within the masked area.
	aMean = mean(aVector);
	bVector = mean(aonebChannel); % 1D vector of only the pixels within the masked area.
	bMean = mean(bVector);
    % Get the average lab color value.
	% Make uniform images of only that one single LAB color.
	LStandard = LMean * ones(rows, columns);
	aStandard = aMean * ones(rows, columns);
	bStandard = bMean * ones(rows, columns);
    % Create the delta images: delta L, delta A, and delta B.
	deltaL = LChannel - LStandard;
	deltaa = aChannel - aStandard;
	deltab = bChannel - bStandard;
    % Create the Delta E image.
	% This is an image that represents the color difference.
	% Delta E is the square root of the sum of the squares of the delta images.
	deltaE = sqrt(deltaL .^ 2 + deltaa .^ 2 + deltab .^ 2);
    subplot(7,3,9);imshow(deltaE, []);
    title('A4','FontSize',fontSize);
    
    %enter location of image as per your system
    Aone=imread('D:\College\Dental Shade Matching 2\Dental Shade Matching\b1.jpg');
    cform = makecform('srgb2lab');
	aone_Image = applycform(im2double(Aone),cform);
    % Extract out the color bands from the original image
	% into 3 separate 2D arrays, one for each color component.
	aoneLChannel = aone_Image(:, :, 1); 
	aoneaChannel = aone_Image(:, :, 2); 
	aonebChannel = aone_Image(:, :, 3); 
    LVector = mean(aoneLChannel); % 1D vector of only the pixels within the masked area.
 	LMean = mean(LVector);
	aVector = mean(aoneaChannel); % 1D vector of only the pixels within the masked area.
	aMean = mean(aVector);
	bVector = mean(aonebChannel); % 1D vector of only the pixels within the masked area.
	bMean = mean(bVector);
    % Get the average lab color value.
	% Make uniform images of only that one single LAB color.
	LStandard = LMean * ones(rows, columns);
	aStandard = aMean * ones(rows, columns);
	bStandard = bMean * ones(rows, columns);
    % Create the delta images: delta L, delta A, and delta B.
	deltaL = LChannel - LStandard;
	deltaa = aChannel - aStandard;
	deltab = bChannel - bStandard;
    % Create the Delta E image.
	% This is an image that represents the color difference.
	% Delta E is the square root of the sum of the squares of the delta images.
	deltaE = sqrt(deltaL .^ 2 + deltaa .^ 2 + deltab .^ 2);
    subplot(7,3,10);imshow(deltaE, []);
    title('B1','FontSize',fontSize);
    
    %enter location of image as per your system
    Aone=imread('D:\College\Dental Shade Matching 2\Dental Shade Matching\b2.jpg');
    cform = makecform('srgb2lab');
	aone_Image = applycform(im2double(Aone),cform);
    % Extract out the color bands from the original image
	% into 3 separate 2D arrays, one for each color component.
	aoneLChannel = aone_Image(:, :, 1); 
	aoneaChannel = aone_Image(:, :, 2); 
	aonebChannel = aone_Image(:, :, 3); 
    LVector = mean(aoneLChannel); % 1D vector of only the pixels within the masked area.
 	LMean = mean(LVector);
	aVector = mean(aoneaChannel); % 1D vector of only the pixels within the masked area.
	aMean = mean(aVector);
	bVector = mean(aonebChannel); % 1D vector of only the pixels within the masked area.
	bMean = mean(bVector);
    % Get the average lab color value.
	% Make uniform images of only that one single LAB color.
	LStandard = LMean * ones(rows, columns);
	aStandard = aMean * ones(rows, columns);
	bStandard = bMean * ones(rows, columns);
    % Create the delta images: delta L, delta A, and delta B.
	deltaL = LChannel - LStandard;
	deltaa = aChannel - aStandard;
	deltab = bChannel - bStandard;
    % Create the Delta E image.
	% This is an image that represents the color difference.
	% Delta E is the square root of the sum of the squares of the delta images.
	deltaE = sqrt(deltaL .^ 2 + deltaa .^ 2 + deltab .^ 2);
    subplot(7,3,11);imshow(deltaE, []);
    title('B2','FontSize',fontSize);
    
    %enter location of image as per your system
    Aone=imread('D:\College\Dental Shade Matching 2\Dental Shade Matching\b3.jpg');
    cform = makecform('srgb2lab');
	aone_Image = applycform(im2double(Aone),cform);
    % Extract out the color bands from the original image
	% into 3 separate 2D arrays, one for each color component.
	aoneLChannel = aone_Image(:, :, 1); 
	aoneaChannel = aone_Image(:, :, 2); 
	aonebChannel = aone_Image(:, :, 3); 
    LVector = mean(aoneLChannel); % 1D vector of only the pixels within the masked area.
 	LMean = mean(LVector);
	aVector = mean(aoneaChannel); % 1D vector of only the pixels within the masked area.
	aMean = mean(aVector);
	bVector = mean(aonebChannel); % 1D vector of only the pixels within the masked area.
	bMean = mean(bVector);
    % Get the average lab color value.
	% Make uniform images of only that one single LAB color.
	LStandard = LMean * ones(rows, columns);
	aStandard = aMean * ones(rows, columns);
	bStandard = bMean * ones(rows, columns);
    % Create the delta images: delta L, delta A, and delta B.
	deltaL = LChannel - LStandard;
	deltaa = aChannel - aStandard;
	deltab = bChannel - bStandard;
    % Create the Delta E image.
	% This is an image that represents the color difference.
	% Delta E is the square root of the sum of the squares of the delta images.
	deltaE = sqrt(deltaL .^ 2 + deltaa .^ 2 + deltab .^ 2);
    subplot(7,3,12);imshow(deltaE, []);
    title('B3','FontSize',fontSize);
    
    %enter location of image as per your system
    Aone=imread('D:\College\Dental Shade Matching 2\Dental Shade Matching\b4.jpg');
    cform = makecform('srgb2lab');
	aone_Image = applycform(im2double(Aone),cform);
    % Extract out the color bands from the original image
	% into 3 separate 2D arrays, one for each color component.
	aoneLChannel = aone_Image(:, :, 1); 
	aoneaChannel = aone_Image(:, :, 2); 
	aonebChannel = aone_Image(:, :, 3); 
    LVector = mean(aoneLChannel); % 1D vector of only the pixels within the masked area.
 	LMean = mean(LVector);
	aVector = mean(aoneaChannel); % 1D vector of only the pixels within the masked area.
	aMean = mean(aVector);
	bVector = mean(aonebChannel); % 1D vector of only the pixels within the masked area.
	bMean = mean(bVector);
    % Get the average lab color value.
	% Make uniform images of only that one single LAB color.
	LStandard = LMean * ones(rows, columns);
	aStandard = aMean * ones(rows, columns);
	bStandard = bMean * ones(rows, columns);
    % Create the delta images: delta L, delta A, and delta B.
	deltaL = LChannel - LStandard;
	deltaa = aChannel - aStandard;
	deltab = bChannel - bStandard;
    % Create the Delta E image.
	% This is an image that represents the color difference.
	% Delta E is the square root of the sum of the squares of the delta images.
	deltaE = sqrt(deltaL .^ 2 + deltaa .^ 2 + deltab .^ 2);
    subplot(7,3,13);imshow(deltaE, []);
    title('B4','FontSize',fontSize);
    
    %enter location of image as per your system
    Aone=imread('D:\College\Dental Shade Matching 2\Dental Shade Matching\c1.jpg');
    cform = makecform('srgb2lab');
	aone_Image = applycform(im2double(Aone),cform);
    % Extract out the color bands from the original image
	% into 3 separate 2D arrays, one for each color component.
	aoneLChannel = aone_Image(:, :, 1); 
	aoneaChannel = aone_Image(:, :, 2); 
	aonebChannel = aone_Image(:, :, 3); 
    LVector = mean(aoneLChannel); % 1D vector of only the pixels within the masked area.
 	LMean = mean(LVector);
	aVector = mean(aoneaChannel); % 1D vector of only the pixels within the masked area.
	aMean = mean(aVector);
	bVector = mean(aonebChannel); % 1D vector of only the pixels within the masked area.
	bMean = mean(bVector);
    % Get the average lab color value.
	% Make uniform images of only that one single LAB color.
	LStandard = LMean * ones(rows, columns);
	aStandard = aMean * ones(rows, columns);
	bStandard = bMean * ones(rows, columns);
    % Create the delta images: delta L, delta A, and delta B.
	deltaL = LChannel - LStandard;
	deltaa = aChannel - aStandard;
	deltab = bChannel - bStandard;
    % Create the Delta E image.
	% This is an image that represents the color difference.
	% Delta E is the square root of the sum of the squares of the delta images.
	deltaE = sqrt(deltaL .^ 2 + deltaa .^ 2 + deltab .^ 2);
    subplot(7,3,14);imshow(deltaE, []);
    title('C1','FontSize',fontSize);
    
    %enter location of image as per your system
    Aone=imread('D:\College\Dental Shade Matching 2\Dental Shade Matching\c2.jpg');
    cform = makecform('srgb2lab');
	aone_Image = applycform(im2double(Aone),cform);
    % Extract out the color bands from the original image
	% into 3 separate 2D arrays, one for each color component.
	aoneLChannel = aone_Image(:, :, 1); 
	aoneaChannel = aone_Image(:, :, 2); 
	aonebChannel = aone_Image(:, :, 3); 
    LVector = mean(aoneLChannel); % 1D vector of only the pixels within the masked area.
 	LMean = mean(LVector);
	aVector = mean(aoneaChannel); % 1D vector of only the pixels within the masked area.
	aMean = mean(aVector);
	bVector = mean(aonebChannel); % 1D vector of only the pixels within the masked area.
	bMean = mean(bVector);
    % Get the average lab color value.
	% Make uniform images of only that one single LAB color.
	LStandard = LMean * ones(rows, columns);
	aStandard = aMean * ones(rows, columns);
	bStandard = bMean * ones(rows, columns);
    % Create the delta images: delta L, delta A, and delta B.
	deltaL = LChannel - LStandard;
	deltaa = aChannel - aStandard;
	deltab = bChannel - bStandard;
    % Create the Delta E image.
	% This is an image that represents the color difference.
	% Delta E is the square root of the sum of the squares of the delta images.
	deltaE = sqrt(deltaL .^ 2 + deltaa .^ 2 + deltab .^ 2);
    subplot(7,3,15);imshow(deltaE, []);
    title('C2','FontSize',fontSize);
    
    
    %enter location as per your system
    Aone=imread('D:\College\Dental Shade Matching 2\Dental Shade Matching\c3.jpg');
    cform = makecform('srgb2lab');
	aone_Image = applycform(im2double(Aone),cform);
    % Extract out the color bands from the original image
	% into 3 separate 2D arrays, one for each color component.
	aoneLChannel = aone_Image(:, :, 1); 
	aoneaChannel = aone_Image(:, :, 2); 
	aonebChannel = aone_Image(:, :, 3); 
    LVector = mean(aoneLChannel); % 1D vector of only the pixels within the masked area.
 	LMean = mean(LVector);
	aVector = mean(aoneaChannel); % 1D vector of only the pixels within the masked area.
	aMean = mean(aVector);
	bVector = mean(aonebChannel); % 1D vector of only the pixels within the masked area.
	bMean = mean(bVector);
    % Get the average lab color value.
	% Make uniform images of only that one single LAB color.
	LStandard = LMean * ones(rows, columns);
	aStandard = aMean * ones(rows, columns);
	bStandard = bMean * ones(rows, columns);
    % Create the delta images: delta L, delta A, and delta B.
	deltaL = LChannel - LStandard;
	deltaa = aChannel - aStandard;
	deltab = bChannel - bStandard;
    % Create the Delta E image.
	% This is an image that represents the color difference.
	% Delta E is the square root of the sum of the squares of the delta images.
	deltaE = sqrt(deltaL .^ 2 + deltaa .^ 2 + deltab .^ 2);
    subplot(7,3,16);imshow(deltaE, []);
    title('c3','FontSize',fontSize);
    
    %enter location as per your system
    Aone=imread('D:\College\Dental Shade Matching 2\Dental Shade Matching\c4.jpg');
    cform = makecform('srgb2lab');
	aone_Image = applycform(im2double(Aone),cform);
    % Extract out the color bands from the original image
	% into 3 separate 2D arrays, one for each color component.
	aoneLChannel = aone_Image(:, :, 1); 
	aoneaChannel = aone_Image(:, :, 2); 
	aonebChannel = aone_Image(:, :, 3); 
    LVector = mean(aoneLChannel); % 1D vector of only the pixels within the masked area.
 	LMean = mean(LVector);
	aVector = mean(aoneaChannel); % 1D vector of only the pixels within the masked area.
	aMean = mean(aVector);
	bVector = mean(aonebChannel); % 1D vector of only the pixels within the masked area.
	bMean = mean(bVector);
    % Get the average lab color value.
	% Make uniform images of only that one single LAB color.
	LStandard = LMean * ones(rows, columns);
	aStandard = aMean * ones(rows, columns);
	bStandard = bMean * ones(rows, columns);
    % Create the delta images: delta L, delta A, and delta B.
	deltaL = LChannel - LStandard;
	deltaa = aChannel - aStandard;
	deltab = bChannel - bStandard;
    % Create the Delta E image.
	% This is an image that represents the color difference.
	% Delta E is the square root of the sum of the squares of the delta images.
	deltaE = sqrt(deltaL .^ 2 + deltaa .^ 2 + deltab .^ 2);
    subplot(7,3,17);imshow(deltaE, []);
    title('C4','FontSize',fontSize);
    
    %enter location as per your system
    Aone=imread('D:\College\Dental Shade Matching 2\Dental Shade Matching\d2.jpg');
    cform = makecform('srgb2lab');
	aone_Image = applycform(im2double(Aone),cform);
    % Extract out the color bands from the original image
	% into 3 separate 2D arrays, one for each color component.
	aoneLChannel = aone_Image(:, :, 1); 
	aoneaChannel = aone_Image(:, :, 2); 
	aonebChannel = aone_Image(:, :, 3); 
    LVector = mean(aoneLChannel); % 1D vector of only the pixels within the masked area.
 	LMean = mean(LVector);
	aVector = mean(aoneaChannel); % 1D vector of only the pixels within the masked area.
	aMean = mean(aVector);
	bVector = mean(aonebChannel); % 1D vector of only the pixels within the masked area.
	bMean = mean(bVector);
    % Get the average lab color value.
	% Make uniform images of only that one single LAB color.
	LStandard = LMean * ones(rows, columns);
	aStandard = aMean * ones(rows, columns);
	bStandard = bMean * ones(rows, columns);
    % Create the delta images: delta L, delta A, and delta B.
	deltaL = LChannel - LStandard;
	deltaa = aChannel - aStandard;
	deltab = bChannel - bStandard;
    % Create the Delta E image.
	% This is an image that represents the color difference.
	% Delta E is the square root of the sum of the squares of the delta images.
	deltaE = sqrt(deltaL .^ 2 + deltaa .^ 2 + deltab .^ 2);
    subplot(7,3,18);imshow(deltaE, []);
    title('D2','FontSize',fontSize);
    
    
    %enter location as per your system
    Aone=imread('D:\College\Dental Shade Matching 2\Dental Shade Matching\d3.jpg');
    cform = makecform('srgb2lab');
	aone_Image = applycform(im2double(Aone),cform);
    % Extract out the color bands from the original image
	% into 3 separate 2D arrays, one for each color component.
	aoneLChannel = aone_Image(:, :, 1); 
	aoneaChannel = aone_Image(:, :, 2); 
	aonebChannel = aone_Image(:, :, 3); 
    LVector = mean(aoneLChannel); % 1D vector of only the pixels within the masked area.
 	LMean = mean(LVector);
	aVector = mean(aoneaChannel); % 1D vector of only the pixels within the masked area.
	aMean = mean(aVector);
	bVector = mean(aonebChannel); % 1D vector of only the pixels within the masked area.
	bMean = mean(bVector);
    % Get the average lab color value.
	% Make uniform images of only that one single LAB color.
	LStandard = LMean * ones(rows, columns);
	aStandard = aMean * ones(rows, columns);
	bStandard = bMean * ones(rows, columns);
    % Create the delta images: delta L, delta A, and delta B.
	deltaL = LChannel - LStandard;
	deltaa = aChannel - aStandard;
	deltab = bChannel - bStandard;
    % Create the Delta E image.
	% This is an image that represents the color difference.
	% Delta E is the square root of the sum of the squares of the delta images.
	deltaE = sqrt(deltaL .^ 2 + deltaa .^ 2 + deltab .^ 2);
    subplot(7,3,19);imshow(deltaE, []);
    title('D3','FontSize',fontSize);
    
    
    %enter location as per your system
    Aone=imread('D:\College\Dental Shade Matching 2\Dental Shade Matching\d4.jpg');
    cform = makecform('srgb2lab');
	aone_Image = applycform(im2double(Aone),cform);
    % Extract out the color bands from the original image
	% into 3 separate 2D arrays, one for each color component.
	aoneLChannel = aone_Image(:, :, 1); 
	aoneaChannel = aone_Image(:, :, 2); 
	aonebChannel = aone_Image(:, :, 3); 
    LVector = mean(aoneLChannel); % 1D vector of only the pixels within the masked area.
 	LMean = mean(LVector);
	aVector = mean(aoneaChannel); % 1D vector of only the pixels within the masked area.
	aMean = mean(aVector);
	bVector = mean(aonebChannel); % 1D vector of only the pixels within the masked area.
	bMean = mean(bVector);
    % Get the average lab color value.
	% Make uniform images of only that one single LAB color.
	LStandard = LMean * ones(rows, columns);
	aStandard = aMean * ones(rows, columns);
	bStandard = bMean * ones(rows, columns);
    % Create the delta images: delta L, delta A, and delta B.
	deltaL = LChannel - LStandard;
	deltaa = aChannel - aStandard;
	deltab = bChannel - bStandard;
    % Create the Delta E image.
	% This is an image that represents the color difference.
	% Delta E is the square root of the sum of the squares of the delta images.
	deltaE = sqrt(deltaL .^ 2 + deltaa .^ 2 + deltab .^ 2);
    subplot(7,3,20);imshow(deltaE, []);
    title('D4','FontSize',fontSize);
