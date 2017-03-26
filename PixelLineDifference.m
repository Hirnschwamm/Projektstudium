function [ difference ] = PixelLineDifference( lineA, lineB )
%PIXELLINEDIFFERENCE Returns a measure to compare the likeness of two pixel
%lines in a given image
%The x-coordinates of both pixellines have to be sorted in ascending order.
%To prevent disparities between the lines due to unequal length, only
%coordinates are compared that share the same x-coordinates
if size(lineA,1) < size(lineB,1)
    shortLine = lineA;
    longLine = lineB;
else
    shortLine = lineB;
    longLine = lineA;
end

for i = 1 : size(shortLine, 1)
    for j = i : size(longLine, 1) 
         if shortLine(i, 1) == longLine(j, 1)
            gatheredDifferences(i) = abs(shortLine(i, 2) - longLine(j, 2));
            break;
         end
    end
end

difference = mean(gatheredDifferences);
end

