function [ index ] = findIndexOfOriginalImageAtEachContourImage( EachImage, index_eachMarkedImage ,keyword)
%FINDINDEXOFORIGINALIMAGEATEACHSCRIBBLEDIMAGE Ѱ��Ϳѻͼ���Ӧ��ԭʼͼ���λ�á�
% Ѱ�ҽṹ��EachImage���Ϳѻͼ���������Ӧ��EachImage���ԭʼͼ�������λ��
%   input:
% EachImage���ṹ��
% index_eachMarkedImage��Ϳѻ��ͼ�������ֵ��
% keyword��Ϳѻͼ��������Ĺؼ��֡�'scribble'
% output:
% indexes������ֵ��

	sublinePos = strfind(EachImage.contourImage(index_eachMarkedImage).name, ['_' keyword]);
	temp020 = [EachImage.contourImage(index_eachMarkedImage).name(1:sublinePos-1) '.jpg'];
	cell010 = struct2cell(EachImage.originalImage);
	cell010(2:end,:)=[];
	index = find(ismember(cell010(1,:),temp020));

end

