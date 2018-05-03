function [init_normal] = initial_normal(resampled_images, L_o, denominator_image, deIndex)

%  Initial local normal estimation by ratio images
%      
%  Every pixel in an ratio image is expressed by:
%           I_1     N * L_1
%          ----- = ---------
%           I_2     N * L_2
%
%  can be transform into form of A_x*N_x + A_y*N_y + A_z*N_z = 0
%  where A(k) = I_1 * L_2(k) - I_2 * L_1(k)
%  take denominator image as reference, construct k-1 equations,
%  ==> Solve AX = 0 by SVD, which explicitly enforces ||N|| = 1
%

rowNum = size(resampled_images,1);
colNum = size(resampled_images,2);
imgNum = size(resampled_images,4);
init_normal = zeros([rowNum colNum 3]);

grayImgs = zeros([rowNum colNum imgNum]);
for i = 1:imgNum
	grayImgs(:,:,i) = rgb2gray(resampled_images(:,:,:,i)/255);
end

L2x = L_o(deIndex,1); L2y = L_o(deIndex,2); L2z = L_o(deIndex,3);
for i = 1:rowNum
	for j = 1:colNum
		Matrix = zeros([0 3]);
		for k = 1:imgNum
			if k == deIndex
				continue
			end
			I1 = grayImgs(i,j,k);	I2 = grayImgs(i,j,deIndex);
			L1x = L_o(k,1); L1y = L_o(k,2); L1z = L_o(k,3);
			
			A = I1*L2x - I2*L1x;
			B = I1*L2y - I2*L1y;
			C = I1*L2z - I2*L1z;
			Matrix = [Matrix; A B C];
			[~,~,V] = svd(Matrix,0);
			% reverse normals with negative z
			init_normal(i,j,:) = sign(V(3,3))*V(:,3); 
			%init_normal(i,j,:) = V(:,end);
		end

	end
end

% show the recovered normal image with L = (1/sqrt(3), 1/sqrt(3), 1/sqrt(3))
figure('Name','initial normal'), ...
    imshow(1/sqrt(3) * init_normal(:,:,1) + 1/sqrt(3) * init_normal(:,:,2) + 1/sqrt(3) * init_normal(:,:,3));
