function [ indexes ] = findIndexOfExistOriginalImage(folderpath_object ,EachImage )
%FINDINDEXOFEXISTORIGINALIMAGE Ѱ����ָ���ļ��� folderpath_object �У����ڵ�ԭͼ�Ķ�Ӧ resources ������� 
%   intput:
% folderpath_object : ָ��Ҫƥ���ͼ����������ڵ�λ�á�
% EachImage: �ṹ�� EachImage������ָ��Ҫƥ���ͼ������Ƶ����ڵ�����ͼ����λ�á�
%  output:
% indexes: ����������

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

