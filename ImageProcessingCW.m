close all
clc;

BadImage = imread('badimage.tif');
bwImage = im2bw(BadImage);

figure
subplot(1,3,1)
imshow(BadImage)
title('Original Image')

subplot(1,3,2)
imhist(BadImage)
title('Image Histogram')
xlabel('pixel intensity')
ylabel('number of pixels')

subplot(1,3,3)
BadImage_f = abs(log2(fftshift(fft2(im2double(bwImage)))));
imshow(BadImage_f,[])
title('Spectrum')

figure
[rows, columns, numberOfColorBands] = size(BadImage);
subplot(1, 4, 1);
imshow(BadImage);
title('Original color Image');

set(gcf, 'Position', get(0,'Screensize')); 

redChannel = BadImage(:, :, 1);
greenChannel = BadImage(:, :, 2);
blueChannel = BadImage(:, :, 3);

subplot(1, 4, 2);
imshow(redChannel);
title('Red Channel');

subplot(1, 4, 3);
imshow(greenChannel);
title('Green Channel');

subplot(1, 4, 4);
imshow(blueChannel);
title('Blue Channel');

figure
noisyBadImage = imnoise(BadImage,'salt & pepper', 0.05);
subplot(1, 4, 1);
imshow(noisyBadImage);
title('Image with Salt and Pepper Noise');

redChannel = noisyBadImage(:, :, 1);
greenChannel = noisyBadImage(:, :, 2);
blueChannel = noisyBadImage(:, :, 3);

subplot(1, 4, 2);
imshow(redChannel);
title('Noisy Red Channel');
subplot(1, 4, 3);
imshow(greenChannel);
title('Noisy Green Channel');
subplot(1, 4, 4);
imshow(blueChannel);
title('Noisy Blue Channel');

redMF = medfilt2(redChannel, [3 3]);
greenMF = medfilt2(greenChannel, [3 3]);
blueMF = medfilt2(blueChannel, [3 3]);

figure
noiseImage = (redChannel == 0 | redChannel == 255);
noiseFreeRed = redChannel;
noiseFreeRed(noiseImage) = redMF(noiseImage);

noiseImage = (greenChannel == 0 | greenChannel == 255);
noiseFreeGreen = greenChannel;
noiseFreeGreen(noiseImage) = greenMF(noiseImage);

noiseImage = (blueChannel == 0 | blueChannel == 255);
noiseFreeBlue = blueChannel;
noiseFreeBlue(noiseImage) = blueMF(noiseImage);

rgbFixed = cat(3, noiseFreeRed, noiseFreeGreen, noiseFreeBlue);
imshow(rgbFixed);
title('Restored Image');

figure
FinalImageBC = imrotate(rgbFixed,-215,'bicubic'); 
imshow(FinalImageBC)
title('Bicubic')

figure
[r,c] = find(all(FinalImageBC == 0,2));
rm = unique(r);
FinalImageBC(rm,:,:)=[];

[r,c] = find(all(FinalImageBC == 0,1));
cm = c(c<=size(FinalImageBC,2));
FinalImageBC(:,cm,:)=[];
imshow(FinalImageBC)
title('final image')

finalbwImage = im2bw(FinalImageBC);

% Image rotation comparison
figure
subplot(1,3,1)
BC = imrotate((FinalImageBC),0,'bicubic'); 
imshow(BC)
title('Bicubic')

subplot(1,3,2)
BL = imrotate((FinalImageBC),0,'bilinear'); 
imshow(BL)
title('Bilinear')

subplot(1,3,3)
NN = imrotate((FinalImageBC),0,'nearest'); 
imshow(NN)
title('Nearest neighbour')

% plots showing image, histogram and freq amplitude spectrum after image is
% fixed
figure
subplot(1,3,1)
imshow(FinalImageBC)
title('Original Image')

subplot(1,3,2)
imhist(FinalImageBC)
title('Image Histogram')

subplot(1,3,3)
BadImage_f = abs(log2(fftshift(fft2(im2double(finalbwImage)))));
imshow(BadImage_f,[])
title('Spectrum')