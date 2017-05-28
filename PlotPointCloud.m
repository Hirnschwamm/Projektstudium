function [ ] = PlotPointCloud( pc )
%GETPOINTCLOUDANDPLOTIT Plots a point cloud via plot3
%   This function sets up the axes object to diplay the point cloud
%   correctly
plot3(pc(:,1), pc(:,2), pc(:,3), '.');
axis([0 190 -30 130 -120 0]);
set(gca,'Zdir','reverse');
set(gca,'Ydir','reverse');
xlabel('X');
ylabel('Y');
zlabel('Z');
grid on;
rotate3d on;
end

