function [ centerPointPosition ] = computeSPCenterPoint( SuperPixels )
% calculateSPCenterPoint 计算每个超像素的中点的位置坐标
% input:
...SuperPixels
    ...output:
    ...centerPointPosition：中心点位置
    
centerPointPosition=zeros(length(SuperPixels),3);
for i=1:1:length(SuperPixels)
    centerPointPosition(i,1)=mean(SuperPixels(i).pos(:,1),1);
    centerPointPosition(i,2)=mean(SuperPixels(i).pos(:,2),1);
    centerPointPosition(i,3)=i;
    
end

end

