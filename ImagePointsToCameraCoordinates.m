function [ cameraCoordinates ] = ImagePointsToCameraCoordinates(imagePoints, cameraParams)
%GETCAMERACOORDINATES Summary of this function goes here
%   Detailed explanation goes here
undistortedPoints = undistortPoints(imagePoints, cameraParams);
cameraCoordinates = zeros(size(imagePoints, 1), 3);
for i = 1:size(cameraCoordinates, 1)
    cameraCoordinates(i,:) = inv(cameraParams.IntrinsicMatrix') * [undistortedPoints(i,:) 1]';
end
end

