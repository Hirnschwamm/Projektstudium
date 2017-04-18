function [ rotation, translation ] = GetCameraExtrinsics( image, cameraParams, checkerBoardSquareSizeInMM )
%GETCAMERAEXTRINSICS Summary of this function goes here
%   Detailed explanation goes here
[imagePoints, boardSize] = detectCheckerboardPoints(image);
worldPoints = generateCheckerboardPoints(boardSize, checkerBoardSquareSizeInMM);
[rotation, translation] = extrinsics(imagePoints, worldPoints, cameraParams);
end

