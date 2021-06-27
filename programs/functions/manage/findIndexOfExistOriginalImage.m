function [ indexes ] = findIndexOfExistOriginalImage(folderpath_object ,EachImage )
%FINDINDEXOFEXISTORIGINALIMAGE 寻找在指定文件夹 folderpath_object 中，存在的原图的对应 resources 里的索引 
%   intput:
% folderpath_object : 指定要匹配的图像的名称所在的位置。
% EachImage: 结构体 EachImage，用于指定要匹配的图像的名称的所在的完整图像库的位置。
%  output:
% indexes: 索引行数组

filename_originalImage = dir([folderpath_object '\*.jpg']);
cell010 = struct2cell(filename_originalImage);
cell010(2:end,:) = [];
cell020 = struct2cell(EachImage.originalImage);
cell020(2:end,:) = [];
for i=1:length(filename_originalImage)
	temp010 = regexp(cell020, cell010(i));
	indexes(i) = find(~cellfun(@isempty, temp010));
end


end

