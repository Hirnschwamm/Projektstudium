function [ rotation, translation ] = GetCameraExtrinsics( image, cameraParams, checkerBoardSquareSizeInMM )
%GETCAMERAEXTRINSICS Computes the extrinsic camera parameters via Matlabs
%extrinsics function

%Get the checkerboard points from the specified image
[imagePoints, boardSize] = detectCheckerboardPoints(image);
%Generate world points on the basis of the checkerboard points
worldPoints = generateCheckerboardPoints(boardSize, checkerBoardSquareSizeInMM);
%Compute and return the extrinsics of the camera that took the image
[rotation, translation] = extrinsics(imagePoints, worldPoints, cameraParams);
end

