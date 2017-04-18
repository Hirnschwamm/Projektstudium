function [ pointCloud ] = GetPointCloudFromImages( folderPath, colourThreshhold, cameraParams, cameraRotation, cameraTranslation, offset, fitFunctionToPixelLine, bandwidth )
%GETPOINTSCLOUDFROMIMAGES Summary of this function goes here
%   Detailed explanation goes here
currentCameraTranslation = cameraTranslation;
files = dir(folderPath);
pointCloud = [];
i = 0;
for sampleFile = files'
    %Ignore the self file, the precursor file, any files that dont end with .png and the calibration image 
    if(strcmp(sampleFile.name,'.') || ...
       strcmp(sampleFile.name, '..') || ...
       ~any(regexp(sampleFile.name, '.png$')) || ...
       any(regexp(sampleFile.name, 'Calibration.png$'))) ...
       
        continue;
    end
    currentImage = imread(strcat(folderPath, '/', sampleFile.name));
    maskYCbCr = MaskImageViaYCbCrThreshold(currentImage, colourThreshhold);
    extractedLineYCbCr = extractLineFromMaskedImage(maskYCbCr);
    if fitFunctionToPixelLine
        extractedLineYCbCr = GaussianKernelRegression(extractedLineYCbCr, bandwidth);
    end
    
    cameraCoordinates = ImagePointsToCameraCoordinates(extractedLineYCbCr, cameraParams);
    worldCoordinates = CameraCoordinatesToWorldCoordinates(cameraCoordinates, cameraRotation, currentCameraTranslation);
    worldCoordinates(:,3) = worldCoordinates(:,3) + i * -offset;
    
    if isempty(pointCloud)
        pointCloud = worldCoordinates;
    else 
        pointCloud = [pointCloud; worldCoordinates];
    end
    
    i = i + 1;
end
end

