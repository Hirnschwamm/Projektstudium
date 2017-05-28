function [ pointCloud ] = GetPointCloudFromImages( folderPath, colourThreshhold, cameraParams, cameraRotation, cameraTranslation, offset)
%GETPOINTSCLOUDFROMIMAGES Processes all images in the specified folder,
%extracts the laserline and computes world coordinates for points on the
%laserline

currentCameraTranslation = cameraTranslation;
files = dir(folderPath); %Get all files from the specified path
pointCloud = [];
i = 0;
%Loop through every so obtained image
for sampleFile = files'
    %Ignore the self file, the precursor file, any files that dont end with .png and the calibration image 
    if(strcmp(sampleFile.name,'.') || ...
       strcmp(sampleFile.name, '..') || ...
       ~any(regexp(sampleFile.name, '.png$')) || ...
       any(regexp(sampleFile.name, 'Calibration.png$'))) ...
       
        continue;
    end
    %Read the current image, mask it via the specified Cr-Threshold and
    %extract the laserline in the form of image coordinates from it
    currentImage = imread(strcat(folderPath, '/', sampleFile.name));
    maskYCbCr = MaskImageViaYCbCrThreshold(currentImage, colourThreshhold);
    extractedLineYCbCr = extractLineFromMaskedImage(maskYCbCr, currentImage);
    
    %Convert the image coordinates of the laserline first to camera
    %coordinates and then to world coordinates. Add the offset of the
    %camera onto the z-axis of the computed world coorinates
    cameraCoordinates = ImagePointsToCameraCoordinates(extractedLineYCbCr, cameraParams);
    worldCoordinates = CameraCoordinatesToWorldCoordinates(cameraCoordinates, cameraRotation, currentCameraTranslation);
    worldCoordinates(:,3) = worldCoordinates(:,3) + i * -offset;
    
    %Add the computed world coordinates to the pointcloud
    if isempty(pointCloud)
        pointCloud = worldCoordinates;
    else 
        pointCloud = [pointCloud; worldCoordinates];
    end
    
    i = i + 1;
end
end

