function [ SuperPixels ] = computeSPCenterPoint( SuperPixels )
% calculateSPCenterPoint ����ÿ�������ص��е��λ������
% input:
...SuperPixels
    ...output:
    ...centerPointPosition�����ĵ�λ��
    
centerPointPosition=zeros(length(SuperPixels),2);
for i=1:1:length(SuperPixels)
    SuperPixels(i).centerPointPosition_1=mean(SuperPixels(i).pos(:,1),1);
    SuperPixels(i).centerPointPosition_2=mean(SuperPixels(i).pos(:,2),1);
end


end

