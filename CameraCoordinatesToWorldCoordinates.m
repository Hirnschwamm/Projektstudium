function [ worldCoordinates ] = CameraCoordinatesToWorldCoordinates(cameraCoordinates, cameraRotation, cameraTranslation)
%line: x = cameraPosition ([0 0 0]) + scalar * cameraDirection ([coordinatesInXYPlane 1])
%plane: dot(planeNormal, laserPosition) = 0
planeNormal = [0 0 -1]; %world space
camPosition =  -cameraTranslation * inv(cameraRotation); %world space
planePosition = camPosition - [0 0 -120]; %world space
worldCoordinates = zeros(size(cameraCoordinates, 1), 3);
for i = 1:size(cameraCoordinates, 1)
    cameraDirection = cameraCoordinates(i,:) * inv(cameraRotation); %world space
    scalar = dot(planeNormal, planePosition - camPosition) / dot(planeNormal, cameraDirection);
    worldCoordinates(i,:) = camPosition + scalar * cameraDirection;
end
end

 