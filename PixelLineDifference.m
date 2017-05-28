function [ difference ] = PixelLineDifference( lineA, lineB, penalty )
%PIXELLINEDIFFERENCE Returns a measure to compare the likeness of two pixel
%lines in a given image
%The x-coordinates of both pixellines have to be sorted in ascending order.
%This means the function assumes a "horizontal" pixelline

totalIndex = 1;

%Loop through the coloumns of both pixellines and compute a single
%difference between the lines in every coloumn. Remove a cloumn/row-pair
%for every difference computed and loop as long as both lines still have
%unprocessed pairs
while size(lineA, 1) > 0 || size(lineB, 1) > 0
    %Depending on the size of either lines, compute the difference of the
    %next coloumn for lineA or lineB
    if size(lineB, 1) == 0 || (size(lineA, 1) ~= 0 && lineA(1) < lineB(1))
        [differences(totalIndex), lineA, lineB] = calculateSingleDifference(lineA, lineB, penalty);
    else
        [differences(totalIndex), lineB, lineA] = calculateSingleDifference(lineB, lineA, penalty);
    end 
    totalIndex = totalIndex + 1;
end
%Compute the mean of all gathered differences
difference = mean(differences);
end

%Computes a single difference for the first coloumn in line1 and removes
%the matching coloumn/row-pairs from both lines
function [ difference, newLine1, newLine2 ] = calculateSingleDifference(line1, line2, penalty)
difference = -1;
%Take the first coloumn in line1 and search for a corresponding coloumn in line2 
for i = 1 : size(line2, 1)
    if line2(i, 1) == line1(1, 1)
        %If a corresponding coloumn is found, compute the difference and
        %remove the corresponding coloumn/row-pair from line2
        difference = abs(line1(1, 2) - line2(i, 2));
        line2(i,:) = [];
        break;
    end
end
   
%Return penalty if there no corresponding coloumn is found
if difference < 0
    difference = penalty; 
end

%remove the processed coordinate for line1 and return the altered
%pixellines
line1(1,:) = [];
newLine1 = line1;
newLine2 = line2;
end

