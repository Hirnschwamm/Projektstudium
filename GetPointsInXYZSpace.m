function [ pointsInXYZSpace ] = GetPointsInXYZSpace(currentSnapshot, coordinatesInXYPlane, handles )

squareSize = 20;
[currentImagePoints, boardSize] = detectCheckerboardPoints(currentSnapshot);
worldPoints = generateCheckerboardPoints(boardSize, squareSize);
[R, t] = extrinsics(currentImagePoints, worldPoints, handles.cameraParams);

%line: x = cameraPosition (t) + scalar * cameraDirection ([coordinatesInXYPlane 1] - t)
%plane: dot(planeNormal, laserPosition) = 0
pointsInXYZSpace = zeros(size(coordinatesInXYPlane, 1), 3);

planeNormal = [0 0 1];
laserPosition = t - [0 0 120];
for i = 1:size(coordinatesInXYPlane, 1)
    cameraDirection = [coordinatesInXYPlane(i,:) 1] - t;
    scalar = dot(laserPosition - t, planeNormal) / dot(cameraDirection, planeNormal);
    pointsInXYZSpace(i,:) = t + scalar * cameraDirection;
end

end

