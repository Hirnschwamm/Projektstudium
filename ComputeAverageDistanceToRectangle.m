function [ distance ] = ComputeAverageDistanceToRectangle( pointCloud, rectanglePoints)
%COMPUTEAVERAGEDISTANCETORECTANGLE Summary of this function goes here
%   Detailed explanation goes here
distances = zeros(length(pointCloud), 1)';
for i = 1:length(pointCloud)
   distances(i) = GetDistanceToRectangle(pointCloud(i,:), rectanglePoints);
end
distance = median(distances);
end

