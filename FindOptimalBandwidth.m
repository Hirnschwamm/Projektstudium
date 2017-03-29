function [ bandwidth ] = FindOptimalBandwidth( image, optimalLine, extractedLine, step)
%FINDOPTIMALBANDWIDTH Summary of this function goes here
%   Detailed explanation goes here
bandwidth = 0.0;
bestDifference = Inf;
currentDifference = Inf;
previousDifference = Inf;
i = 0.01;
currentDifferenceIsSmallerThanPrevious = true;
while currentDifferenceIsSmallerThanPrevious %As long as we find lines with smaller differences, continue 
    previousDifference = currentDifference;
    
    currentExtractedLine = GaussianKernelRegression(extractedLine, i);
    currentDifference = PixelLineDifference(optimalLine, currentExtractedLine, size(image, 1));
    
    if currentDifference < bestDifference
        bandwidth = i;
        bestDifference = currentDifference;
    end 
      
    i = i + step;
    
    currentDifferenceIsSmallerThanPrevious = currentDifference < previousDifference;
end
end

