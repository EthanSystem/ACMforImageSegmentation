function [ indexes ] = findIndexOfBwImageAtEachOriginalImage( EachImage ,indexOfBwImageFolder, filename_originalImage)
%FINDINDEXOFBWIMAGEATEACHORIGINALIMAGE Ѱ�����ǵķ����е�ÿ��ԭͼ��Ϳѻͼ��ķָ�Ķ�ֵͼ��EachImage.<���ǵķ������ļ���>��������ļ�����Ӧ�ֶε�λ�á�
%   input:
% EachImage���ṹ��
% indexOfBwImageFolder���ļ���bw images��Ӧ�ڽṹ��EachImage.files()��������ֵ��
% filename_originalImage��ԭʼͼ������
% output:
% indexes�����������顣

substr = filename_originalImage;
cell010 = struct2cell(EachImage.folders(indexOfBwImageFolder).files);
cell010(2:end,:)=[];
cell010(1:2)=[];
temp010 = regexp(cell010,substr);
indexes=find(~cellfun(@isempty, temp010));

end

