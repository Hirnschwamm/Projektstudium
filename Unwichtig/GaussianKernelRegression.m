function [ estimatedPoints ] = GaussianKernelRegression( points, bandwidth)
%GAUSSIANKERNELREGRESSION Summary of this function goes here
%   Detailed explanation goes here
estimatedPoints = zeros(size(points, 1),2);

index = 1;
for i = 1:size(points, 1)
    estimatedPoints(index, :) = [ points(i, 1)  EstimatorNadarayaWatson(points, points(i, 1), bandwidth) ]; 
    index = index + 1;
end

end

function [ estimation ] = EstimatorNadarayaWatson( points, t, h )
seq1 = arrayfun(@(x_j, y_j) RadialBasisKernel(t, x_j, h) * y_j, points(:,1), points(:,2));
seq2 = arrayfun(@(x_j) RadialBasisKernel(t, x_j, h), points(:,1));
estimation = sum(seq1)/ sum(seq2);
end

function [ result ] = RadialBasisKernel( t, x_i, h )
result = exp(-(((t - x_i)^2) / (2 * (h^2))));
end