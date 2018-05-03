function [denominator_image, deIndex] = find_denominator_image(images)

%  Selection of the denominator image (least affected by shdows and hightlights): 
%
%  See paper section 4.3 
%  "For each resampled image_i, count the number of pixels whose intensity rank
%  satisfies rank_i > L, where L > median. Let k_L^i be the total number of pixels in image_i 
%  satisfying this condition, r_L^i be the mean rank among the pixels in image_i that satisfies
%  this condition. 
%  The denominator image is defined to be one with 
%  1) maximum k_L and 2) r_L lower than some thresh H. 
%  Currently, we set L and H to be the 70th and 90th percentiles respectively."
%

rowNum = size(images,1);
colNum = size(images,2);
imgNum = size(images,4);

grayImgs = zeros([rowNum colNum imgNum]);
for i = 1:imgNum
	grayImgs(:,:,i) = rgb2gray(images(:,:,:,i)/255);
end

% the third dimention of pixelRank is the rank of grayImg(i,j)
pixelRank = zeros([rowNum colNum imgNum]);
pixelIJ = zeros([1,imgNum]);
for i = 1:rowNum
	for j = 1:colNum
		[~,I] = sort(grayImgs(i,j,:));
		pixelIJ(I) = 1:imgNum;
		pixelRank(i,j,:) = pixelIJ;
	end
end

L = 0.7*imgNum;
H = 0.9*imgNum;
maxkL = -1;
deIndex = -1;

for i = 1:imgNum
	k_L = sum(sum( pixelRank(:,:,i)>L ));
	value = pixelRank(:,:,i) .* (pixelRank(:,:,i) > L); 
	r_L = sum(sum(value)) / k_L;

	if r_L < H
		if k_L > maxkL
			maxkL = k_L;
			deIndex = i;
		end
	end
end

fprintf('max kL is: %d \n', maxkL);
fprintf('denominator index is: %d \n', deIndex);
denominator_image = images(:,:,:,deIndex);
figure('Name','denominator image'), imshow(denominator_image/255)

