function [ indexes ] = findIndexOfExprimentFolder( folderpath_base, folderName)
%FINDINDEXOFEXPRIMENTFOLDER 寻找要处理的实验文件夹对应在 结构体 Results 的索引。
%   input:
% folderpath_base：文件夹result的基础路径。字符串。
% folderName：实验文件夹名字。字符串。
% state：分枝数。数值。
% output:
% indexes：索引行数组。
cell010 = struct2cell(folderpath_base);
cell010(2:end,:)=[];
cell010(1:2)=[];
temp010 = regexp(cell010 ,folderName);
indexes=find(~cellfun(@isempty, temp010));

end

