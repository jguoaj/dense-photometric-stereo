function[nearest_neighbour]=compute_nearest_neighbour(canditate_points,given_points)
%This function compute the nearest neighbours (by Euclidean distance) to a set of given points from a set of candidate points
%In this tool, exclusively the really nearest point will be calculated 
%without using a loop. Therefore, the function is very fast but
%supports only a limited set of canditate and given points in 3D. For very large
%input data it can be lead to out of memory errors because the maximum
%adressable memory area of 32-Bit operation systems is located about 2
%GByte (or 3 GByte with a change in the boot of the windows operation
%system).

%INPUT:

%an N1 x 3 matrix of cantitate_points
%an N2 x 3 matrix of given_points (N1 and N2 can be different)

%OUTPUT:

%an N2 x 1 matrix (column) with the numbers of the nearest neighbour points to each canditate point.
%(The number of a row in the nearest neighbour matrix is equivalent to the number of
%the given point in the canditate points matrix)

%start the short but effective function

given_points=given_points';

%calculate the distances for the x, y, and z values from all given
%points to all canditate points

DistanceX=repmat(canditate_points(:,1),[1,length(given_points)])-repmat(given_points(1,:),[length(canditate_points),1]);
DistanceY=repmat(canditate_points(:,2),[1,length(given_points)])-repmat(given_points(2,:),[length(canditate_points),1]);
DistanceZ=repmat(canditate_points(:,3),[1,length(given_points)])-repmat(given_points(3,:),[length(canditate_points),1]);

%determin the square distance from all given points to all canditate points

DistanceX=DistanceX.^2;
DistanceY=DistanceY.^2;
DistanceZ=DistanceZ.^2;
Distance=DistanceX+DistanceY+DistanceZ;

%find the minimum distance

[value,row]=min(Distance);

%write the nearest neighbours in the output matix

nearest_neighbour=row';