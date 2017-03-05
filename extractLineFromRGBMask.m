function [ points ] = extractLineFromRGBMask( RGBMask )
[rows, cols, channels] = size(RGBMask);
grayScaleMask = rgb2gray(RGBMask);
i = 1;
for c = 1:cols
    mu = 0;
    summedWeights = 0;
    for r = 1:rows
        pixelIntensity = double(grayScaleMask(r, c));
        summedWeights = summedWeights + pixelIntensity;
        mu = mu + r * pixelIntensity;  
    end
    mu = mu / summedWeights;
    if mu > 0
        points(i, 1) = c;
    	points(i, 2) = max(mu, 0);
        i = i + 1;
    end
end
end

