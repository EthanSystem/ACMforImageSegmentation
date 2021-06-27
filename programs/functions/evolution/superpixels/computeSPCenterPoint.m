function [ SuperPixels ] = computeSPCenterPoint( SuperPixels )
% calculateSPCenterPoint 计算每个超像素的中点的位置坐标
% input:
...SuperPixels
    ...output:
    ...centerPointPosition：中心点位置
    
centerPointPosition=zeros(length(SuperPixels),2);
for i=1:1:length(SuperPixels)
    SuperPixels(i).centerPointPosition_1=mean(SuperPixels(i).pos(:,1),1);
    SuperPixels(i).centerPointPosition_2=mean(SuperPixels(i).pos(:,2),1);
end


end

