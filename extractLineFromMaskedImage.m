function [ points ] = extractLineFromMaskedImage( maskedImage, unmaskedImage )
[rows, cols, channels] = size(maskedImage);
points = [];
tempImage = maskedImage;
for c = 1:cols
    mu = 0;
    summedWeights = 0;
    for r = 1:rows
        weight = double(maskedImage(r, c, 1));
        mu = mu + r * weight;  
        summedWeights = summedWeights + weight;
    end
    mu = mu / summedWeights;
    
   
    if mu > 11 && mu < 710
        preliminaryLaserMiddle = max(mu, 0);
        
        tempImage(floor(preliminaryLaserMiddle) - 10 : floor(preliminaryLaserMiddle) + 10, c, 1) = unmaskedImage(floor(preliminaryLaserMiddle) - 10 : floor(preliminaryLaserMiddle) + 10, c, 1);
        
        mu = 0;
        summedWeights = 0;
        for r = (floor(preliminaryLaserMiddle) - 10) : (floor(preliminaryLaserMiddle) + 10)
            weight = double(unmaskedImage(r, c, 1));
            mu = mu + r * weight;  
            summedWeights = summedWeights + weight;
        end
        mu = mu / summedWeights;
        points = [points; c max(mu, 0)];
    end
end
end

