function [ points ] = extractLineFromMaskedImage( maskedImage, unmaskedImage )
%EXTRACTLINEFROMMASEKDIMAGE Extracts a segmented laserline by computing the
%weighted average of all image rows in each coloumn
[rows, cols, channels] = size(maskedImage);
points = [];
tempImage = maskedImage;
%Iterate through every coloumn in the masked image
for c = 1:cols
    mu = 0;
    summedWeights = 0;
    %Compute the average over all rows weighted by the red value in the
    %current coloumn
    for r = 1:rows
        weight = double(maskedImage(r, c, 1));
        mu = mu + r * weight;  
        summedWeights = summedWeights + weight;
    end
    mu = mu / summedWeights;
    
    if mu > 11 && mu < 710
        preliminaryLaserMiddle = mu;%max(mu, 0);
        
        %"expand" the segmentation with pixels above and below the current
        %average from the unmasked image to smooth the extracted laserline
        tempImage(floor(preliminaryLaserMiddle) - 10 : floor(preliminaryLaserMiddle) + 10, c, 1) = unmaskedImage(floor(preliminaryLaserMiddle) - 10 : floor(preliminaryLaserMiddle) + 10, c, 1);
        
        mu = 0;
        summedWeights = 0;
        %compute the average again, this time with the expanded
        %segmentation
        for r = (floor(preliminaryLaserMiddle) - 10) : (floor(preliminaryLaserMiddle) + 10)
            weight = double(unmaskedImage(r, c, 1));
            mu = mu + r * weight;  
            summedWeights = summedWeights + weight;
        end
        mu = mu / summedWeights;
        points = [points; c max(mu, 0)]; %append the new found average to the points as the row index to the current coloumn
    end
end
end

