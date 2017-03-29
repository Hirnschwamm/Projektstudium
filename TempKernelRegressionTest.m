function [ line2 ] = TempKernelRegressionTest( line, h)
%TEMPKERNELREGRESSIONTEST Summary of this function goes here
%   Detailed explanation goes here
plot(line(:,1), line(:,2), '.'); xlim([1 1280]); ylim([1 720]); set (gca,'Ydir','reverse');
hold on
line2 = GaussianKernelRegression(line, h);
plot(line2(:,1), line2(:,2));
end

