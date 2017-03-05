function [ cameraCoordinates ] = getCameraCoordinates( currentSnapshot, imagePoints, handles )
%GETCAMERACOORDINATES Summary of this function goes here
%   Detailed explanation goes here
%cameraCoordinates = zeros(size(imagePoints,1), 3);
%for i = 1:size(imagePoints,1)
%    imagePointHomogenous = [imagePoints(i,:), 1];
%    cameraCoordinates(i,:) = handles.inverseIntrinsicCameraMatrix * imagePointHomogenous';
%end

squareSize = 20;
[currentImagePoints, boardSize] = detectCheckerboardPoints(currentSnapshot);
worldPoints = generateCheckerboardPoints(boardSize, squareSize);
[R, t] = extrinsics(currentImagePoints, worldPoints, handles.cameraParams);
cameraCoordinates = pointsToWorld(handles.cameraParams, R, t, imagePoints);
end

