function [ResampledImage, L_o] = resampling(dataPath, dataType)

%  Do uniform resampling on images
%
%  See paper section 4.2:
%  seek the nearest light direction L_o at one vertex in the 
%  subdivided icosahedron for each captured light direction L_i, 
%  and interpolate the image I_o at L_o by:
%
%                                                 L_o * L_i' * I_i(x,y)
%  I_o(x,y) = sum_{i | L_i's NN == L_o} * -------------------------------------
%                                          sum_{i | L_i's NN == L_o} L_o * L_i'
% 


% catured light direction L_i
L_i = load([dataPath '/lightvec.txt']);
L_i = normr(L_i);


% Generate icosahedron mesh
TR = IcosahedronMesh;
TR = SubdivideSphericalMesh(TR,4);
vertexCoor = TR.X;  								% vertex coordinates of L_o: n*3 double


% Seek the nearest light direction L_o
Index = compute_nearest_neighbour(vertexCoor, L_i);	% Index same length as L_i, Index into vertexCoor
[uniqueIndex, ~, ic] = unique(Index);			    % uniqueIndex same length as ResampledImage
num_of_ResampledImage = length(uniqueIndex);
L_o = zeros(num_of_ResampledImage, 3);

for i = 1:num_of_ResampledImage
	L_o(i,:) = vertexCoor(uniqueIndex(i),:);
end


% interpolate the image I_o at L_o
file = dir([dataPath dataType]);
num_of_CaptureImage = size(file,1);
weight = zeros(num_of_ResampledImage, 1);
ResampledImage = zeros( [size(imread([dataPath '/' file(1).name])) num_of_ResampledImage] );

for j = 1:num_of_CaptureImage
	cur_image = double(imread([dataPath '/' file(j).name]));
	w = dot( vertexCoor(Index(j),:), L_i(j,:) );
	R_index = ic(j);
	weight(R_index) = weight(R_index) + w;
	ResampledImage(:,:,:,R_index) = ResampledImage(:,:,:,R_index) + w*cur_image;
end

for k = 1:num_of_ResampledImage
	ResampledImage(:,:,:,k) = ResampledImage(:,:,:,k) / weight(k);
end

