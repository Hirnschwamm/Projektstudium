function [] = CompareYCbCrToRGB(image, optimalLine)

plot(optimalLine(:,1), optimalLine(:,2)); xlim([1 1280]); ylim([1 720]); set (gca,'Ydir','reverse');
hold on;

thresholdYCbCr = FindOptimalThreshold(image, optimalLine, 'ycbcr');
maskYCbCr = MaskImageViaYCbCrThreshold(image, thresholdYCbCr);
extractedLineYCbCr = extractLineFromMaskedImage(maskYCbCr);
diffYCbCr = PixelLineDifference(optimalLine,extractedLineYCbCr, size(image, 1))

plot(extractedLineYCbCr(:,1), extractedLineYCbCr(:,2), '.');
hold on;

bandWidthYCbCr = FindOptimalBandwidth(image, optimalLine, extractedLineYCbCr, 0.5);
fittedLineYCbCr = GaussianKernelRegression(extractedLineYCbCr, bandWidthYCbCr);
diffFittedYCbCr = PixelLineDifference(optimalLine,fittedLineYCbCr, size(image, 1))

plot(fittedLineYCbCr(:,1), fittedLineYCbCr(:,2));
hold on;

thresholdRGB = FindOptimalThreshold(image, optimalLine, 'rgb');
maskRGB = MaskImageViaRGBThreshold(image, thresholdRGB);
extractedLineRGB = extractLineFromMaskedImage(maskRGB);
diffRGB = PixelLineDifference(optimalLine, extractedLineRGB, size(image, 1))

plot(extractedLineRGB(:,1), extractedLineRGB(:,2), '.');
hold on

bandWidthRGB = FindOptimalBandwidth(image, optimalLine, extractedLineRGB, 0.5);
fittedLineRGB = GaussianKernelRegression(extractedLineRGB, bandWidthRGB);
diffFittedRGB = PixelLineDifference(optimalLine,fittedLineRGB, size(image, 1))

plot(fittedLineRGB(:,1), fittedLineRGB(:,2));

legend('Optimal', 'YCbCr', 'YCbCr fitted', 'RGB', 'RGB fitted');
end
