function [ indexes ] = findIndexOfBwImageAtEachState( EachImage , indexOfBwImageFolder, state)
%FINDINDEXOFBWIMAGEATEACHSTATE 此处显示有关此函数的摘要
%   寻找我们的方案中的每个分支的涂鸦图像的分割的二值图在EachImage.<我们的方案的文件夹>里的所有文件的相应字段的位置。
%  比如说，30张图像，每张图像有9张不同分支的二值图，我们要找到这30张图像的标准答案的二值图分别对应到每个分支（比如分支3）的二值图在 EachImage.folders<our bw
%  images->.images 里的字段对应的索引值
%   input:
% EachImage：结构体
% indexOfBwImageFolder：文件夹bw images对应在结构体EachImage.files()的索引数值。
% state：分枝数。数值。
% output:
% indexes：索引行数组。

substr=['(nbStates_)(' num2str(state) ')_'];
cell010 = struct2cell(EachImage.folders(indexOfBwImageFolder).files);
cell010(2:end,:)=[];
cell010(1:2)=[];
temp010 = regexp(cell010,substr);
indexes=find(~cellfun(@isempty, temp010));
end

