function [ distance ] = ComputeAverageDistanceToRectangle( pointCloud, rectanglePoints)
%COMPUTEAVERAGEDISTANCETORECTANGLE Computes the average distance of all
%points in a point cloud to a given rectangle. This value is used in judging 
%the accuracy of a measured point cloud compared to a ideal representation of the measured rectangle  

%Iterate through all points, compute for each the distance to the rectangle
%and return the mean of all distances
distances = zeros(length(pointCloud), 1)';
for i = 1:length(pointCloud)
   distances(i) = GetDistanceToRectangle(pointCloud(i,:), rectanglePoints);
end
distance = mean(distances);
end

