PointCloudCube = load('MeasuredPointCloudCube.mat');
slopeIdeal = [43 20.5 -40; 103 20.5 -40; 43 60.5 0; 103 60.5 0];
Difference = ComputeAverageDistanceToRectangle(PointCloudCube.MeasuredPointCloudCube, slopeIdeal)
PlotPointCloud(PointCloudCube.MeasuredPointCloudCube);
patch([64.5 124 124 64],[60 60 60 60],[0 0 -60 -60], 'red');