function [ threshold, bestDifference ] = FindOptimalThreshold( image, optimalPixelLine, colorspace)
%FINDOPTIMALTHRESHOLDYCBCR Returns the optimal threshold Cr-threshold for
%extracting the laser line
threshold = 0;
bestDifference = Inf;
for i = 0.0:0.01:1.0
    if strcmp(colorspace, 'ycbcr')
        currentMask = MaskImageViaYCbCrThreshold(image, i);
    elseif strcmp(colorspace, 'rgb')
        currentMask = MaskImageViaRGBThreshold(image, i);
    end
    currentExtractedLine = extractLineFromMaskedImage(currentMask);
    currentDifference = PixelLineDifference(optimalPixelLine, currentExtractedLine, size(image, 1));
    if currentDifference < bestDifference
        threshold = i;
        bestDifference = currentDifference;
    end
end
end

