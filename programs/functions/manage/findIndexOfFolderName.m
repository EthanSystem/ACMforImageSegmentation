function [ index ] = findIndexOfFolderName( EachImage, folderName)
%FindIndexOfFolderName �˴���ʾ�йش˺�����ժҪ
%   Ѱ�� EachImage �Ļ����ļ����µ�ÿ��������ض����͵�ͼ����ļ������ƶ�Ӧ�� EachImage.folders ���ֶα��λ��
%   input:
% EachImage���ṹ��
% folderName���ļ������ơ��ַ�����
% output:
% indexes������ֵ��

cell010 = struct2cell(EachImage.folders);
index =find(ismember(cell010(1,:),folderName));
end

