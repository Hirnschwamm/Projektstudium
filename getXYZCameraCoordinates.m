function [ xyzCameraCoordinates ] = getXYZCameraCoordinates(coordinatesInXYPlane, offset)
%line: x = cameraPosition ([0 0 0]) + scalar * cameraDirection ([coordinatesInXYPlane 1])
%plane: dot(planeNormal, laserPosition) = 0
yOffset = [0 offset 0];
xyzCameraCoordinates = zeros(size(coordinatesInXYPlane, 1), 3);
planeNormal = [0 -1 0];
planePosition = [0 120 0];
for i = 1:size(coordinatesInXYPlane, 1)
    cameraDirection = [coordinatesInXYPlane(i,:) 1];
    scalar = dot(planePosition, planeNormal) / dot(cameraDirection, planeNormal);
    xyzCameraCoordinates(i,:) = scalar * cameraDirection;
    xyzCameraCoordinates(i,:) = xyzCameraCoordinates(i,:) + yOffset;
end
end

