function [refined_normal] = refine_normal(init_normal, lambda, sigma);
 
%   description:  
%
%   Minimizing the energy function in MRF formulation by graph cut:
%   energy function E(N) = E_data(N) + E_smoothness(N),
%	Data term: 
%		sum_s||N_s - N_alpha_s||
%	"measure the difference between the initial normal and normal at pixel s estimated in the current iteration"
%	Smoothness term: 
%		lambda * sum{t is S's neighbor} log(1 + ||N_alpha_s - N_alpha_t|| / (2 * sigma^2))
%	"measure the difference between neighboring estimated normals"
%
%	note: eg. for teapot lambda = 0.5, sigma = 0.4
%	lambda: depends on the scene and how much discontinuity to be preserved
%	sigma: smaller incurs larger energy term value, penalty for discontinuity larger, output smoother
%

rowNum = size(init_normal,1);
colNum = size(init_normal,2);

TR = IcosahedronMesh;
TR = SubdivideSphericalMesh(TR,5);
labels = TR.X( TR.X(:,3)>0,: );

NumSites = rowNum*colNum;
NumLabels = size(labels,1);

Handle = GCO_Create(NumSites, NumLabels);

% 1. set data cost
%   GCO_SetDataCost(Handle,DataCost) accepts a NumLabels-by-NumSites 
%   int32 matrix where DataCost(k,i) is the cost of assigning 
%   label k to site i.     int32: +- 2147,483,647
DataCost = int32( ( pdist2(labels, reshape(init_normal, rowNum*colNum, 3)) )*10000 );
GCO_SetDataCost(Handle, DataCost);


% 2. set 0-1 neighbor matrix
edgeNum = (rowNum-1)*colNum + (colNum-1)*rowNum;
Si = zeros(edgeNum,1);
Sj = zeros(edgeNum,1);
Sv = ones(edgeNum,1);
cnt = 0;

for i = 1:rowNum
	for j = 1:colNum
		if i < rowNum
			cnt = cnt + 1;
			Si(cnt) = i + (j-1)*rowNum;
			Sj(cnt) = Si(cnt) + 1;
		end
		if j < colNum
			cnt = cnt + 1;
			Si(cnt) = i + (j-1)*rowNum;
			Sj(cnt) = Si(cnt) + rowNum;
		end
	end
end

Weights = sparse(Si, Sj, Sv, NumSites, NumSites);
GCO_SetNeighbors(Handle, Weights);


% 3. set smoothness cost
SmoothCost = int32( lambda * log(1 + pdist2(labels,labels)/(2*sigma*sigma))*10000 );
GCO_SetSmoothCost(Handle, SmoothCost);


GCO_Expansion(Handle);
Labeling = GCO_GetLabeling(Handle);

refined_normal = reshape(labels(Labeling,:), rowNum, colNum, 3);

% show the recovered normal image with L = (1/sqrt(3), 1/sqrt(3), 1/sqrt(3))
figure('Name','refined normal'), ...
    imshow(1/sqrt(3) * refined_normal(:,:,1) + 1/sqrt(3) * refined_normal(:,:,2) + 1/sqrt(3) * refined_normal(:,:,3));
