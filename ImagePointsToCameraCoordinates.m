function [ cameraCoordinates ] = ImagePointsToCameraCoordinates(imagePoints, cameraParams)
%GETCAMERACOORDINATES Project points from an image into the camera
%coordinate system

%Undistort points
undistortedPoints = undistortPoints(imagePoints, cameraParams);

% Loop through every image point and multiply the intrinsic camera matrix
% with that point to get the points in the camera coordinate system
cameraCoordinates = zeros(size(imagePoints, 1), 3);
for i = 1:size(cameraCoordinates, 1)
    cameraCoordinates(i,:) = inv(cameraParams.IntrinsicMatrix') * [undistortedPoints(i,:) 1]';
end
end

