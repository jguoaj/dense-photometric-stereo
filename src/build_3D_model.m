function [recsurf] = build_3D_model(refined_normal, texture);

% slant: the angle between the viewing direction and the surface normal
% tilt: describe the rotation about Z axis

rowNum = size(refined_normal,1);
colNum = size(refined_normal,2);

slant = zeros(rowNum,colNum);
tilt = zeros(rowNum,colNum);

for i = 1:rowNum
	for j = 1:colNum
		%nij = squeeze(refined_normal(i,j,:)); 
		nij = squeeze(refined_normal(rowNum+1-i,j,:));
		[slant(i,j), tilt(i,j)] = grad2slanttilt(-nij(1)/nij(3), -nij(2)/nij(3));
	end
end

recsurf = shapeletsurf(slant, tilt, 6, 2, 3);
%figure('Name','surface'), surf(recsurf);

[x, y] = meshgrid(1:colNum, 1:rowNum);
figure('Name','Reconstructed Model'), ...
    h = surf(x,y,recsurf,'FaceColor', [218/255, 113/225, 183/255],'FaceAlpha',0.9,'EdgeColor','none');

% flip texture image for mapping
textureFlip = zeros(size(texture));
for i = 1:3
    textureFlip(:,:,i) = flipud(texture(:,:,i));
end
set(h, 'FaceColor', 'texturemap', 'CData', textureFlip);

camlight left;
lighting phong;
axis vis3d;
daspect([1 1 2])
axis off;
