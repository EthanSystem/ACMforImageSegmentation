function [ Args ] = setCopyImagesArgs( Args )
%% ���
% ��ȡָ���ļ��е�������ԭͼ��ص�ͼ����ص���ֵͼ���������ָ�����Ķ�ֵͼ����ͬһ���ļ���������һ��ɸѡ��

%% ���
% collectImagesForExtractByHuman.m ʵ����ȡ����������ͼ���Լ���ֵͼ��ָ���ļ����Ա����˹�ɸѡ
% ģʽ1 ��ȡ��Ӧͼ��������һ��ɸѡ��
% ģʽ2 ��ȡ��Ӧͼ��������Ϊ��һ��ͼ��ָ�ͷ�����ͼ�񼯺ϡ�
% ģʽ3 ��ȡ��Ӧͼ��������Ϊ��һ�����µĳ�ʼ���������зָ�ͷ�����ͼ�񼯺ϡ�

%% �û������ʼ���� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Args.mode = Args.mode ;
Args.folderpath_EachImageResourcesBaseFolder = folderpath_EachImageResourcesBaseFolder ; % ������ȡ�ļ��Ľṹ�� EachImage �Ļ���·����
Args.folderpath_EachImageInitBaseFolder=Args.folderpath_EachImageInitBaseFolder;
Args.folderpath_ResultsBaseFolder = Args.folderpath_ResultsBaseFolder; % ������ȡ�ļ��Ľṹ�� Results �Ļ���·����
Args.folderpath_extractedImageBaseFolder = Args.folderpath_experiment ; % ����ȡ���ļ���ͼ������·����
% mode = '1' or '2' :
Args.folderpath_output_ResourcesBaseFolder = Args.folderpath_output_resources ; % ����� resources ͼ���·��
Args.folderpath_output_InitBaseFolder= Args.folderpath_output_InitBaseFolder; % 
% mode = '2' :
Args.folderpath_ouput_segmentations = Args.folderpath_ouput_segmentations ; % ����� evaluation ͼ���·��
Args.isVisual = Args.isVisual ;  % ���ƹ��̲����ӻ���������������в鿴����� 'yes'��ʾ���ƹ����п��ӻ� ��'no'��ʾ���ƹ����в����ӻ���Ĭ��'no'
Args.numUselessFiles = Args.numUselessFiles; % Ҫ�ų���ͼ����������ʱ��洢ͼƬ���ļ��г�����ͼ���ļ������п�����ϵͳ�ļ��ᱻ���������Ҫ�ֶ��ų���

end

