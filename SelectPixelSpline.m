function [ pixelCoordinates ] = SelectPixelSpline( image, plotSpline)
%SELECTPIXELSPLINE Returns the pixel coordinates of a manually specified spline
%   The function returns a x by 2 matrix of pixel coordinates in the given image
%   where the caller specifies a spline by selecting at least two points in the image.
%   The first coloumn of pixelCoordinates specifies the image coloumn
%   (x-coordinate) and the second the image row (y-coordinate) of a point
%   on the spline

% If the parameter is a path, read the image and initilalize variables with
% width and height
 if ischar(image)
     image = imread(image);
 end
 imageWidth = size(image, 2);
 imageHeight = size(image, 1);
 
 % Use Matlab function getpts() to obtain user prompted points in the image
 [x, y] = getpts();
 x = floor(x); %to prevent "floating point" coloumns if user is zoomed in too close
 imageXCoordinates = x(1) : x(length(x)); % The query points for the spline are all coloumns from the beginning (left) to the end of the spline (right)
 imageYCoordinates = spline(x,y,imageXCoordinates); % Use Matlabs spline function to lay a spline through the selected points and map it onto the coloumns
 pixelCoordinates = [imageXCoordinates' imageYCoordinates'];
 
 % Plot the spline if caller specified a second parameter
 if(nargin >= 2)
    plot(imageXCoordinates,imageYCoordinates); xlim([1 imageWidth]); ylim([1 imageHeight]); set (gca,'Ydir','reverse');
 end
end

