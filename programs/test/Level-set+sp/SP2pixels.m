function [ mapToPixels ] = SP2pixels(contribution, SuperPixels, properties )
% SP2pixels �������ص�ֵ ��ֵ ����Ӧ��ͼ���ÿ�����ص���
...inputs:
...contribution: 1xn, ������ÿ�������ؿ��Ծ��е�����
...properties
...outputs:
...ӳ����Щ��������Ӧ��ÿ�����ص���
[row,col]=deal(properties.sizeOfImg(1),properties.sizeOfImg(2));
mapToPixels=zeros(row,col);

for i=1:1:properties.numSP
    for j=1:1:length(SuperPixels(i).pos)
        mapToPixels(SuperPixels(i).pos(j,1),SuperPixels(i).pos(j,2))=contribution(i);
    end
end


end

