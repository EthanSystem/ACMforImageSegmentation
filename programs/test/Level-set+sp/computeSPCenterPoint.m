function [ centerPointPosition ] = computeSPCenterPoint( SuperPixels )
% calculateSPCenterPoint ����ÿ�������ص��е��λ������
% input:
...SuperPixels
    ...output:
    ...centerPointPosition�����ĵ�λ��
    
centerPointPosition=zeros(length(SuperPixels),3);
for i=1:1:length(SuperPixels)
    centerPointPosition(i,1)=mean(SuperPixels(i).pos(:,1),1);
    centerPointPosition(i,2)=mean(SuperPixels(i).pos(:,2),1);
    centerPointPosition(i,3)=i;
    
end

end

