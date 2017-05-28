function [ threshold, bestDifference ] = FindOptimalThreshold( image, optimalPixelLine)
%FINDOPTIMALTHRESHOLDYCBCR Returns the optimal Cr-threshold for
%extracting the laser line
threshold = 0;
bestDifference = Inf;
%Loop through possible threshold values
for i = 0.0:0.01:1.0
    %Mask the image with the current threshold
    currentMask = MaskImageViaYCbCrThreshold(image, i);
    %Extract the laserline with the current threshold
    currentExtractedLine = extractLineFromMaskedImage(currentMask, image);
    %Compute the difference between the manual selected and the
    %extracted line
    currentDifference = PixelLineDifference(optimalPixelLine, currentExtractedLine, size(image, 1));
    %If the distence between the lines is smaller than the current best
    %threshold, save the current threshold as the new best one
    if currentDifference < bestDifference
        threshold = i;
        bestDifference = currentDifference;
    end
end
end

