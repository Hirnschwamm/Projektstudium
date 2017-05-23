function [ maskedImage ] = MaskImageViaYCbCrThreshold( image, crThreshold )
%CREATEMASKFROMYCBCR Returns an rgb image with blacked out pixels that are below the
%given Cr-threshold given between 0.0 and 1.0
ycbcrImage = rgb2ycbcr(image);
I = ycbcrImage(:,:,3) < crThreshold * 255;
maskedImage = image;
maskedImage(repmat(I,[1 1 3])) = 0;
end