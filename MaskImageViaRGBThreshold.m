function [ maskedImage ] = MaskImageViaRGBThreshold( image, redThreshold )
%CREATEMASKFROMYCBCR Returns an rgb image with blacked out pixels that are below the
%given red threshold between 0.0 and 1.0
I = image(:,:,1) < redThreshold * 255;
maskedImage = image;
maskedImage(repmat(I,[1 1 3])) = 0;
end

