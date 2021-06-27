function [ indexes ] = findIndexOfBwImageAtEachOriginalImage( EachImage ,indexOfBwImageFolder, filename_originalImage)
%FINDINDEXOFBWIMAGEATEACHORIGINALIMAGE 寻找我们的方案中的每个原图的涂鸦图像的分割的二值图在EachImage.<我们的方案的文件夹>里的所有文件的相应字段的位置。
%   input:
% EachImage：结构体
% indexOfBwImageFolder：文件夹bw images对应在结构体EachImage.files()的索引数值。
% filename_originalImage：原始图像名称
% output:
% indexes：索引行数组。

substr = filename_originalImage;
cell010 = struct2cell(EachImage.folders(indexOfBwImageFolder).files);
cell010(2:end,:)=[];
cell010(1:2)=[];
temp010 = regexp(cell010,substr);
indexes=find(~cellfun(@isempty, temp010));

end

