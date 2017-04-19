PointCloudSlope = load('MeasuredPointCloudSlope.mat');
slopeIdeal = [43 20.5 -40; 103 20.5 -40; 43 60.5 0; 103 60.5 0];
Difference = ComputeAverageDistanceToRectangle(PointCloudSlope.PointCloudSlope, slopeIdeal)
PlotPointCloud(PointCloudSlope.PointCloudSlope);
patch([43 103 103 43],[60.5 60.5 20.5 20.5],[0 0 -40 -40], 'red');