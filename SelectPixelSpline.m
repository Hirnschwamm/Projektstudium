function [ pixelCoordinates ] = SelectPixelSpline( image, plotSpline)
%SELECTPIXELSPLINE Returns the pixel coordinates of a manually specified spline
%   The function returns a x by 2 matrix of pixel coordinates in the given image
%   where the caller specifies a spline by selecting at least two points in the image.
%   The first coloumn of pixelCoordinates specifies the image coloumn
%   (x-coordinate) and the second the image row (y-coordinate) of a point
%   on the spline. 
 if ischar(image)
     image = imread(image);
 end
 imageWidth = size(image, 2);
 imageHeight = size(image, 1);
 [x, y] = getpts();
 x = floor(x); %to prevent "floating point" coloumns if user is zoomed in too close
 imageXCoordinates = x(1) : x(length(x));
 imageYCoordinates = spline(x,y,imageXCoordinates);
 pixelCoordinates = [imageXCoordinates' imageYCoordinates'];
 
 if(nargin >= 2)
    plot(imageXCoordinates,imageYCoordinates); xlim([1 imageWidth]); ylim([1 imageHeight]); set (gca,'Ydir','reverse');
 end
end

