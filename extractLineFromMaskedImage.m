function [ points ] = extractLineFromMaskedImage( maskedImage )
[rows, cols, channels] = size(maskedImage);
grayScaleMask = rgb2gray(maskedImage);
i = 1;
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
        points(i, 1) = c;
    	points(i, 2) = max(mu, 0);
        i = i + 1;
    end
end
end

