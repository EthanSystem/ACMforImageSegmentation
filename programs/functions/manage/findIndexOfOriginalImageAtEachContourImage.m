function [ index ] = findIndexOfOriginalImageAtEachContourImage( EachImage, index_eachMarkedImage ,keyword)
%FINDINDEXOFORIGINALIMAGEATEACHSCRIBBLEDIMAGE 寻找涂鸦图像对应的原始图像的位置。
% 寻找结构体EachImage里的涂鸦图像的索引对应在EachImage离的原始图像的索引位置
%   input:
% EachImage：结构体
% index_eachMarkedImage：涂鸦的图像的索引值。
% keyword：涂鸦图像的命名的关键字。'scribble'
% output:
% indexes：索引值。

	sublinePos = strfind(EachImage.contourImage(index_eachMarkedImage).name, ['_' keyword]);
	temp020 = [EachImage.contourImage(index_eachMarkedImage).name(1:sublinePos-1) '.jpg'];
	cell010 = struct2cell(EachImage.originalImage);
	cell010(2:end,:)=[];
	index = find(ismember(cell010(1,:),temp020));

end

