function [ distance ] = GetDistanceToRectangle( point, rectanglePoints)
%GETDISTANCETOSQUARE Computes the distance of a point in 3D-Space to the
%nearast feature of a specified rectangle

%Define origin-, direction- and normal vectors for the plane specified by
%the rectangle
planeOrigin = rectanglePoints(1,:);
planeDir1 = rectanglePoints(2,:) - rectanglePoints(1,:);
planeDir1 = planeDir1 / norm(planeDir1);
planeDir2 = rectanglePoints(3,:) - rectanglePoints(1,:);
planeDir2 = planeDir2 / norm(planeDir2);
planeNormal = cross(planeDir2, planeDir1);
planeNormal = planeNormal / norm(planeNormal);

%Project point onto the plane. Get the rectangle borders in plane
%coordinates
pointInPlane = [dot(planeDir1, (point - planeOrigin)), dot(planeDir2, (point - planeOrigin))];
rectangleRightBorderPoint = [dot(planeDir1, (rectanglePoints(2,:) - planeOrigin)), dot(planeDir2, (rectanglePoints(2,:) - planeOrigin))];
rectangleLowerBorderPoint = [dot(planeDir1, (rectanglePoints(3,:) - planeOrigin)), dot(planeDir2, (rectanglePoints(3,:) - planeOrigin))];

%The point can not be projected directly onto the rectangle since it is out of the rectangle. Get distance
%to closest edge instead
if (pointInPlane(1) < 0 || pointInPlane(1) > rectangleRightBorderPoint(1)) || ...
   (pointInPlane(2) < 0 || pointInPlane(2) > rectangleLowerBorderPoint(2))

    %Compute all distance to all edges of the rectangle
    edgeDistances = [GetDistanceToEdge(point, rectanglePoints(1,:), rectanglePoints(2,:)), ...
                     GetDistanceToEdge(point, rectanglePoints(2,:), rectanglePoints(4,:)), ...
                     GetDistanceToEdge(point, rectanglePoints(4,:), rectanglePoints(3,:)), ...
                     GetDistanceToEdge(point, rectanglePoints(3,:), rectanglePoints(1,:))];
    distance = min(edgeDistances); %return the smallest distance to an edge or point
    return
end

% Project the point onto the plane normal and take the absolute to get the
% distance from the point to the plane
distance = abs(dot(planeNormal, (point - planeOrigin)));
end

function [ distance ] = GetDistanceToEdge( point, edgePointA, edgePointB )
%GETDISTANCETOEDGE Computes the distance of a point in 3D-Space to the
%nearast feature of a specified edge

a = point - edgePointA;
b = edgePointB - edgePointA;
projectionScalar = dot(a, b / norm(b));

%The point can not be directly projected onto the edge, since it is out of bounds. Get distance to
%closest point instead
if projectionScalar < 0 || projectionScalar > norm(b)
    distance = min(norm(point - edgePointA), norm(point - edgePointB)); 
    return
end

%Project the point onto the edge and return the vector rejection
projection = projectionScalar * (b / norm(b));
rejection = a - projection;
distance = norm(rejection);
end
