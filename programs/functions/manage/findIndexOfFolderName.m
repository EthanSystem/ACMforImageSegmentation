function [ index ] = findIndexOfFolderName( EachImage, folderName)
%FindIndexOfFolderName 此处显示有关此函数的摘要
%   寻找 EachImage 的基础文件夹下的每个存放了特定类型的图像的文件夹名称对应在 EachImage.folders 的字段编号位置
%   input:
% EachImage：结构体
% folderName：文件夹名称。字符串。
% output:
% indexes：索引值。

cell010 = struct2cell(EachImage.folders);
index =find(ismember(cell010(1,:),folderName));
end

