function [ indexes ] = findIndexOfBwImageAtEachState( EachImage , indexOfBwImageFolder, state)
%FINDINDEXOFBWIMAGEATEACHSTATE �˴���ʾ�йش˺�����ժҪ
%   Ѱ�����ǵķ����е�ÿ����֧��Ϳѻͼ��ķָ�Ķ�ֵͼ��EachImage.<���ǵķ������ļ���>��������ļ�����Ӧ�ֶε�λ�á�
%  ����˵��30��ͼ��ÿ��ͼ����9�Ų�ͬ��֧�Ķ�ֵͼ������Ҫ�ҵ���30��ͼ��ı�׼�𰸵Ķ�ֵͼ�ֱ��Ӧ��ÿ����֧�������֧3���Ķ�ֵͼ�� EachImage.folders<our bw
%  images->.images ����ֶζ�Ӧ������ֵ
%   input:
% EachImage���ṹ��
% indexOfBwImageFolder���ļ���bw images��Ӧ�ڽṹ��EachImage.files()��������ֵ��
% state����֦������ֵ��
% output:
% indexes�����������顣

substr=['(nbStates_)(' num2str(state) ')_'];
cell010 = struct2cell(EachImage.folders(indexOfBwImageFolder).files);
cell010(2:end,:)=[];
cell010(1:2)=[];
temp010 = regexp(cell010,substr);
indexes=find(~cellfun(@isempty, temp010));
end

