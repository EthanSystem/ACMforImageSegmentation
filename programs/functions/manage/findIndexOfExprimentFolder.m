function [ indexes ] = findIndexOfExprimentFolder( folderpath_base, folderName)
%FINDINDEXOFEXPRIMENTFOLDER Ѱ��Ҫ�����ʵ���ļ��ж�Ӧ�� �ṹ�� Results ��������
%   input:
% folderpath_base���ļ���result�Ļ���·�����ַ�����
% folderName��ʵ���ļ������֡��ַ�����
% state����֦������ֵ��
% output:
% indexes�����������顣
cell010 = struct2cell(folderpath_base);
cell010(2:end,:)=[];
cell010(1:2)=[];
temp010 = regexp(cell010 ,folderName);
indexes=find(~cellfun(@isempty, temp010));

end

