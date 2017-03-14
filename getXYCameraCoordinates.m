function [ cameraCoordinates ] = getXYCameraCoordinates(imagePoints, handles)
%GETCAMERACOORDINATES Summary of this function goes here
%   Detailed explanation goes here
R = eye(3,3);
t = [0 0 1];
cameraCoordinates = pointsToWorld(handles.cameraParams, R, t, imagePoints);
%test = inv(handles.cameraParams.IntrinsicMatrix') * [imagePoints(1,:) 1]';
end

