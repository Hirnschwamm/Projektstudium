function [ points ] = extractLineFromMaskedImage( maskedImage, unmaskedImage )
[rows, cols, channels] = size(maskedImage);
grayScaleMask = rgb2gray(maskedImage);
points = [];
for c = 1:cols
    mu = 0;
    summedWeights = 0;
    for r = 1:rows
        weight = double(grayScaleMask(r, c));
        mu = mu + r * weight;  
        summedWeights = summedWeights + weight;
    end
    mu = mu / summedWeights;
    
   
    if mu > 0
        %points2 = [points2; c max(mu, 0)];
        
        preliminaryLaserMiddle = max(mu, 0);
        
        mu = 0;
        summedWeights = 0;
        for r = floor(preliminaryLaserMiddle) - 10 : floor(preliminaryLaserMiddle) + 10
            weight = double(unmaskedImage(r, c, 1));
            mu = mu + r * weight;  
            summedWeights = summedWeights + weight;
        end
        mu = mu / summedWeights;
        points = [points; c max(mu, 0)];
    end
end
end

