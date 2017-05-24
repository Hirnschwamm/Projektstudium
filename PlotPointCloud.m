function [ ] = PlotPointCloud( pc )
%GETPOINTCLOUDANDPLOTIT Summary of this function goes here
%   Detailed explanation goes here
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

