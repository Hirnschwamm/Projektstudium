function [ difference ] = PixelLineDifference( lineA, lineB, penalty )
%PIXELLINEDIFFERENCE Returns a measure to compare the likeness of two pixel
%lines in a given image
%The x-coordinates of both pixellines have to be sorted in ascending order.
totalIndex = 1;

while size(lineA, 1) > 0 || size(lineB, 1) > 0
    if size(lineB, 1) == 0 || (size(lineA, 1) ~= 0 && lineA(1) < lineB(1))
        [differences(totalIndex), lineA, lineB] = calculateSingleDifference(lineA, lineB, penalty);
    else
        [differences(totalIndex), lineB, lineA] = calculateSingleDifference(lineB, lineA, penalty);
    end 
    totalIndex = totalIndex + 1;
end
difference = mean(differences);
end

function [ difference, newLine1, newLine2 ] = calculateSingleDifference(line1, line2, penalty)
difference = -1;
for i = 1 : size(line2, 1)
    if line2(i, 1) == line1(1, 1)
        difference = abs(line1(1, 2) - line2(i, 2));
        line2(i,:) = [];
        break;
    end
end
    
if difference < 0
    difference = penalty; %penalty if there are no matching x coordinates
end

%remove processed coordinates
line1(1,:) = [];
newLine1 = line1;
newLine2 = line2;
end

