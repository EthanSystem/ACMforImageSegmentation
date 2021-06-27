function [ mapToPixels ] = SP2pixels(contribution, SuperPixels, properties )
% SP2pixels 将超像素的值 赋值 给相应的图像的每个像素点上
...inputs:
...contribution: 1xn, 给定的每个超像素可以具有的特征
...properties
...outputs:
...映射这些特征到对应的每个像素点上
[row,col]=deal(properties.sizeOfImg(1),properties.sizeOfImg(2));
mapToPixels=zeros(row,col);

for i=1:1:properties.numSP
    for j=1:1:length(SuperPixels(i).pos)
        mapToPixels(SuperPixels(i).pos(j,1),SuperPixels(i).pos(j,2))=contribution(i);
    end
end


end

