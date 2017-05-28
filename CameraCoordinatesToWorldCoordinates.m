function [ worldCoordinates ] = CameraCoordinatesToWorldCoordinates(cameraCoordinates, cameraRotation, cameraTranslation)
%CAMERACOORDINATESTOWORLDCOORDINATES Converts camera coordinates to to
%world coordinates computing the intersection of the line the point is on
%with the plane the point is also on

%line: x = cameraPosition ([0 0 0]) + scalar * cameraDirection ([coordinatesInXYPlane 1])
%plane: dot(planeNormal, laserPosition) = 0
planeNormal = [0 0 -1]; %world space
camPosition =  -cameraTranslation * inv(cameraRotation); %world space
planePosition = camPosition - [0 0 -120]; %world space
worldCoordinates = zeros(size(cameraCoordinates, 1), 3);
%Iterate through every camera coordinate 
for i = 1:size(cameraCoordinates, 1)
    % Convert the directional vector of the line into world coordinates
    cameraDirection = cameraCoordinates(i,:) * inv(cameraRotation);  
    %Compute the world coordinate of the current camera coordinate by computing the correct scalar and apply it in the line equation
    scalar = dot(planeNormal, planePosition - camPosition) / dot(planeNormal, cameraDirection);
    worldCoordinates(i,:) = camPosition + scalar * cameraDirection;  
end
end

 